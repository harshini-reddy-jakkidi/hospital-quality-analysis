-- Hospital Quality Analysis
-- Author: Harshini Reddy Jakkidi

USE hospital_quality_db;

-- 1. Count all hospital records.
SELECT COUNT(*) AS total_hospitals
FROM hospitals_complete;

-- 2. Preview five hospital records.
SELECT *
FROM hospitals_complete
LIMIT 5;

-- 3. Count hospitals by state.
SELECT State, COUNT(*) AS total_hospitals
FROM hospitals_complete
GROUP BY State
ORDER BY total_hospitals DESC;

-- 4. Count hospitals by type.
SELECT `Hospital Type`, COUNT(*) AS total_hospitals
FROM hospitals_complete
GROUP BY `Hospital Type`
ORDER BY total_hospitals DESC;

-- 5. Count hospitals by rating, labeling missing ratings.
SELECT
    CASE
        WHEN `Hospital overall rating` IS NULL
          OR TRIM(`Hospital overall rating`) = ''
        THEN 'Missing'
        ELSE TRIM(`Hospital overall rating`)
    END AS hospital_rating,
    COUNT(*) AS total_hospitals
FROM hospitals_complete
GROUP BY hospital_rating
ORDER BY hospital_rating;

-- 6. Calculate the average among rated hospitals.
SELECT ROUND(AVG(
    CASE
        WHEN TRIM(`Hospital overall rating`)
             IN ('1.0','2.0','3.0','4.0','5.0')
        THEN CAST(`Hospital overall rating` AS DECIMAL(3,1))
    END
), 2) AS average_rating
FROM hospitals_complete;

-- 7. Summarize Texas hospitals.
SELECT
    COUNT(*) AS total_texas_hospitals,
    COUNT(CASE
        WHEN TRIM(`Hospital overall rating`)
             IN ('1.0','2.0','3.0','4.0','5.0')
        THEN 1
    END) AS rated_hospitals,
    ROUND(AVG(CASE
        WHEN TRIM(`Hospital overall rating`)
             IN ('1.0','2.0','3.0','4.0','5.0')
        THEN CAST(`Hospital overall rating` AS DECIMAL(3,1))
    END), 2) AS average_rating
FROM hospitals_complete
WHERE State = 'TX';

-- 8. List five-star hospitals in Texas.
SELECT `Facility Name`, `City/Town`, `Hospital overall rating`
FROM hospitals_complete
WHERE State = 'TX'
  AND TRIM(`Hospital overall rating`) = '5.0'
ORDER BY `Facility Name`;