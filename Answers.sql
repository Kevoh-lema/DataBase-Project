create database if not exists bookstoredb;
use bookstoredb;


CREATE TABLE book_language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(100)
);

CREATE TABLE publisher (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(255),
    contact_email VARCHAR(100)
);

CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    bio TEXT
);

CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100)
);

CREATE TABLE address_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50)
);

CREATE TABLE shipping_method (
    shipping_method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(100),
    shipping_cost DECIMAL(10, 2)
);

CREATE TABLE order_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50)
);

-- Step 2: Tables that depend on the above
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Step 3: Tables that depend on customer/address/etc
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Step 4: Book and mapping tables
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    isbn VARCHAR(20) UNIQUE,
    price DECIMAL(10, 2),
    publication_date DATE,
    publisher_id INT,
    language_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Step 5: Order-related tables
CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    shipping_method_id INT,
    status_id INT,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT,
    price_each DECIMAL(10, 2),
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

CREATE TABLE order_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    status_id INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Re-enable foreign key checks
SET foreign_key_checks = 1;

-- Sample data insertion
INSERT INTO book_language (language_name) VALUES ('English'), ('Kiswahili'), ('Spanish');

INSERT INTO publisher (publisher_name, contact_email) VALUES
('Long Horn', 'longhorn@gmail.com'),
('Oxford', 'info@oxford.com'),
('Danzel', 'danzel@gmail.com');

INSERT INTO author (first_name, last_name, bio) VALUES
('George', 'Orwell', 'Author of 1984 and Animal Farm'),
('J.K.', 'Rowling', 'Author of the Harry Potter series'),
('Chinua', 'Achebe', 'Author of Things Fall Apart');

INSERT INTO country (country_name) VALUES ('Kenya'), ('United States'), ('United Kingdom');

INSERT INTO address_status (status_name) VALUES ('current'), ('old');

INSERT INTO address (street, city, state, postal_code, country_id) VALUES
('Moi Avenue', 'Nairobi', 'Nairobi', '00100', 1),
('5th Avenue', 'New York', 'NY', '10001', 2),
('Baker Street', 'London', 'England', 'NW1 6XE', 3);

INSERT INTO customer (first_name, last_name, email, phone_number) VALUES
('Kevin', 'Koskei', 'koskeikevin@gmail.com', '+254794494384'),
('Brian', 'Ngugi', 'brian.j@yahoo.com', '+11234567890');


INSERT INTO customer_address (customer_id, address_id, status_id) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1);

INSERT INTO book (title, isbn, price, publication_date, publisher_id, language_id) VALUES
('1984', '9780451524935', 9.99, '1949-06-08', 1, 1),
('Harry Potter and the Philosopher''s Stone', '9780747532743', 12.99, '1997-06-26', 2, 1),
('Things Fall Apart', '9780385474542', 10.99, '1958-01-01', 3, 1);

INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO shipping_method (method_name, shipping_cost) VALUES ('Standard', 3.99), ('Express', 7.99);

INSERT INTO order_status (status_name) VALUES ('pending'), ('shipped'), ('delivered'), ('cancelled');

INSERT INTO cust_order (customer_id, order_date, shipping_method_id, status_id, total_amount) VALUES
(1, '2025-04-10', 1, 1, 22.98),
(2, '2025-04-11', 2, 2, 10.99);

INSERT INTO order_line (order_id, book_id, quantity, price_each) VALUES
(1, 1, 1, 9.99),
(1, 2, 1, 12.99),
(2, 3, 1, 10.99);

INSERT INTO order_history (order_id, status_id) VALUES
(1, 1),
(2, 2);



