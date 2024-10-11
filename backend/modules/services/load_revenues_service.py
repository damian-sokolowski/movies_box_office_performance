from pathlib import Path

import pandas as pd

from config import settings
from modules.services.base_service import BaseService

REVENUES_DIR_PATH = "datastore_to_import/revenues"

class LoadRevenuesService(BaseService):
    def __init__(self, db_engine):
        self._db_engine = db_engine
        self._create_schema()

    @property
    def _db_schema(self):
        return settings.RAW_SCHEMA

    def _read_csv(self, path):
        df = pd.read_csv(path)
        df.dropna(subset=["title"], inplace=True)
        return df

    def load(self):
        breakpoint()
        for path in Path(REVENUES_DIR_PATH).glob("*.csv"):
            df = self._read_csv(path)
            df.to_sql(
                settings.REVENUES_SOURCE_TABLE,
                self._db_engine,
                schema=self._db_schema,
                if_exists="replace",
                index=False,
                chunksize=1000,
            )

