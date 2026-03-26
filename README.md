# Olist Analytics Engineering

[![CI - dbt build on pull request](https://github.com/cardonajsebas/olist-analytics-engineering/actions/workflows/ci.yml/badge.svg)](https://github.com/cardonajsebas/olist-analytics-engineering/actions/workflows/ci.yml)
[![CD - dbt build on merge to main](https://github.com/cardonajsebas/olist-analytics-engineering/actions/workflows/cd.yml/badge.svg)](https://github.com/cardonajsebas/olist-analytics-engineering/actions/workflows/cd.yml)

An end-to-end analytics engineering platform built on the [Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) public dataset. This project migrates the data warehouse built in [Phase 1](https://github.com/cardonajsebas/olist-data-warehouse) to a production-grade cloud stack using **dbt**, **BigQuery**, and **GCP**, with CI/CD automation through **GitHub Actions**.

> Built as a portfolio project to demonstrate analytics engineering practices including cloud infrastructure, transformation pipelines, data quality testing, and deployment automation.

**Data catalog and lineage graph:** [cardonajsebas.github.io/olist-analytics-engineering](https://cardonajsebas.github.io/olist-analytics-engineering)

---

## Context

This project is the second phase of a data warehouse initiative. Phase 1 established the data model and ETL pipeline using PostgreSQL and a Medallion Architecture (Bronze, Silver, Gold). The architecture and migration plan were designed prior to implementation and are documented in the [Roadmap](#roadmap) section below. Phase 2 lifts that foundation to the cloud, replacing manual SQL scripts with dbt models and introducing automated testing and deployment.

If you are not familiar with Phase 1, it is recommended to review it first: [olist-data-warehouse](https://github.com/cardonajsebas/olist-data-warehouse).

---

## Architecture

![Data Architecture Diagram](docs/data_architecture.png)

| Layer | Tool | Description |
|---|---|---|
| Storage | GCS | Raw CSV files stored as the landing zone |
| Warehouse | BigQuery | Columnar analytical engine hosting all layers |
| Transformation | dbt Core | Models, tests, and documentation across Bronze, Silver, and Gold |
| Orchestration | Python + GCS | Initial load scripts |
| CI/CD | GitHub Actions | Automated testing and deployment on pull requests and merges |
| Documentation | dbt docs | Auto-generated data catalog and lineage graph |

---

## Data Layers

Following the same Medallion Architecture established in Phase 1, now implemented as dbt models materialized in BigQuery.

| Layer | Materialization | Description |
|---|---|---|
| Bronze | Table | Raw data loaded from GCS as-is, no transformations |
| Silver | Table | Cleaned, typed, and standardized models (1:1 with Bronze sources) |
| Gold | View | Business-ready Star Schema with generic and singular dbt tests |

---

## Data Model

The Gold layer implements a Star Schema with one fact table and four dimension tables, all materialized as views derived from Silver.

| Model | Type | Grain | Description |
|---|---|---|---|
| `fact_orders` | Fact | One row per order item | Core analytical model joining orders, items, and payments |
| `dim_customers` | Dimension | One row per customer | Customer records enriched with geolocation coordinates |
| `dim_products` | Dimension | One row per product | Product catalog enriched with English category names |
| `dim_sellers` | Dimension | One row per seller | Seller records enriched with geolocation coordinates |
| `dim_date` | Dimension | One row per date | Calendar attributes derived from order purchase timestamps |

`fact_orders` joins to all four dimensions: `customer_id` to `dim_customers`, `product_id` to `dim_products`, `seller_id` to `dim_sellers`, and `order_date` to `dim_date`.

The full lineage graph is available in the [dbt docs site](https://cardonajsebas.github.io/olist-analytics-engineering).

---

## Tech Stack

| Tool | Purpose |
|---|---|
| **dbt Core** | Data transformation, testing, and documentation |
| **BigQuery** | Cloud data warehouse (analytical layer) |
| **Google Cloud Storage** | Raw data landing zone |
| **Google Cloud Platform** | Cloud infrastructure and IAM |
| **GitHub Actions** | CI/CD pipeline for automated testing and deployment |
| **Python** | GCS ingestion scripts and environment setup |

---

## CI/CD

This project uses two GitHub Actions workflows to automate testing and deployment.

| Workflow | Trigger | Purpose |
|---|---|---|
| CI - dbt build on pull request | Pull request to `main` | Runs `dbt build --target prod` as a quality gate. Blocks merge if any model or test fails. |
| CD - dbt build on merge to main | Push to `main` | Runs `dbt build --target prod` to deploy the latest approved models to prod BigQuery datasets. |

Both workflows authenticate to GCP using a dedicated CI service account with minimum required permissions (`roles/bigquery.dataEditor` and `roles/bigquery.jobUser`). Credentials are stored as GitHub Actions secrets and never appear in logs or version control.

A third workflow publishes the dbt documentation site to GitHub Pages on every merge to main.

---

## Project Status

This project is tracked on [GitHub Projects](https://github.com/cardonajsebas/olist-analytics-engineering/projects).

| Milestone | Description | Status |
|---|---|---|
| 1 - GCP Foundation & Raw Ingestion | Cloud infrastructure setup and raw data loading into BigQuery Bronze | Done |
| 2 - dbt Setup & Silver Layer | dbt project initialization and Bronze-to-Silver transformation models | Done |
| 3 - dbt Gold Layer & Data Quality | Star Schema models and automated data quality tests | Done |
| 4 - CI/CD with GitHub Actions | Automated testing and deployment pipeline | Done |
| 5 - Documentation & Portfolio Polish | dbt docs site, lineage graph, and README completion | Done |

---

## Repository Structure

```
olist-analytics-engineering/
│
├── .github/
│   └── workflows/
│       ├── ci.yml                  # dbt build on pull requests
│       ├── cd.yml                  # dbt build on merge to main
│       └── docs.yml                # dbt docs publish to GitHub Pages
│
├── ingestion/                      # Python scripts for GCS and BigQuery loading
│   ├── ddl/
│   │   └── bronze/                 # Bronze table DDL scripts
│   ├── validation/                 # Bronze layer validation SQL scripts
│   ├── load_bronze.py              # Main ingestion script
│   └── manifest.json               # Table-to-GCS path mapping
│
├── olist_dbt/                      # dbt project root
│   ├── models/
│   │   ├── bronze/                 # Source definitions
│   │   ├── silver/                 # Cleaning and standardization models
│   │   └── gold/                   # Analytical Star Schema models
│   ├── tests/                      # Custom singular tests
│   ├── macros/                     # generate_schema_name macro
│   ├── dbt_project.yml
│   └── profiles.yml.example
│
├── docs/                           # Architecture diagrams and setup documentation
│
├── .env.example
├── README.md
└── LICENSE
```

---

## Prerequisites

- GCP account with billing enabled
- `gcloud` CLI installed and authenticated (`gcloud auth login`)
- Python 3.10+
- dbt Core with BigQuery adapter (`dbt-bigquery`)
- A service account JSON key with the following roles:
  - `roles/storage.objectAdmin`
  - `roles/bigquery.dataEditor`
  - `roles/bigquery.jobUser`

See [docs/setup.md](docs/setup.md) for step-by-step setup instructions.

---

## How to Run

### 1. Environment setup

Follow [docs/setup.md](docs/setup.md) to configure GCP credentials and the dbt profile.

### 2. Install dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 3. Load Bronze layer

```bash
python ingestion/load_bronze.py
```

### 4. Validate Bronze load

```bash
bq query --project_id=YOUR_PROJECT_ID --use_legacy_sql=false \
  < ingestion/validation/validate_row_counts.sql
```

### 5. Build all models and run all tests

```bash
cd olist_dbt
dbt build --profiles-dir ~/.dbt
```

`dbt build` runs models and tests in dependency order. If a Silver model fails its tests, downstream Gold models are skipped automatically.

### Running models and tests independently

```bash
# Run a specific layer
dbt run --select 'silver' --profiles-dir ~/.dbt
dbt run --select 'gold' --profiles-dir ~/.dbt

# Run all tests
dbt test --profiles-dir ~/.dbt

# Run only singular tests
dbt test --select 'test_type:singular' --profiles-dir ~/.dbt
```

---

## Roadmap

**Milestone 1 - GCP Foundation & Raw Ingestion**

GCP project provisioned, APIs enabled, IAM service accounts configured. GCS bucket created with source-system folder structure (`crm/`, `erp/`). BigQuery Bronze datasets provisioned and all 9 source CSVs loaded via a data-driven Python ingestion script. Bronze validation confirmed row counts, nulls, and schema integrity.

**Milestone 2 - dbt Setup & Silver Layer**

dbt Core initialized with BigQuery adapter. Bronze sources declared in `sources.yml`. All 9 Silver models implemented covering type casting, standardization, deduplication, and null handling. Custom `generate_schema_name` macro implemented for dev and prod environment routing.

**Milestone 3 - dbt Gold Layer & Data Quality**

Star Schema implemented as dbt Gold views: `fact_orders` at order-item grain and four dimension models. Generic dbt tests added across Silver and Gold covering uniqueness, non-null constraints, accepted values, and referential integrity. Four custom singular tests validate business rules including delivery date ordering and price positivity.

**Milestone 4 - CI/CD with GitHub Actions**

Dedicated CI service account created with least-privilege roles. Dev and prod environments separated via dbt target routing. GitHub Actions CI workflow runs `dbt build` on every pull request. CD workflow deploys to prod on every merge to main. Full pipeline runs in under 90 seconds.

**Milestone 5 - Documentation & Portfolio Polish**

dbt documentation site generated and published to GitHub Pages via GitHub Actions. Live catalog and lineage graph accessible publicly. README finalized with Data Model section, CI/CD documentation, and workflow status badges. Repository topics and metadata optimized.

---

## Credits

This project extends the work from [olist-data-warehouse](https://github.com/cardonajsebas/olist-data-warehouse), which was developed following the methodology of **Baraa Khatib Salkini** ([Data With Baraa](https://www.datawithbaraa.com)).

The Olist dataset is sourced from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

---

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute it with proper attribution.

---

## About

Built by **John S Cardona** as a portfolio project demonstrating analytics engineering skills on a cloud-native stack.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/sebastian-cardona)
[![Portfolio](https://img.shields.io/badge/Portfolio-000000?style=for-the-badge&logo=google-chrome&logoColor=white)](https://cardonajsebas.github.io/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/cardonajsebas)