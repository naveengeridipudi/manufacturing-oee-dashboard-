-- Manufacturing OEE Dashboard - SQL Analysis
-- Author: Naveen | Data Analyst Project

-- 1. OEE Calculation by Machine
SELECT 
    machine_id,
    ROUND(AVG(operating_time * 1.0 / planned_production_time)*100, 2) AS Availability,
    ROUND(AVG(actual_output * 1.0 / ideal_output)*100, 2) AS Performance,
    ROUND(AVG(good_pieces * 1.0 / total_pieces)*100, 2) AS Quality,
    ROUND(AVG((operating_time/planned_production_time) * (actual_output/ideal_output) * (good_pieces/total_pieces))*100, 2) AS OEE
FROM oee_data
GROUP BY machine_id
ORDER BY OEE DESC;

-- 2. Top Downtime Reasons
SELECT 
    downtime_reason,
    SUM(downtime_minutes) AS total_downtime_minutes,
    ROUND(SUM(downtime_minutes)*100.0 / (SELECT SUM(downtime_minutes) FROM oee_data), 2) AS percentage
FROM oee_data
WHERE downtime_reason IS NOT NULL
GROUP BY downtime_reason
ORDER BY total_downtime_minutes DESC;

-- 3. Shift-wise OEE Analysis
SELECT 
    shift,
    ROUND(AVG((operating_time*1.0/planned_production_time))*100,2) AS Avg_Availability,
    ROUND(AVG((good_pieces*1.0/total_pieces))*100,2) AS Avg_Quality,
    COUNT(*) AS total_records
FROM oee_data
GROUP BY shift
ORDER BY shift;

-- 4. Machine with Highest Breakdowns
SELECT machine_id, COUNT(*) AS breakdown_count
FROM oee_data
WHERE downtime_reason = 'Breakdown'
GROUP BY machine_id
ORDER BY breakdown_count DESC;

-- 5. Daily Production Trend
SELECT 
    production_date,
    SUM(actual_output) AS daily_output,
    SUM(good_pieces) AS good_pieces,
    SUM(total_pieces - good_pieces) AS rejected
FROM oee_data
GROUP BY production_date
ORDER BY production_date;
