SELECT
#DATE_FORMAT(o.creat_at, '%Y-%m') AS `year month`,
    COUNT(DISTINCT o.id) AS `orders_count`,
    SUM(od.price) AS `sales_value`,
    SUM(od.discount) AS `discount_value`,
    SUM(voucher.amount) AS `voucher_value`,
    c1.title AS `category_level_1`,
    c2.title AS `category_level_2`,
    o.vendor_id
FROM
    orders o
JOIN
    orderdetails od ON o.id = od.order_id
JOIN
    products p ON od.product_id = p.id
JOIN
    categories c2 ON p.category_id = c2.id
JOIN
    categories c1 ON c2.root_id = c1.id
LEFT JOIN
    vouchers voucher ON o.id = voucher.order_id
WHERE
    o.creat_at >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 12 MONTH), '%Y-%m-01')
    AND o.creat_at < DATE_FORMAT(CURDATE(), '%Y-%m-01')
GROUP BY
    DATE_FORMAT(o.creat_at, '%Y-%m'), c1.title, c2.title, o.vendor_id
#ORDER BY
   # year_month, o.vendor_id;