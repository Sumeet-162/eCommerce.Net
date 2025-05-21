# 📦 E-Commerce Platform Design Document

---

## 📝 Project Title: E-Commerce Platform

---

### 1️⃣ Overview

The **E-Commerce Platform** is a comprehensive web-based solution designed to manage online store operations efficiently. It offers:
- A seamless shopping experience for customers.
- Efficient order management for store administrators.

This platform follows the **MVC architecture**, ensuring compatibility with:
- **Java** (Spring MVC)
- **.NET** (ASP.NET Core MVC)

#### Core Modules:
1. **Product Management** – Manage product information and categorization.
2. **Shopping Cart** – Handle customer shopping carts.
3. **Order Processing** – Manage the lifecycle of orders.
4. **Payment Gateway Integration** – Facilitate payment processing.
5. **User Management** – Handle customer authentication and authorization.

---

### 2️⃣ Assumptions

1. The application will be deployed locally during development using a relational database (e.g., **MySQL** or **SQL Server**).
2. **Role-based authentication** will secure sensitive data for customers and administrators.
3. ORM frameworks will manage database interactions:
   - **Hibernate** for Java
   - **Entity Framework** for .NET
4. The application will support **cross-environment development** in both Java and .NET.
5. A **mock payment gateway** will be used for local testing.

---

### 3️⃣ Module-Level Design

#### 3.1 📦 Product Management Module
**Purpose:** Manage product listings, categories, and inventory.

- **Controller:**
  - `ProductController`
    - `addProduct(productData)`
    - `updateProduct(productId, productData)`
    - `getProductDetails(productId)`
    - `deleteProduct(productId)`
    - `getAllProducts()`
- **Service:**
  - `ProductService`
    - Handles CRUD operations for products.
- **Model:**
  - **Entity:** `Product`
    - **Attributes:**
      - `productId` (Primary Key)
      - `name` (VARCHAR)
      - `description` (TEXT)
      - `price` (DECIMAL)
      - `categoryId` (Foreign Key)
      - `stockQuantity` (INT)

---

#### 3.2 🛒 Shopping Cart Module
**Purpose:** Handle adding/removing items in the cart and display cart details.

- **Controller:**
  - `CartController`
    - `addToCart(cartData)`
    - `removeFromCart(cartId)`
    - `getCartDetails(userId)`
- **Service:**
  - `CartService`
    - Manages cart operations.
- **Model:**
  - **Entity:** `Cart`
    - **Attributes:**
      - `cartId` (Primary Key)
      - `userId` (Foreign Key)
      - `productId` (Foreign Key)
      - `quantity` (INT)

---

#### 3.3 📦 Order Processing Module
**Purpose:** Manage order creation, status updates, and delivery.

- **Controller:**
  - `OrderController`
    - `createOrder(orderData)`
    - `getOrderDetails(orderId)`
    - `updateOrderStatus(orderId, status)`
- **Service:**
  - `OrderService`
    - Handles order creation and lifecycle management.
- **Model:**
  - **Entity:** `Order`
    - **Attributes:**
      - `orderId` (Primary Key)
      - `userId` (Foreign Key)
      - `totalAmount` (DECIMAL)
      - `orderDate` (DATE)
      - `status` (ENUM: Pending, Shipped, Delivered, Cancelled)

---

#### 3.4 💳 Payment Gateway Integration Module
**Purpose:** Integrate payment gateway for transaction processing.

- **Controller:**
  - `PaymentController`
    - `processPayment(paymentData)`
    - `getPaymentStatus(paymentId)`
- **Service:**
  - `PaymentService`
    - Handles payment requests and verification.
- **Model:**
  - **Entity:** `Payment`
    - **Attributes:**
      - `paymentId` (Primary Key)
      - `orderId` (Foreign Key)
      - `amount` (DECIMAL)
      - `paymentStatus` (ENUM: Pending, Completed, Failed)
      - `paymentDate` (DATE)

---

#### 3.5 👤 User Management Module
**Purpose:** Manage user registration, login, and authentication.

- **Controller:**
  - `UserController`
    - `registerUser(userData)`
    - `loginUser(username, password)`
    - `getUserProfile(userId)`
    - `updateUserProfile(userId, userData)`
- **Service:**
  - `UserService`
    - Manages user authentication and profile details.
- **Model:**
  - **Entity:** `User`
    - **Attributes:**
      - `userId` (Primary Key)
      - `username` (VARCHAR)
      - `password` (Encrypted, VARCHAR)
      - `role` (ENUM: Customer, Admin)
      - `email` (VARCHAR)

---

### 4️⃣ Database Schema

#### 4.1 📊 Table Definitions

1. **Product Table**
```sql
CREATE TABLE Product (
  productId INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  description TEXT,
  price DECIMAL(10, 2),
  categoryId INT,
  stockQuantity INT,
  FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
);
```

2. **Category Table**
```sql
CREATE TABLE Category (
  categoryId INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100)
);
```

3. **Cart Table**
```sql
CREATE TABLE Cart (
  cartId INT PRIMARY KEY AUTO_INCREMENT,
  userId INT,
  productId INT,
  quantity INT,
  FOREIGN KEY (userId) REFERENCES User(userId),
  FOREIGN KEY (productId) REFERENCES Product(productId)
);
```

4. **Order Table**
```sql
CREATE TABLE Order (
  orderId INT PRIMARY KEY AUTO_INCREMENT,
  userId INT,
  totalAmount DECIMAL(10, 2),
  orderDate DATE,
  status ENUM('PENDING', 'SHIPPED', 'DELIVERED', 'CANCELLED'),
  FOREIGN KEY (userId) REFERENCES User(userId)
);
```

5. **Payment Table**
```sql
CREATE TABLE Payment (
  paymentId INT PRIMARY KEY AUTO_INCREMENT,
  orderId INT,
  amount DECIMAL(10, 2),
  paymentStatus ENUM('PENDING', 'COMPLETED', 'FAILED'),
  paymentDate DATE,
  FOREIGN KEY (orderId) REFERENCES Order(orderId)
);
```

6. **User Table**
```sql
CREATE TABLE User (
  userId INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE,
  password VARCHAR(255),
  role ENUM('CUSTOMER', 'ADMIN'),
  email VARCHAR(100)
);
```

---

### 5️⃣ Local Deployment Details

#### 🛠️ Environment Setup:
1. Install **JDK 17** or **.NET SDK 7.0**.
2. Install **MySQL** or **SQL Server**.
3. Use an application server:
   - **Tomcat** for Java.
   - **Kestrel** for .NET.

#### 🚀 Deployment Steps:
1. Clone the repository.
2. Configure the database connection string in:
   - `application.properties` (Java)
   - `appsettings.json` (.NET)
3. Run the provided SQL scripts to initialize the database schema.
4. Build and start the application locally.

---

### 6️⃣ Conclusion

This document outlines the **low-level design** of the E-Commerce Platform, ensuring:
- **Modularity**
- **Scalability**
- **Cross-framework compatibility** with **Spring MVC** and **ASP.NET Core MVC**.

With its robust architecture, the system provides a secure and efficient solution for:
- Product management.
- Shopping cart operations.
- Order processing.
- Payment integration.
- User authentication.

---
🎉 **Happy Coding!**