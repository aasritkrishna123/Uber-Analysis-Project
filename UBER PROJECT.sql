create database uber;

use uber;

SELECT * FROM uber.`uber request data`;

SELECT count(*) FROM uber.`uber request data`;

--- Questions 

--- Basic Questions 

--- 1. How many total requests were made?
select count(Request_id) as ride_requests from uber.`uber request data`;

--- 2. How many requests were completed, cancelled, and marked as "No Cars Available"?
select Status, count(status) from uber.`uber request data`
group by Status;

--- 3. What is the percentage of each request status overall?
SELECT Status, COUNT(*) AS status_count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uber.`uber request data` ), 2) AS percentage
FROM uber.`uber request data`
GROUP BY Status;

--- Time-Based Analysis

--- 4. What are the total requests by each hour of the day?
SELECT Request_Hour, COUNT(*) AS total_requests
FROM uber.`uber request data`
GROUP BY Request_Hour
ORDER BY Request_Hour;

--- 5. Which hour of the day has the highest number of ride requests?
SELECT Request_Hour, COUNT(*) AS total_requests FROM uber.`uber request data`
GROUP BY Request_Hour
ORDER BY total_requests DESC
LIMIT 1;

--- 6. What is the distribution of request status by hour (Completed, Cancelled, No Cars)?
SELECT Request_Hour, Status, COUNT(*) AS status_count FROM uber.`uber request data`
GROUP BY Request_Hour, Status
ORDER BY Request_Hour, Status;

--- 7. What is the average number of requests per hour across all days?
SELECT Request_Hour, ROUND(AVG(hourly_requests), 2) AS average_requests
FROM (
    SELECT Request_Date, Request_Hour, COUNT(*) AS hourly_requests
    FROM uber.`uber request data`
    GROUP BY Request_Date, Request_Hour) AS hourly_data
GROUP BY Request_Hour
ORDER BY Request_Hour;

--- 8. During which time slots (Morning, Daytime, Evening, Night) does the demand gap occur most?
SELECT Time_Slot, COUNT(*) AS gap_count
FROM uber.`uber request data`
WHERE Gap_Status = 'Yes'
GROUP BY Time_Slot
ORDER BY gap_count DESC;

--- Location-Based Insights
--- 9. What is the total number of requests from the City and from the Airport?
select Pickup_point, count(*) as total_Requests from uber.`uber request data`
Group by Pickup_point;

--- 10. Which pickup point has the highest number of failed rides (Cancelled or No Cars Available)?
SELECT Pickup_point, COUNT(*) AS failed_rides FROM uber.`uber request data`
WHERE Status IN ('Cancelled', 'No Cars Available')
GROUP BY Pickup_point
ORDER BY failed_rides DESC;

--- 11. What percentage of requests from each pickup point get completed?
SELECT Pickup_point,
ROUND(COUNT(CASE WHEN Status = 'Trip Completed' THEN 1 END) * 100.0 / COUNT(*), 2) AS completion_percentage
FROM uber.`uber request data`
GROUP BY Pickup_point;

--- Driver Behavior
--- 12. Which hours had most requests with no driver assigned (leading to "No Cars Available")?
SELECT Request_Hour, COUNT(*) AS no_driver_requests FROM uber.`uber request data`
WHERE Status = 'No Cars Available'
GROUP BY Request_Hour
ORDER BY no_driver_requests DESC;

--- 13. How many requests had drivers assigned vs. not assigned?
SELECT 
  CASE WHEN Driver_id IS NULL THEN 'No' 
  ELSE 'Yes'END AS Driver_Assignment, COUNT(*) AS request_count
FROM uber.`uber request data`
GROUP BY Driver_Assignment;

--- Gap Analysis
--- 14. What percentage of total requests fall into the demand-supply gap?
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uber.`uber request data`) AS gap_percentage 
FROM uber.`uber request data`
WHERE Gap_Status = 'Yes';

--- 15. What time slots experience the most gaps?
SELECT Time_Slot, COUNT(*) AS gap_count FROM  uber.`uber request data`
WHERE Gap_Status = 'Yes'
GROUP BY Time_Slot
ORDER BY gap_count DESC;

--- 16. Which hour of the day has the most failed rides (gap)?
SELECT Request_Hour, COUNT(*) AS failed_requests FROM uber.`uber request data`
WHERE Gap_Status = 'Yes'
GROUP BY Request_Hour
ORDER BY failed_requests DESC;

--- 17. What is the gap rate by pickup point?
SELECT Pickup_point,
COUNT(*) AS total_requests,
COUNT(CASE WHEN Status IN ('Cancelled', 'No Cars Available') THEN 1 END) AS gap_requests,
ROUND(COUNT(CASE WHEN Status IN ('Cancelled', 'No Cars Available') THEN 1 END) * 100.0 / COUNT(*), 2) 
AS gap_rate_percentage
FROM uber.`uber request data`
GROUP BY Pickup_point;

--- 18. What are the top 3 time slots with the highest demand-supply gap?
SELECT Time_Slot, COUNT(*) AS gap_count FROM uber.`uber request data`
WHERE Status IN ('Cancelled', 'No Cars Available')
GROUP BY Time_Slot
ORDER BY gap_count DESC
LIMIT 3;

--- 19. What’s the completion rate for each time slot?
SELECT Time_Slot, COUNT(*) AS total_requests,
COUNT(CASE WHEN Status = 'Trip Completed' THEN 1 END) AS completed_requests,
ROUND(COUNT(CASE WHEN Status = 'Trip Completed' THEN 1 END) * 100.0 / COUNT(*), 2) AS completion_rate_percentage
FROM uber.`uber request data`
GROUP BY Time_Slot
ORDER BY completion_rate_percentage DESC;

--- Daily Trends 
--- 20. How many requests are made per day?
SELECT Request_Date, COUNT(*) AS total_requests
FROM uber.`uber request data`
GROUP BY Request_Date
ORDER BY Request_Date;

--- 21. How do completed vs. failed requests trend over different days (if date range is long)?
SELECT Request_Date, Status, COUNT(*) AS request_count FROM uber.`uber request data`
GROUP BY Request_Date, Status
ORDER BY Request_Date, Status;





