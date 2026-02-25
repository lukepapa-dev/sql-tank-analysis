DROP VIEW IF EXISTS v_results_clean;

CREATE VIEW v_results_clean AS
SELECT
  -- Boolean-ish fields
  CASE WHEN "Limit Breached" IN ('True','TRUE',1,'1') THEN 1 ELSE 0 END AS limit_breached,
  CASE WHEN "Ext." IN ('True','TRUE',1,'1') THEN 1 ELSE 0 END AS ext_flag,
  CASE WHEN "HasAttachments" IN ('True','TRUE',1,'1') THEN 1 ELSE 0 END AS has_attachments,

  -- Dimensions
  TRIM("Parameter")      AS parameter,
  TRIM("Locality")       AS locality,
  TRIM("Sample Point")   AS sample_point,
  TRIM("Site Code")      AS site_code,
  TRIM("Data Qualifier") AS data_qualifier,
  TRIM("UOM")            AS uom,
  TRIM("User")           AS user_id,

  -- Free text
  "Comment" AS comment,

  -- Result (numeric when possible)
  CAST("Result" AS REAL) AS result_value,

  -- Dates: convert "M/D/YYYY HH:MM" -> "YYYY-MM-DD HH:MM:SS" where possible
  CASE
    WHEN "Result Date" IS NULL THEN NULL
    ELSE
      printf(
        '%04d-%02d-%02d %02d:%02d:00',
        CAST(substr("Result Date", instr("Result Date", '/') + instr(substr("Result Date", instr("Result Date", '/')+1), '/') + 1, 4) AS INT),
        CAST(substr("Result Date", 1, instr("Result Date", '/') - 1) AS INT),
        CAST(substr(
          substr("Result Date", instr("Result Date", '/') + 1),
          1,
          instr(substr("Result Date", instr("Result Date", '/') + 1), '/') - 1
        ) AS INT),
        CAST(substr("Result Date", instr("Result Date", ' ') + 1, 2) AS INT),
        CAST(substr("Result Date", instr("Result Date", ':') - 2, 2) AS INT)
      )
  END AS result_datetime,

  -- Keep the raw strings too (good practice)
  "Result Date" AS result_date_raw,
  "Date Sent"   AS date_sent_raw,

  -- Import metadata
  "Import Reference"   AS import_reference,
  "Import Batch No"    AS import_batch_no,
  "Import Sample Type" AS import_sample_type

FROM tank_data;