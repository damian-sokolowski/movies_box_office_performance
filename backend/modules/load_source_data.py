from sqlalchemy import URL, create_engine

from config import settings
from modules.services.load_omdb_service import LoadOmdbService
from modules.services.load_revenues_service import LoadRevenuesService

if __name__ == "__main__":
    db_uri = URL.create(**settings.DATABASE)
    engine = create_engine(db_uri)
    revenues_service = LoadRevenuesService(engine)
    revenues_service.load()
    omdb_service = LoadOmdbService(engine)
    omdb_service.load()