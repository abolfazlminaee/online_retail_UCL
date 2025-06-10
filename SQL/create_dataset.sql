CREATE DATABASE IF NOT EXISTS snappmarket;
USE snappmarket;
DROP TABLE IF EXISTS vouchers;
DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    creat_at DATETIME,
    status_id INT,
    source VARCHAR(255),
    vendor_id INT,
    payment_status VARCHAR(50)
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    vendor_id INT,
    position INT,
    active BOOLEAN,
    root_id INT,
    parent_id INT,
    lft INT,
    rgt INT,
    level INT
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT,
    title VARCHAR(255),
    category_id INT,
    create_at DATETIME,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE vouchers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(10,2),
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE orderdetails (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    price DECIMAL(10,2),
    discount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);