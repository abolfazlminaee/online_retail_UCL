WITH Last12Months AS (
    SELECT 
        o.*, 
        DATE_FORMAT(o.creat_at, '%Y-%m') AS `year_month`
    FROM 
        orders o
    WHERE
        o.creat_at >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 12 MONTH), '%Y-%m-01')
        AND o.creat_at < DATE_FORMAT(CURDATE(), '%Y-%m-01')
),
OrderDetailsData AS (
    SELECT
        l.*,
        od.price,
        od.discount,
        p.category_id,
        p.vendor_id AS p_vendor_id -- alias to avoid duplication
    FROM
        Last12Months l
    JOIN
        orderdetails od ON l.id = od.order_id
    JOIN
        products p ON od.product_id = p.id
),
CategoryLevels AS (
    SELECT
        cd.*,
        c1.title AS category_level_1,
        c2.title AS category_level_2,
        cd.p_vendor_id AS final_vendor_id -- تغییر نام ستون برای جلوگیری از تکرار
    FROM
        OrderDetailsData cd
    LEFT JOIN categories c2 ON cd.category_id = c2.id
    LEFT JOIN categories c1 ON c2.root_id = c1.id
)
SELECT
    `year_month`,
    category_level_1,
    category_level_2,
    final_vendor_id AS vendor_id, -- استفاده از نام جدید در خروجی
    COUNT(DISTINCT CategoryLevels.id) AS orders_count, -- اصلاح این خط
    SUM(price) AS sales_value,
    SUM(discount) AS discount_value,
    SUM(IFNULL(voucher.amount, 0)) AS voucher_value
FROM
    CategoryLevels
LEFT JOIN
    vouchers voucher ON voucher.order_id = CategoryLevels.id
GROUP BY
    `year_month`, category_level_1, category_level_2, final_vendor_id
ORDER BY
    `year_month`, final_vendor_id;