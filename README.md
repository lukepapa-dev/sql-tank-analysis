# Tank Chlorine Monitoring Analysis (SQL)

![SQL](https://img.shields.io/badge/SQL-SQLite-blue)
![Database](https://img.shields.io/badge/Database-SQLite-green)
![Project Type](https://img.shields.io/badge/Project-Data%20Analysis-orange)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

## Project Summary
This project analyzes operational tank chlorine monitoring data using SQL to identify limit breaches, assess system performance, and highlight high-risk locations. The dataset was imported into a SQLite database, cleaned using SQL views, and analyzed using structured queries to generate operational insights.

This simulates a real-world data analyst workflow: database ingestion → cleaning → querying → reporting.

## Dataset Overview
- Total records: 12,066  
- Parameters monitored: 6  
- Localities: 12  
- Sample points: 37  
- Total limit breaches: 31  
- Overall breach rate: 0.26%  

## Tools and Technologies
- SQLite
- SQL
- DB Browser for SQLite
- CSV data processing

## Database Workflow
1. Imported CSV into SQLite table `tank_data`
2. Created cleaned analysis view `v_results_clean`
3. Performed SQL aggregation and trend analysis
4. Exported results for reporting and documentation

Database:
db/ops_results.db

SQL scripts:
sql/01_create_clean_view.sql  
sql/02_analysis_queries.sql  

## Key Findings

### Primary risk parameter
Chlorine, Free was responsible for all breaches.

- Tests performed: 6,077  
- Breaches: 31  
- Breach rate: 0.51%  

This confirms chlorine concentration is the primary operational risk variable.

### Highest risk locations
- Southford: 24 breaches (77% of total breaches)
- Mountcrest: 3 breaches
- Newvale: 2 breaches
- Portvale: 1 breach
- Portford: 1 breach

Southford is the highest operational priority location.

### Operational performance trend
Breaches were rare and occurred sporadically, indicating generally stable system performance with isolated deviations.

## Example SQL Query
SELECT locality, SUM(limit_breached) AS breaches
FROM v_results_clean
GROUP BY locality
ORDER BY breaches DESC;

## Project Structure
project-2-sql-tank-analysis/
├ data/
│  tank_data.csv
├ db/
│  ops_results.db
├ sql/
│  01_create_clean_view.sql
│  02_analysis_queries.sql
├ output/
│  basic_summary.csv
│  limit_breaches_by_parameter.csv
│  limit_breaches_by_locality.csv
│  monthly_count_breaches.csv
│  latest_readings.csv
│  top_parameters_by_volume.csv
│  user_breaches.csv
└ README.md

## Skills Demonstrated
- SQL data querying and aggregation
- Database creation and CSV ingestion
- Data cleaning using SQL views
- Operational KPI analysis
- Trend and anomaly detection
- Reproducible analytics workflow

## Business Value
This analysis identifies operational risk areas and supports proactive monitoring and maintenance decisions.

## Author
Luke Papaevangeliou <br />
Project Type: Operational Data Analysis <br />
Dataset: Real-world infrastructure monitoring data (anonymized)
