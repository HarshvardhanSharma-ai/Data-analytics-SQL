
-- 1. CREATE TABLE (if not already created)
CREATE TABLE appointments (
    PatientId BIGINT,
    AppointmentID BIGINT,
    Gender VARCHAR(10),
    ScheduledDay TEXT,  -- Use TEXT for SQLite, TIMESTAMP for MySQL/Postgres
    AppointmentDay TEXT,
    Age INT,
    Neighbourhood VARCHAR(100),
    Scholarship BOOLEAN,
    Hypertension BOOLEAN,
    Diabetes BOOLEAN,
    Alcoholism BOOLEAN,
    Handcap INT,
    SMS_received BOOLEAN,
    "No-show" VARCHAR(5)
);

-- 2. TOTAL APPOINTMENTS & NO-SHOWS
SELECT 
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS total_no_shows
FROM appointments;

-- 3. NO-SHOW RATE BY GENDER
SELECT 
    Gender,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS no_show_rate_percent
FROM appointments
GROUP BY Gender;

-- 4. TOP 5 NEIGHBOURHOURHOODS WITH MOST NO-SHOWS
SELECT 
    Neighbourhood,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows
FROM appointments
GROUP BY Neighbourhood
ORDER BY no_shows DESC
LIMIT 5;

-- 5. IMPACT OF SMS ON NO-SHOWS
SELECT 
    SMS_received,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS no_show_rate_percent
FROM appointments
GROUP BY SMS_received;

-- 6. AVERAGE AGE: SHOW VS NO-SHOW
SELECT 
    "No-show" AS show_status,
    ROUND(AVG(Age), 2) AS avg_age
FROM appointments
GROUP BY "No-show";

-- 7. PATIENTS WITH MOST NO-SHOWS
SELECT 
    PatientId,
    COUNT(*) AS total_no_shows
FROM appointments
WHERE "No-show" = 'Yes'
GROUP BY PatientId
ORDER BY total_no_shows DESC
LIMIT 5;

-- 8. CREATE A VIEW FOR REUSABLE ANALYSIS
CREATE VIEW show_summary AS
SELECT 
    Gender,
    Age,
    Neighbourhood,
    "No-show" AS no_show_status
FROM appointments;

-- 9. CREATE INDEX FOR OPTIMIZATION
CREATE INDEX idx_no_show ON appointments("No-show");
