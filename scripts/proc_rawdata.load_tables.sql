CREATE OR ALTER PROCEDURE targetdata.load_tables
AS
BEGIN

    SET DATEFORMAT dmy;

    PRINT '>> Truncating targetdata.customers';
    TRUNCATE TABLE targetdata.customers;

    PRINT '>> Loading targetdata.customers';
    BULK INSERT targetdata.customers
    FROM 'C:\Users\arjun\Downloads\Target_SQL_Project\customers.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        TABLOCK,
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );

    PRINT '>> Truncating targetdata.sellers';
    TRUNCATE TABLE targetdata.sellers;

    PRINT '>> Loading targetdata.sellers';
    BULK INSERT targetdata.sellers
    FROM 'C:\Users\arjun\Downloads\Target_SQL_Project\sellers.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        TABLOCK,
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );

    PRINT '>> Truncating targetdata.products';
    TRUNCATE TABLE targetdata.products;

    PRINT '>> Loading targetdata.products';
    BULK INSERT targetdata.products
    FROM 'C:\Users\arjun\Downloads\Target_SQL_Project\products.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        TABLOCK,
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );

    PRINT '>> Truncating targetdata.payments';
    TRUNCATE TABLE targetdata.payments;

    PRINT '>> Loading targetdata.payments';
    BULK INSERT targetdata.payments
    FROM 'C:\Users\arjun\Downloads\Target_SQL_Project\payments.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        TABLOCK,
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );

    PRINT '>> Truncating targetdata.order_reviews';
    TRUNCATE TABLE targetdata.order_reviews;

    PRINT '>> Loading targetdata.order_reviews';
    BULK INSERT targetdata.order_reviews
    FROM 'C:\Users\arjun\Downloads\Target_SQL_Project\order_reviews.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        TABLOCK,
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );

    PRINT '>> Truncating targetdata.orders';
    TRUNCATE TABLE targetdata.orders;

    PRINT '>> Loading targetdata.orders';
    BULK INSERT targetdata.orders
    FROM 'C:\Users\arjun\Downloads\Target_SQL_Project\orders.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        TABLOCK,
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );

    PRINT '>> Truncating targetdata.geolocation';
    TRUNCATE TABLE targetdata.geolocation;

    PRINT '>> Loading targetdata.geolocation';
    BULK INSERT targetdata.geolocation
    FROM 'C:\Users\arjun\Downloads\Target_SQL_Project\geolocation.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        TABLOCK,
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );

    PRINT '>> Truncating targetdata.order_items';
    TRUNCATE TABLE targetdata.order_items;

    PRINT '>> Loading targetdata.order_items';
    BULK INSERT targetdata.order_items
    FROM 'C:\Users\arjun\Downloads\Target_SQL_Project\order_items.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        TABLOCK,
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );
END;
GO
EXEC targetdata.load_tables