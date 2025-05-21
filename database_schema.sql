-- BookMart E-commerce Database Schema
-- Created: May 21, 2025

-- Users and Authentication
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone VARCHAR(15),
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsAdmin BIT DEFAULT 0
);

CREATE TABLE UserAddresses (
    AddressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    AddressType VARCHAR(20), -- 'Billing' or 'Shipping'
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    PostalCode VARCHAR(10),
    Country VARCHAR(50),
    IsDefault BIT DEFAULT 0
);

-- Books and Categories
CREATE TABLE Genres (
    GenreID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Description TEXT,
    IconClass VARCHAR(50), -- For FontAwesome icons
    ColorTheme VARCHAR(20), -- For UI styling
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(13) UNIQUE,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    GenreID INT FOREIGN KEY REFERENCES Genres(GenreID),
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    DiscountedPrice DECIMAL(10,2),
    StockQuantity INT DEFAULT 0,
    MinStockLevel INT DEFAULT 20,
    PageCount INT,
    Language VARCHAR(50),
    PublishedDate DATE,
    Publisher VARCHAR(100),
    CoverImageURL VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    IsActive BIT DEFAULT 1
);

-- Reviews and Ratings
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Rating DECIMAL(2,1) CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    IsVerifiedPurchase BIT DEFAULT 0
);

-- Shopping Cart
CREATE TABLE Carts (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME
);

CREATE TABLE CartItems (
    CartItemID INT IDENTITY(1,1) PRIMARY KEY,
    CartID INT FOREIGN KEY REFERENCES Carts(CartID),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    Quantity INT DEFAULT 1,
    Price DECIMAL(10,2) NOT NULL -- Price at the time of adding to cart
);

-- Orders
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    OrderDate DATETIME DEFAULT GETDATE(),
    ShippingAddressID INT FOREIGN KEY REFERENCES UserAddresses(AddressID),
    BillingAddressID INT FOREIGN KEY REFERENCES UserAddresses(AddressID),
    SubTotal DECIMAL(10,2) NOT NULL,
    ShippingCost DECIMAL(10,2) DEFAULT 0,
    TaxAmount DECIMAL(10,2),
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50), -- 'Card', 'UPI', 'COD'
    PaymentStatus VARCHAR(20), -- 'Pending', 'Paid', 'Failed'
    OrderStatus VARCHAR(20) -- 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
);

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL -- Price at the time of order
);

-- Stock Management
CREATE TABLE StockTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    TransactionType VARCHAR(20), -- 'Add', 'Remove', 'Adjust'
    Quantity INT NOT NULL,
    PreviousQuantity INT NOT NULL,
    NewQuantity INT NOT NULL,
    Reason VARCHAR(50), -- 'New Stock', 'Damaged', 'Order', 'Return', 'Adjustment'
    Notes TEXT,
    TransactionDate DATETIME DEFAULT GETDATE(),
    UserID INT FOREIGN KEY REFERENCES Users(UserID) -- Admin who made the change
);

-- Indexes for Performance Optimization
CREATE INDEX IX_Books_Title ON Books(Title);
CREATE INDEX IX_Books_Author ON Books(Author);
CREATE INDEX IX_Orders_UserID_OrderDate ON Orders(UserID, OrderDate);

-- Constraints
ALTER TABLE Books ADD CONSTRAINT CHK_Books_StockQuantity 
    CHECK (StockQuantity >= 0);

ALTER TABLE CartItems ADD CONSTRAINT CHK_CartItems_Quantity 
    CHECK (Quantity > 0);

ALTER TABLE OrderItems ADD CONSTRAINT CHK_OrderItems_Quantity 
    CHECK (Quantity > 0);

ALTER TABLE Books ADD CONSTRAINT CHK_Books_Price 
    CHECK (Price >= 0);

ALTER TABLE Books ADD CONSTRAINT CHK_Books_DiscountedPrice 
    CHECK (DiscountedPrice IS NULL OR (DiscountedPrice >= 0 AND DiscountedPrice <= Price));

-- Sample Data for Testing (Optional)
-- Add INSERT statements here for initial data population