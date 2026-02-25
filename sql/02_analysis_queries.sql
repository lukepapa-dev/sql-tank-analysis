-- A) Basic profiling
SELECT
  COUNT(*) AS rows,
  COUNT(DISTINCT parameter) AS parameters,
  COUNT(DISTINCT locality) AS localities,
  COUNT(DISTINCT sample_point) AS sample_points,
  COUNT(DISTINCT uom) AS uoms,
  SUM(limit_breached) AS limit_breaches
FROM v_results_clean;

-- B) Top parameters by volume
SELECT parameter, COUNT(*) AS n
FROM v_results_clean
GROUP BY parameter
ORDER BY n DESC
LIMIT 20;

-- C) Limit breaches by parameter (what’s failing?)
SELECT
  parameter,
  SUM(limit_breached) AS breaches,
  COUNT(*) AS total,
  ROUND(100.0 * SUM(limit_breached) / COUNT(*), 2) AS breach_rate_pct
FROM v_results_clean
GROUP BY parameter
HAVING total >= 20
ORDER BY breaches DESC, breach_rate_pct DESC;

-- D) Limit breaches by locality (where is it happening?)
SELECT
  locality,
  SUM(limit_breached) AS breaches,
  COUNT(*) AS total,
  ROUND(100.0 * SUM(limit_breached) / COUNT(*), 2) AS breach_rate_pct
FROM v_results_clean
GROUP BY locality
HAVING total >= 20
ORDER BY breaches DESC, breach_rate_pct DESC;

-- E) Latest reading per (locality, sample_point, parameter)
WITH ranked AS (
  SELECT
    locality, sample_point, parameter, uom,
    result_value, data_qualifier,
    result_datetime,
    ROW_NUMBER() OVER (
      PARTITION BY locality, sample_point, parameter
      ORDER BY result_datetime DESC
    ) AS rn
  FROM v_results_clean
  WHERE result_datetime IS NOT NULL
)
SELECT *
FROM ranked
WHERE rn = 1
ORDER BY locality, sample_point, parameter;

-- F) Trend: monthly count + breaches
SELECT
  substr(result_datetime, 1, 7) AS month,
  COUNT(*) AS samples,
  SUM(limit_breached) AS breaches
FROM v_results_clean
WHERE result_datetime IS NOT NULL
GROUP BY month
ORDER BY month;

-- G) User activity (process insight)
SELECT
  user_id,
  COUNT(*) AS n,
  SUM(limit_breached) AS breaches
FROM v_results_clean
GROUP BY user_id
ORDER BY n DESC;