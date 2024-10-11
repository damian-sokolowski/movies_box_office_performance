help:
	@echo load_source_data
	@echo -e "\tmake load_source_data"
	@echo
	@echo dbt
	@echo -e "\tmake dbt run"
	@echo -e "\tmake dbt run --full-refresh"
	@echo -e "\tmake dbt run --select tag:dev"
	@echo -e "\tmake dbt test"
	@echo -e "\tmake dbt deps"
	@echo -e "\tmake dbt clean"
	@echo -e "\tmake dbt compile"

load_source_data:
	docker compose run --rm -uroot backend python modules/load_source_data.py

dbt:
	docker compose run --rm -uroot backend dbt $(filter-out $@,$(MAKECMDGOALS))