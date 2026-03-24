# Environment Setup

## Prerequisites

- GCP account with billing enabled
- `gcloud` CLI installed and authenticated
- Python 3.10+


## GCP Configuration

1. Create a GCP project and enable the required APIs (BigQuery, Cloud Storage, IAM).
2. Create a service account with the following roles:
   - `roles/storage.objectAdmin`
   - `roles/bigquery.dataEditor`
   - `roles/bigquery.jobUser`
3. Generate a JSON key for the service account and store it outside the repository
   (recommended: `~/.gcp/<project>-sa.json`).
4. Copy `.env.example` to `.env` and fill in the required values.
5. Set `GOOGLE_APPLICATION_CREDENTIALS` to the absolute path of your key file.


## GCS Bucket

The raw data landing zone is a GCS bucket with uniform bucket-level access enabled.

- Bucket: `olist-analytics-eng-raw`
- Region: `us-central1`
- Raw source files: `raw/olist/`

To upload source files:
```bash
gsutil -m cp /path/to/datasets/*.csv gs://olist-analytics-eng-raw/raw/olist/
```


## dbt Setup

dbt Core connects to BigQuery using a `profiles.yml` file stored locally at `~/.dbt/profiles.yml`.
This file is not committed to the repository as it contains local paths and credentials.
A reference template is available at `olist_dbt/profiles.yml.example`.

### Steps

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

