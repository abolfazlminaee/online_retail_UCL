WITH FirstOrder AS (
    SELECT 
        customer_id,
        MIN(creat_at) AS first_order_date
    FROM 
        orders
    GROUP BY 
        customer_id
),
CustomerOrders AS (
    SELECT
        o.*,
        fo.first_order_date
    FROM 
        orders o
    JOIN 
        FirstOrder fo ON o.customer_id = fo.customer_id
),
ReturnsWithin30Days AS (
    SELECT
        customer_id,
        DATE_FORMAT(first_order_date, '%Y') AS Year,
        DATE_FORMAT(first_order_date, '%m') AS Month,
        MIN(creat_at) AS second_order_date
    FROM 
        CustomerOrders
    WHERE
        creat_at > first_order_date AND creat_at <= DATE_ADD(first_order_date, INTERVAL 30 DAY)
    GROUP BY
        customer_id, Year, Month
)

SELECT
    Year,
    CASE 
        WHEN Month = '01' THEN 'January'
        WHEN Month = '02' THEN 'February'
        WHEN Month = '03' THEN 'March'
        WHEN Month = '04' THEN 'April'
        WHEN Month = '05' THEN 'May'
        WHEN Month = '06' THEN 'June'
        WHEN Month = '07' THEN 'July'
        WHEN Month = '08' THEN 'August'
        WHEN Month = '09' THEN 'September'
        WHEN Month = '10' THEN 'October'
        WHEN Month = '11' THEN 'November'
        WHEN Month = '12' THEN 'December'
    END AS Month,
    COUNT(DISTINCT fo.customer_id) AS `Count of Users`,
    COUNT(DISTINCT r.customer_id) AS `Count of Returned Users`,
    (COUNT(DISTINCT r.customer_id) * 100.0 / COUNT(DISTINCT fo.customer_id)) AS `Retention (%)`
FROM
    FirstOrder fo
LEFT JOIN
    ReturnsWithin30Days r ON fo.customer_id = r.customer_id AND fo.first_order_date >= '2025-01-01'
GROUP BY
    Year, Month
ORDER BY
    Year, STR_TO_DATE(Month, '%M');