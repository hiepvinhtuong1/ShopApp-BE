CREATE DATABASE shopapp;
USE ShopApp;
-- khách hàng khi muốn mua hàng => phải đăng ký tài khoản => bảng users
CREATE TABLE users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(100) DEFAULT '',
    phone_number VARCHAR(10) NOT NULL,
    address VARCHAR(200) DEFAULT '',
    password VARCHAR(100) NOT NULL  DEFAULT '', 
    created_at DATETIME,
    updated_at DATETIME,
    is_active TINYINT(1) DEFAUlT 1,
    date_of_birth DATE,
    facbook_account_id INT DEFAULT 0,
    google_account_id INT DEFAULT 0
); 
ALTER TABLE users ADD COLUMN role_id INT;
CREATE TABLE roles(
    id INT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);
ALTER TABLE users ADD FOREIGN KEY (role_id) REFERENCES roles(id);
CREATE TABLE tokens(
    id INT PRIMARY KEY AUTO_INCREMENT,
    token VARCHAR(255) UNIQUE NOT NULL,
    token_type VARCHAR(50) NOT NULL,
    expiration_date DATETIME,
    revoked TINYINT(1) NOT NULL,
    expired TINYINT(1) NOT NULL,
    users_id INT,
    FOREIGN KEY (users_id) REFERENCES users(id)
);

--hỗ trợ đăng nhập từ facebook và google
CREATE TABLE social_accounts(
    id INT PRIMARY KEY AUTO_INCREMENT,
    provider varchar(20) not null COMMENT 'Tên nhà social network',
    provider_id varchar(50) not null,
    email varchar(150) not null comment 'Email tài khoản',
    name varchar(100) not null comment 'Tên người dùng',
    users_id int,
    FOREIGN KEY (users_id) REFERENCES users(id)
);

--Bảng danh mục sản phẩm(Category)
create table categories(
    id int PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL DEFAULT '' COMMENT 'Tên danh mục, vd: đồ điện tử'
);

--Bảng chứa sản phẩm(product)
CREATE TABLE products(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(350) COMMENT 'Tên sản phẩm',
    price FLOAT NOT NULL CHECK (price >= 0),
    thumbnail VARCHAR(300) DEFAULT '',
    description LONGTEXT DEFAULT '',
    created_at DATETIME,
    updated_at DATETIME,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

--Đặt hàng - orders
CREATE TABLE orders(
    id INT PRIMARY KEY AUTO_INCREMENT,
    users_id INT,
    FOREIGN KEY (users_id) REFERENCES users(id),
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    address VARCHAR(200) NOT NULL,
    note VARCHAR(100) DEFAULT '',
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20),
    total_money FLOAT CHECK (total_money >= 0)
);

ALTER TABLE orders ADD COLUMN 'shipping_method'VARCHAR(100);
ALTER TABLE orders ADD COLUMN 'shipping_address'VARCHAR(100)
ALTER TABLE orders ADD COLUMN 'shipping_date'DATE;
ALTER TABLE orders ADD COLUMN 'tracking_number'VARCHAR(100);
ALTER TABLE orders ADD COLUMN 'payment_method'VARCHAR(100);
--xóa 1 đơn hàng => xóa mềm => thêm trường active
ALTER TABLE orders ADD COLUMN 'active'TINYINT(1);
--trạng thái đơn hàng chỉ được phép nhận 'một số giá trị cụ thể'
ALTER TABLE orders
 MODIFY COLUMN status ENUM('pending','processing','shipped','delivered','cancelled') COMMENT 'Trạng thái đơn hàng';

CREATE TABLE order_details(
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products(id),
    price FLOAT CHECK (price >= 0),
    number_of_products INT CHECK(number_of_products > 0),
    total_money FLOAT CHECK (price >= 0),
    color VARCHAR(20) DEFAULT ''
);