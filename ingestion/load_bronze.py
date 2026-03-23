"""
Bronze layer ingestion script.

Loads raw CSV files from GCS into BigQuery Bronze tables using a
truncate-and-insert strategy. Configuration is driven by manifest.json.
"""

import json
import logging
import os
import sys
from pathlib import Path

from dotenv import load_dotenv
from google.cloud import bigquery

load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


def get_env(key: str) -> str:
    value = os.getenv(key)
    if not value:
        logger.error(f"Missing required environment variable: {key}")
        sys.exit(1)
    return value


def load_manifest(path: Path) -> dict:
    with open(path) as f:
        return json.load(f)


def build_gcs_uri(bucket: str, gcs_path: str) -> str:
    return f"gs://{bucket}/{gcs_path}"


def load_table(
    client: bigquery.Client,
    project_id: str,
    dataset_id: str,
    table_id: str,
    gcs_uri: str,
    options: dict = None
    ) -> None:
    destination = f"{project_id}.{dataset_id}.{table_id}"
    options = options or {}

    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        autodetect=False,
        allow_quoted_newlines=options.get("allow_quoted_newlines", False)
    )

    logger.info(f"Loading {table_id} from {gcs_uri}")

    load_job = client.load_table_from_uri(
        gcs_uri,
        destination,
        job_config=job_config
    )
    load_job.result()

    table = client.get_table(destination)
    logger.info(f"Loaded {table.num_rows:,} rows into {destination}")


def main():
    project_id = get_env("GCP_PROJECT_ID")
    bucket_name = get_env("GCS_BUCKET_NAME")
    dataset_id = get_env("BQ_BRONZE_DATASET")

    manifest_path = Path(__file__).parent / "manifest.json"
    manifest = load_manifest(manifest_path)

    client = bigquery.Client(project=project_id)

    success, failed = [], []

    for entry in manifest["tables"]:
        table_id = entry["table_id"]
        gcs_uri = build_gcs_uri(bucket_name, entry["gcs_path"])
        try:
            load_table(
                client,
                project_id,
                dataset_id,
                table_id,
                gcs_uri,
                options=entry.get("options", {})
            )
            success.append(table_id)
        except Exception as e:
            logger.error(f"Failed to load {table_id}: {e}")
            failed.append(table_id)

    logger.info(f"Load complete. Success: {len(success)}, Failed: {len(failed)}")

    if failed:
        logger.error(f"Failed tables: {', '.join(failed)}")
        sys.exit(1)


if __name__ == "__main__":
    main()
