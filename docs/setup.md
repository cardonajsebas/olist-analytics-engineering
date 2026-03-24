# Environment Setup

## Prerequisites

- GCP account with billing enabled
- `gcloud` CLI installed and authenticated
- Python 3.10+

## Python Environment

1. Create and activate a virtual environment from the repo root:
```bash
   python3 -m venv .venv
   source .venv/bin/activate
```

2. Install dependencies:
```bash
   pip install -r requirements.txt
```

## GCP Configuration

1. Create a GCP project and enable the required APIs (BigQuery, Cloud Storage, IAM):
```bash
   gcloud projects create YOUR_PROJECT_ID --name="Your Project Name"
   gcloud config set project YOUR_PROJECT_ID
   gcloud services enable bigquery.googleapis.com storage.googleapis.com iam.googleapis.com
```

2. Create a service account with the following roles:
   - `roles/storage.objectAdmin`
   - `roles/bigquery.dataEditor`
   - `roles/bigquery.jobUser`
```bash
   gcloud iam service-accounts create YOUR_SA_NAME \
     --display-name="Your SA Display Name"

   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:YOUR_SA_NAME@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/storage.objectAdmin"

   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:YOUR_SA_NAME@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/bigquery.dataEditor"

   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:YOUR_SA_NAME@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/bigquery.jobUser"
```

3. Generate a JSON key and store it outside the repository:
```bash
   mkdir -p ~/.gcp
   gcloud iam service-accounts keys create ~/.gcp/YOUR_PROJECT_ID-sa.json \
     --iam-account=YOUR_SA_NAME@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

4. Copy `.env.example` to `.env` and fill in the required values:
```bash
   cp .env.example .env
```

5. Add `GOOGLE_APPLICATION_CREDENTIALS` to your shell config:
```bash
   echo 'export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/YOUR_PROJECT_ID-sa.json' >> ~/.zshrc
   source ~/.zshrc
```

## GCS Bucket

The raw data landing zone is a GCS bucket with uniform bucket-level access enabled.

- Bucket: `olist-analytics-eng-raw`
- Region: `us-central1`
- Source files are organized by source system:
  - CRM files: `raw/olist/crm/`
  - ERP files: `raw/olist/erp/`

To upload source files:
```bash
gsutil -m cp /path/to/datasets/crm/*.csv gs://olist-analytics-eng-raw/raw/olist/crm/
gsutil -m cp /path/to/datasets/erp/*.csv gs://olist-analytics-eng-raw/raw/olist/erp/
```

## BigQuery Datasets

Three datasets must exist before running the ingestion script or dbt models.
They are created automatically if you follow the GCP Configuration steps above, or manually:
```bash
bq mk --dataset --location=us-central1 YOUR_PROJECT_ID:bronze
bq mk --dataset --location=us-central1 YOUR_PROJECT_ID:silver
bq mk --dataset --location=us-central1 YOUR_PROJECT_ID:gold
```

## dbt Setup

dbt Core connects to BigQuery using a `profiles.yml` file stored locally at `~/.dbt/profiles.yml`.
This file is not committed to the repository as it contains local paths and credentials.
A reference template is available at `olist_dbt/profiles.yml.example`.

1. Copy the example profile and edit it with your local values:
```bash
   cp olist_dbt/profiles.yml.example ~/.dbt/profiles.yml
```

2. Update the following fields in `~/.dbt/profiles.yml`:
   - `project` - your GCP project ID
   - `keyfile` - absolute path to your service account JSON key

3. From the `olist_dbt/` directory, validate the connection:
```bash
   dbt debug --profiles-dir ~/.dbt
```
   All checks should return `OK`.

