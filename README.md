# CRM Data Quality Audit — SQL Project

## Overview
This project simulates a data quality audit for a homeless support charity CRM system, based on the type of work performed by Data Technicians managing service user records.

The goal was to identify duplicate records, incomplete data entries, and produce summary reports — mirroring real data quality challenges found in systems like In-Form used by organisations such as The Wallich.

---

## Skills Demonstrated
- SQL table design and relational database structure
- Data insertion including intentional duplicates and NULL values
- Duplicate detection using `GROUP BY` and `HAVING`
- Incomplete record identification using `WHERE IS NULL`
- Multi-table querying using `JOIN`
- Aggregation and reporting using `COUNT` and `GROUP BY`
- Conditional logic using `CASE` statements
- Data quality flagging (Good / Needs Review / Incomplete)

---

## Tools Used
- SQL (SQLite)
- SQLiteOnline.com

---

## Database Structure

Three related tables were created to simulate a charity CRM:

**support_workers** — stores details of support staff
| Column | Type | Description |
|---|---|---|
| worker_id | INTEGER | Primary key, auto-generated |
| worker_name | TEXT | Full name of support worker |
| region | TEXT | Region they operate in |

**service_users** — stores details of people receiving support
| Column | Type | Description |
|---|---|---|
| user_id | INTEGER | Primary key, auto-generated |
| first_name | TEXT | First name |
| last_name | TEXT | Last name |
| dob | TEXT | Date of birth |
| gender | TEXT | Gender |
| referral_source | TEXT | How they were referred (GP, Council, Self) |
| registration_date | TEXT | Date added to the system |
| support_worker_id | INTEGER | Links to support_workers table |
| status | TEXT | Active, Pending, or Closed |

**referrals** — stores referral events linked to service users
| Column | Type | Description |
|---|---|---|
| referral_id | INTEGER | Primary key, auto-generated |
| user_id | INTEGER | Links to service_users table |
| referral_date | TEXT | Date of referral |
| referring_agency | TEXT | Agency that made the referral |
| outcome | TEXT | Result of the referral |

---

## Queries

### Query 1 — Find Duplicate Support Workers
Detects workers who have been entered into the system more than once using `GROUP BY` and `HAVING COUNT(*) > 1`.

### Query 2 — Find Duplicate Service Users
Identifies service users with identical first name, last name, and date of birth — a common data entry error in CRM systems.

### Query 3 — Find Incomplete Records
Returns all service users where one or more key fields (`last_name`, `dob`, `referral_source`) are missing using `IS NULL`.

### Query 4 — Join Service Users with Support Workers
Combines the `service_users` and `support_workers` tables using an `INNER JOIN` to display each service user alongside their assigned worker's name and region.

### Query 5 — Caseload Report per Support Worker
Produces a summary report showing how many service users each support worker is currently handling using `JOIN`, `GROUP BY`, and `COUNT`.

### Query 6 — Data Quality Flag
Labels every service user record as `Good`, `Needs Review`, or `Incomplete` based on how many key fields are missing, using a `CASE` statement. This produces a data quality dashboard that can be used to prioritise data cleaning efforts.

---

## Key Findings from the Audit
- 1 duplicate support worker identified (Sarah Jones, Cardiff)
- 2 duplicate service user records identified (James Williams, Kevin Thomas)
- 4 records with missing key fields detected
- Sarah Jones carries the highest caseload (4 assigned users including duplicates)
- No records were fully `Incomplete` — most issues were single missing fields flagged as `Needs Review`

---

## Author
**Sastivel Preetham**  
MSc Data Science and Analytics — Cardiff University  
[LinkedIn](https://www.linkedin.com/in/sastivel-preetham)
