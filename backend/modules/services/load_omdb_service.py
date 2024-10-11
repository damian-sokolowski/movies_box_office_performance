import pandas as pd
from omdbapi.movie_search import GetMovie, GetMovieException
from sqlalchemy.sql import text

from config import settings
from modules.services.base_service import BaseService

TITLE_QUERY = """
    SELECT DISTINCT title 
    FROM {raw_revenue_schema}.{revenues_source_table};
"""

class LoadOmdbService(BaseService):
    def __init__(self, db_engine):
        self._db_engine = db_engine
        self._create_schema()
        self._movie = GetMovie(api_key=settings.OMDB_API_KEY)

    @property
    def _db_schema(self):
        return settings.RAW_SCHEMA

    def _get_titles_to_load(self):
        with self._db_engine.connect() as connection:
            query = text(
                TITLE_QUERY.format(
                    raw_revenue_schema=settings.RAW_SCHEMA,
                    revenues_source_table=settings.REVENUES_SOURCE_TABLE,
                ),
            )
            result = connection.execute(query)
            return [row[0] for row in result]

    def _get_movie(self, title, retry_count=0):
        try:
            self._movie.get_movie(title)
            return self._movie.get_data(
                "title",
                "year",
                "rated",
                "released",
                "runtime",
                "genre",
                "director",
                "writer",
                "actors",
                "plot",
                "language",
                "country",
                "awards",
                "poster",
                "metascore",
                "imdbrating",
                "imdbvotes",
                "imdbid",
                "type",
                "dvd",
                "boxoffice",
                "production",
                "website",
            )
        except GetMovieException as exc:
            print(f"Error: {exc}. Title: {title}.")
        except Exception as exc:
            print(f"Error: {exc}. Title: {title}. Retry count: {retry_count}.")
            if retry_count < 3:
                return self._get_movie(title, retry_count + 1)

    def _get_movies_data(self):
        movies_data = []
        for title in self._get_titles_to_load():
            movie = self._get_movie(title)
            if movie:
                movies_data.append(movie)
        return movies_data

    def load(self):
        movies_data = self._get_movies_data()
        df = pd.DataFrame(movies_data)
        df.to_sql(
            settings.OMDB_MOVIES_SOURCE_TABLE,
            self._db_engine,
            schema=self._db_schema,
            if_exists="replace",
            index=False,
            chunksize=1000,
        )
