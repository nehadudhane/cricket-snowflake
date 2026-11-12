# ODI Cricket Analytics — Snowflake Data Engineering Project

A Snowflake data engineering project exploring **nested cricket JSON ingestion**, **semi-structured data transformation**, and **dimensional modeling** for ODI match analytics. The SQL is organized into landing, raw, clean, and consumption layers.

> **Scope:** The supplied archive includes six SQL worksheets and a detailed learning document. The document also describes streams, tasks, and dashboards; **their implementations are not present in the supplied SQL files**. This repository does not claim that orchestration or dashboard deployment was verified.

## Architecture

```text
ODI cricket match JSON files
           |
           v
LAND   | cricket.land        | JSON file format + internal stage
           |
           v
RAW    | cricket.raw         | COPY INTO + match JSON and ingestion metadata
           |
           v
CLEAN  | cricket.clean       | LATERAL FLATTEN + match, player, delivery tables
           |
           v
CONSUMPTION | cricket.consumption | Dimension and fact tables
           |
           v
       Analytics-ready SQL model
```

## Technology stack

- Snowflake SQL and Snowflake virtual warehouses
- Internal stages, JSON file formats, and `COPY INTO`
- Semi-structured types: `OBJECT`, `VARIANT`, `ARRAY`
- JSON path expressions and `LATERAL FLATTEN`
- Transient tables, constraints, and relational dimensional modeling

## Repository structure

```text
cricket-snowflake/
├── README.md
├── sql/
│   ├── 01_setup/
│   │   └── 01-schema creation.sql
│   ├── 02_raw_ingestion/
│   │   └── 02-raw-zone.sql
│   ├── 03_clean_layer/
│   │   ├── 0.3.1-clean-zone.sql
│   │   ├── 0.3.2-clean-zone.sql
│   │   └── 03.3-clean-zone.sql
│   └── 04_consumption_model/
│       └── fact-dim-tables.sql
└── docs/
    └── Cricket_Snowflake_Project_Documentation_Detailed_BW.docx
```

## SQL guide and suggested execution order

| Order | File | Purpose |
| --- | --- | --- |
| 1 | [`01-schema creation.sql`](sql/01_setup/01-schema%20creation.sql) | Create the `cricket` database, `land`, `raw`, `clean` and `consumption` schemas, JSON format, and internal stage |
| 2 | [`02-raw-zone.sql`](sql/02_raw_ingestion/02-raw-zone.sql) | Create `match_raw_tbl` and load staged JSON using `COPY INTO`, retaining ingestion metadata |
| 3 | [`0.3.1-clean-zone.sql`](sql/03_clean_layer/0.3.1-clean-zone.sql) | Extract match and event details from `info` into `match_detail_clean` |
| 4 | [`0.3.2-clean-zone.sql`](sql/03_clean_layer/0.3.2-clean-zone.sql) | Flatten nested player information and define player relationships |
| 5 | [`03.3-clean-zone.sql`](sql/03_clean_layer/03.3-clean-zone.sql) | Flatten innings, overs and deliveries; define delivery relationships and exploratory aggregates |
| 6 | [`fact-dim-tables.sql`](sql/04_consumption_model/fact-dim-tables.sql) | Define dimension and fact structures, date data, and example delivery fact loading |

## Data model

The consumption-layer script defines dimension tables such as `date_dim`, `team_dim`, `player_dim`, `venue_dim`, `referee_dim`, and `match_type_dim`, alongside `match_fact` and `delivery_fact`.

The example joins deliveries with team and player dimensions and models runs, extras, batting/bowling identities, and dismissals. These scripts are **learning/project artifacts**; they have not been run or tested as part of this repository packaging.

## How to use

1. Provision a Snowflake environment with the required privileges and warehouse (`compute_wh` in these examples).
2. Execute the setup SQL to create the database, schemas, stage, and JSON file format.
3. Upload compatible ODI cricket JSON files to the expected stage path (`@cricket.land.my_stg/cricket/json`). **The source JSON files are not included** in this repository.
4. Run the raw ingestion SQL and inspect the raw record count.
5. Review and execute clean-layer statements and the consumption model in dependency order. Some original SQL contains typos or column mismatches and may need corrections in your execution environment; the source files are intentionally preserved as uploaded.

### Included documentation

The [`detailed project document`](docs/Cricket_Snowflake_Project_Documentation_Detailed_BW.docx) explains the architecture and learning concepts in more depth. It references additional tutorial stages not represented by separate SQL worksheets in this archive.

## Notes

- The original SQL uses `ACCOUNTADMIN` for learning purposes; production environments should use appropriately scoped roles.
- `CREATE OR REPLACE` statements may replace existing objects and should be reviewed before execution.
- The SQL includes a large literal date-series insert; it is retained unchanged for reproducibility of the original example.
- The repository documents an implementation attempt and its learning materials rather than independently verified execution metrics.

## Author

**Neha Dudhane** — [GitHub](https://github.com/nehadudhane)
