-- ============================================================
-- PROJECT: CRM Data Quality Audit
-- AUTHOR:  Sastivel Preetham
-- CONTEXT: Simulates a data quality audit for a homeless support
--          charity CRM system (similar to The Wallich's In-Form)
-- TOOL:    SQLite
-- ============================================================


-- ============================================================
-- SECTION 1: CREATE TABLES
-- ============================================================

DROP TABLE IF EXISTS referrals;
DROP TABLE IF EXISTS service_users;
DROP TABLE IF EXISTS support_workers;

CREATE TABLE support_workers (
    worker_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    worker_name TEXT,
    region      TEXT
);

CREATE TABLE service_users (
    user_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name          TEXT,
    last_name           TEXT,
    dob                 TEXT,
    gender              TEXT,
    referral_source     TEXT,
    registration_date   TEXT,
    support_worker_id   INTEGER,
    status              TEXT
);

CREATE TABLE referrals (
    referral_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id          INTEGER,
    referral_date    TEXT,
    referring_agency TEXT,
    outcome          TEXT
);


-- ============================================================
-- SECTION 2: INSERT DATA
-- Includes intentional duplicates and NULL values
-- to simulate real CRM data quality issues
-- ============================================================

INSERT INTO support_workers (worker_name, region) VALUES
('Sarah Jones', 'Cardiff'),
('Mark Evans',  'Swansea'),
('Priya Patel', 'Newport'),
('Sarah Jones', 'Cardiff');  -- intentional duplicate

INSERT INTO service_users
(first_name, last_name, dob, gender, referral_source, registration_date, support_worker_id, status)
VALUES
('James', 'Williams', '1990-05-12', 'Male',   'GP',      '2024-01-10', 1, 'Active'),
('Maria', 'Davies',   '1985-03-22', 'Female', 'Self',    '2024-01-15', 2, 'Active'),
('James', 'Williams', '1990-05-12', 'Male',   'GP',      '2024-01-10', 1, 'Active'),   -- duplicate
('Kevin', 'Thomas',   NULL,         'Male',   'Council', '2024-02-01', 3, 'Pending'),  -- missing dob
('Lisa',  NULL,       '1995-07-30', 'Female', 'GP',      '2024-02-14', 1, 'Active'),   -- missing last_name
('Paul',  'Harris',   '1978-11-05', 'Male',   NULL,      '2024-03-01', 2, 'Closed'),   -- missing referral_source
('Anna',  'Brown',    '2001-09-18', 'Female', 'Self',    NULL,         4, 'Active'),   -- missing registration_date
('Kevin', 'Thomas',   NULL,         'Male',   'Council', '2024-02-01', 3, 'Pending');  -- duplicate


-- ============================================================
-- QUERY 1: Find duplicate support workers
-- Detects workers entered more than once in the system
-- ============================================================

SELECT worker_name, region, COUNT(*) AS total
FROM support_workers
GROUP BY worker_name, region
HAVING COUNT(*) > 1;


-- ============================================================
-- QUERY 2: Find duplicate service users
-- Flags users with identical name and date of birth
-- ============================================================

SELECT first_name, last_name, dob, COUNT(*) AS total
FROM service_users
GROUP BY first_name, last_name, dob
HAVING COUNT(*) > 1;


-- ============================================================
-- QUERY 3: Find incomplete records
-- Returns any service user missing key fields
-- ============================================================

SELECT * FROM service_users
WHERE last_name        IS NULL
   OR dob              IS NULL
   OR referral_source  IS NULL;


-- ============================================================
-- QUERY 4: Join service users with their support workers
-- Combines two tables using the linking column support_worker_id
-- ============================================================

SELECT service_users.first_name,
       service_users.last_name,
       support_workers.worker_name,
       support_workers.region
FROM service_users
JOIN support_workers
  ON service_users.support_worker_id = support_workers.worker_id;


-- ============================================================
-- QUERY 5: Count caseload per support worker
-- Shows how many service users each worker is handling
-- ============================================================

SELECT support_workers.worker_name,
       COUNT(*) AS total_users
FROM service_users
JOIN support_workers
  ON service_users.support_worker_id = support_workers.worker_id
GROUP BY support_workers.worker_name;


-- ============================================================
-- QUERY 6: Data quality flag using CASE statement
-- Labels each record as Good, Needs Review, or Incomplete
-- based on how many key fields are missing
-- ============================================================

SELECT first_name,
       last_name,
       CASE
           WHEN (last_name IS NULL) + (dob IS NULL) + (referral_source IS NULL) > 1
               THEN 'Incomplete'
           WHEN (last_name IS NULL) + (dob IS NULL) + (referral_source IS NULL) = 1
               THEN 'Needs Review'
           ELSE 'Good'
       END AS data_quality_flag
FROM service_users;
