# 🏥 Healthcare Data Engineering Pipeline

> An end-to-end Azure data engineering project that ingests, transforms, and visualises healthcare patient records using **Azure Data Factory**, **Azure Data Lake Storage Gen2**, **Azure SQL Database**, and **Power BI**.

---

## 📌 Project Overview

This project demonstrates a complete cloud-based data pipeline built on Microsoft Azure. Raw healthcare datasets are ingested from GitHub, transformed through multi-stage ADF Mapping Data Flows, loaded into Azure SQL Database, and finally visualised in Power BI dashboards.

**Domain:** Healthcare Analytics  
**Cloud Platform:** Microsoft Azure  
**Status:** 🟢 In Progress

---

## 🏗️ Architecture

```
GitHub (CSV Datasets)
        │
        ▼
Azure Data Factory (Copy Activity)
        │
        ▼
ADLS Gen2 — raw/ container
        │
        ▼
ADF Mapping Data Flow
  ├── Filter Transformation    → Europe-only records, exclude nulls
  ├── Select Transformation    → Field pruning & column renaming
  └── Sink Transformation      → Write to processed/ container
        │
        ▼
ADLS Gen2 — processed/ container
        │
        ▼
Azure Data Factory (Copy Activity)
        │
        ▼
Azure SQL Database (healthcare_reporting schema)
        │
        ▼
Power BI Desktop (DirectQuery)
        │
        ▼
Interactive Dashboards & Reports
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Cloud Platform | Microsoft Azure |
| Orchestration | Azure Data Factory (ADF) v2 |
| Storage | Azure Data Lake Storage Gen2 |
| Database | Azure SQL Database |
| Transformation | ADF Mapping Data Flows |
| Reporting | Power BI Desktop (DirectQuery) |
| Source Control | GitHub |
| Data Format | CSV |

---

## 📂 Repository Structure

```
oftentrain_healthcare_dataset/
│
└── patients_record.csv        # Raw healthcare dataset
│
└── create_healthcare_tables.sql  # DDL scripts for Azure SQL DB
│
└── README.md
```

---

## 🔄 Pipeline Breakdown

### 1. Data Ingestion — `pl_ingest_patients_record_data`
- **Source:** GitHub raw CSV via HTTP linked service (`ls_http_healthcare_reporting`)
- **Sink:** ADLS Gen2 `raw/patients_record/` container (`ls_adls_healthcarereportingdl`)
- **Activity:** ADF Copy Activity
- Validates successful file landing in raw container before proceeding

### 2. Data Transformation — `df_transform_patients_record`
ADF Mapping Data Flow with the following stages:

| Step | Transformation | Logic |
|---|---|---|
| 1 | **Source** | Read from `raw/patients_record.csv` in ADLS Gen2 |
| 2 | **Filter** | `mainland == 'Europe' && not(isNull(territory_code))` |
| 3 | **Select** | Drop unused columns; rename `test_units` → `units` |
| 4 | **Sink** | Write to `processed/healthcare/` container |

### 3. Load to SQL — `pl_sqlize_healthcare_data`
- Reads processed CSV from ADLS Gen2 using wildcard file path
- Runs `TRUNCATE TABLE` pre-copy script for idempotent loads
- Loads into `healthcare_reporting.patients_record` in Azure SQL DB

### 4. Power BI Reporting
Connected via **DirectQuery** to Azure SQL Database. Dashboards include:

- 📊 **Pie Chart** — Accepted vs. rejected cases by country (`mark` field)
- 🍩 **Donut Chart** — Count of countries by origin
- 🗂️ **Table** — Territory codes mapped to country names
- 🔢 **Card Visual** — First batch ID reference

---

## 🗄️ SQL Schema

```sql
CREATE SCHEMA healthcare_reporting
GO

CREATE TABLE healthcare_reporting.patients_record
(
    recordId           VARCHAR(50),
    country            VARCHAR(100),
    territory_code     VARCHAR(10),
    population_count   BIGINT,
    batch_id           VARCHAR(50),
    is_valid_record    BIT,
    mark               VARCHAR(100),
    regular_count      INT,
    origin             VARCHAR(100),
    units              VARCHAR(50)
)
GO
```

---

## ☁️ Azure Resources Used

| Resource | Name |
|---|---|
| Resource Group | `HealthCare_Project_RG` |
| Data Factory | `healthcare-reporting-adf` |
| Storage Account | `healthcarereportingdl` (ADLS Gen2) |
| SQL Server | `healthcare-ot-srv` |
| SQL Database | `healthcare-db` |

---

## 🚀 Getting Started

### Prerequisites
- Active Azure subscription
- Power BI Desktop installed
- GitHub account

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/triasa5/oftentrain_healthcare_dataset.git
   ```

2. **Provision Azure resources** — Create a Resource Group, Data Factory, Storage Account (with Hierarchical Namespace enabled), and Azure SQL Database on Azure Portal.

3. **Set up SQL schema** — Run `sql/create_healthcare_tables.sql` in the Azure SQL Query Editor.

4. **Configure ADF linked services** — Connect to GitHub (HTTP) and ADLS Gen2 (Account Key).

5. **Run ingestion pipeline** — Trigger `pl_ingest_patients_record_data` to land raw data in ADLS.

6. **Run transformation pipeline** — Trigger `pl_healthcare_data` to process and write to the processed container.

7. **Run SQL load pipeline** — Trigger `pl_sqlize_healthcare_data` to populate Azure SQL DB.

8. **Connect Power BI** — Open Power BI Desktop → Get Data → Azure SQL Database → DirectQuery → load `healthcare_reporting.patients_record`.

---

## 📈 Key Learnings

- Designing scalable ADF pipelines with linked services, datasets, and data flows
- Applying multi-stage transformations (Filter, Select, Sink) in ADF Mapping Data Flows
- Implementing idempotent SQL load patterns with pre-copy TRUNCATE scripts
- Connecting cloud databases to Power BI for real-time DirectQuery reporting
- Managing Azure resource groups and storage redundancy strategies (LRS/ZRS/GRS)

---

## 👩‍💻 Author

**Triasa Munshi**  
Software Engineer | Azure & Data Engineering Enthusiast  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-triasa--munshi-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/triasa-munshi/)  
[![GitHub](https://img.shields.io/badge/GitHub-triasa5-black?style=flat&logo=github)](https://github.com/triasa5)

---

*Built as part of a personal data engineering learning initiative to gain hands-on experience with Azure cloud services.*
