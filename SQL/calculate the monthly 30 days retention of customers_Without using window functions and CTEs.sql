SELECT
    DATE_FORMAT(o1.creat_at, '%Y') AS Year,
    DATE_FORMAT(o1.creat_at, '%M') AS Month,
    COUNT(DISTINCT o1.customer_id) AS `Count of Users`,
    COUNT(DISTINCT o2.customer_id) AS `Count of Returned Users`,
    (COUNT(DISTINCT o2.customer_id) * 100.0 / COUNT(DISTINCT o1.customer_id)) AS `Retention (%)`
FROM
    orders o1
LEFT JOIN
    orders o2 ON o1.customer_id = o2.customer_id
        AND o2.creat_at > o1.creat_at
        AND o2.creat_at <= DATE_ADD(o1.creat_at, INTERVAL 30 DAY)
WHERE
    o1.creat_at >= '2025-01-01' AND o1.creat_at < '2025-12-01'
GROUP BY
    Year, Month
ORDER BY
    Year, Month;