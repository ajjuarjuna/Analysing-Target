USE master;
GO

IF DB_ID('target_sql') IS NOT NULL
BEGIN
    ALTER DATABASE target_sql SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE target_sql;
END;
GO

CREATE DATABASE target_sql;
GO

USE target_sql;
GO

CREATE SCHEMA targetdata;
GO

DROP TABLE IF EXISTS targetdata.sellers;
DROP TABLE IF EXISTS targetdata.products;
DROP TABLE IF EXISTS targetdata.customers;
DROP TABLE IF EXISTS targetdata.payments;
DROP TABLE IF EXISTS targetdata.order_reviews;
DROP TABLE IF EXISTS targetdata.orders;
DROP TABLE IF EXISTS targetdata.order_items;
DROP TABLE IF EXISTS targetdata.geolocation;
GO

CREATE TABLE targetdata.sellers (
    [seller_id] NVARCHAR(50),
    [seller_zip_code_prefix] VARCHAR(10),
    [seller_city] NVARCHAR(100),
    [seller_state] NVARCHAR(10)
);

CREATE TABLE targetdata.products (
    [product_id] NVARCHAR(50),
    [product_category] NVARCHAR(100),
    [product_name_length] INT,
    [product_description_length] INT,
    [product_photos_qty] INT,
    [product_weight_g] INT,
    [product_length_cm] INT,
    [product_height_cm] INT,
    [product_width_cm] INT
);

CREATE TABLE targetdata.customers (
    [customer_id] NVARCHAR(50),
    [customer_unique_id] NVARCHAR(50),
    [customer_zip_code_prefix] VARCHAR(10),
    [customer_city] NVARCHAR(100),
    [customer_state] NVARCHAR(10)
);

CREATE TABLE targetdata.payments (
    [order_id] NVARCHAR(50),
    [payment_sequential] INT,
    [payment_type] NVARCHAR(50),
    [payment_installments] INT,
    [payment_value] DECIMAL(10,2)
);

CREATE TABLE targetdata.order_reviews (
    [review_id] NVARCHAR(50),
    [order_id] NVARCHAR(50),
    [review_score] INT,
    [review_comment_title] NVARCHAR(MAX),
    [review_creation_date] DATETIME2,
    [review_answer_timestamp] DATETIME2
);

CREATE TABLE targetdata.orders (
    [order_id] NVARCHAR(50),
    [customer_id] NVARCHAR(50),
    [order_status] NVARCHAR(50),
    [order_purchase_timestamp] DATETIME2,
    [order_approved_at] DATETIME2,
    [order_delivered_carrier_date] DATETIME2,
    [order_delivered_customer_date] DATETIME2,
    [order_estimated_delivery_date] DATETIME2
);

CREATE TABLE targetdata.order_items (
    [order_id] NVARCHAR(50),
    [order_item_id] INT,
    [product_id] NVARCHAR(50),
    [seller_id] NVARCHAR(50),
    [shipping_limit_date] DATETIME2,
    [price] DECIMAL(10,2),
    [freight_value] DECIMAL(10,2)
);

CREATE TABLE targetdata.geolocation (
    [geolocation_zip_code_prefix] VARCHAR(10),
    [geolocation_lat] FLOAT ,
    [geolocation_lng] FLOAT,
    [geolocation_city] NVARCHAR(100),
    [geolocation_state] NVARCHAR(10)
);
GO