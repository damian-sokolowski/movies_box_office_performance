from abc import ABC, abstractmethod

from sqlalchemy.sql.ddl import CreateSchema

class BaseService(ABC):
    @property
    def db_engine(self):
        return self._db_engine

    @db_engine.setter
    def db_engine(self, value):
        self._db_engine = value

    @property
    @abstractmethod
    def _db_schema(self):
        pass

    def _create_schema(self):
        with self._db_engine.connect() as connection:
            connection.execute(
                CreateSchema(self._db_schema, if_not_exists=True),
            )
            connection.commit()

    @abstractmethod
    def load(self):
        pass