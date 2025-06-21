CREATE DATABASE `Ecommerce`;
USE `Ecommerce`;

CREATE TABLE `Users`
(
    `user_id`  int AUTO_INCREMENT PRIMARY KEY,
    `name`     varchar(100) NOT NULL,
    `email`    varchar(50)  NOT NULL UNIQUE,
    `password` varchar(100) NOT NULL,
    `created`  timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `Category`
(
    `category_id` int PRIMARY KEY AUTO_INCREMENT,
    `name`        varchar(100) NOT NULL,
    `desciption`  text,
    `status`      bit DEFAULT (1)
);

CREATE TABLE `Products`
(
    `product_id`  char(5) PRIMARY KEY,
    `name`        varchar(100) NOT NULL UNIQUE,
    `price`       float        NOT NULL CHECK ( `price` > 0 ),
    `stock`       int DEFAULT 0,
    `category_id` int,
    FOREIGN KEY (`category_id`) REFERENCES `Category` (`category_id`) ON DELETE CASCADE
);

CREATE TABLE `Orders`
(
    `order_id`     int AUTO_INCREMENT PRIMARY KEY,
    `created_at`   timestamp DEFAULT CURRENT_TIMESTAMP,
    `total_amount` float,
    `user_id`      int,
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
);

CREATE TABLE `Order_Detail`
(
    `order_id`      int,
    FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`),
    `product_id`    char(5),
    FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`),
    `quantity`      int NOT NULL CHECK ( `quantity` > 0 ),
    `price_at_time` float,
    PRIMARY KEY (`order_id`, `product_id`)
);

INSERT INTO `Category` (`name`, `desciption`)
VALUES ('Điện tử', 'Thiết bị công nghệ'),
       ('Thời trang', 'Quần áo, phụ kiện'),
       ('Gia dụng', 'Đồ dùng gia đình'),
       ('Thể thao', 'Thiết bị thể thao'),
       ('Sách', 'Sách học, kỹ năng, kỹ thuật');

INSERT INTO `Users` (`name`, `email`, `password`)
VALUES ('Nguyễn Văn An', 'anv@gmail.com', '123456'),
       ('Trần Thị Bình', 'binhtt@rikkeisoft.com', '123456'),
       ('Lê Văn Chiến', 'chienlv@rikkei.academy.com', '123456'),
       ('Nguyễn Hà Quyên', 'quyennh@rikkei.education.com', '123456'),
       ('Võ Văn Hải', 'haivv@rikkei.education.com', '123456');

INSERT INTO `Products` (`product_id`, `name`, `price`, `stock`, `category_id`)
VALUES ('P001', 'Iphone 14', 20000000, 10, 1),
       ('P002', 'Laptop Dell XPS', 30000000, 5, 1),
       ('P003', 'Áo thun nam', 250000, 50, 2),
       ('P004', 'Quần jeans nữ', 400000, 10, 2),
       ('P005', 'Nồi cơm điện Sharp', 800000, 10, 3);

INSERT INTO `Orders`(`user_id`, `total_amount`)
VALUES (1, 20200000),
       (2, 325000),
       (3, 800000),
       (4, 1500000),
       (5, 700000),
       (6, 150000),
       (7, 3000000),
       (8, 400000),
       (9, 600000),
       (10, 800000);

INSERT INTO `Order_Detail`(`order_id`, `product_id`, `quantity`, `price_at_time`)
VALUES (1, 'P001', 1, 20000000),
       (1, 'P003', 1, 250000),
       (2, 'P004', 1, 400000),
       (2, 'P005', 1, 800000),
       (3, 'P003', 2, 250000),
       (4, 'P002', 1, 30000000),
       (5, 'P005', 1, 800000),
       (6, 'P001', 1, 20000000),
       (7, 'P002', 1, 30000000),
       (8, 'P004', 1, 400000),
       (9, 'P003', 2, 250000),
       (10, 'P005', 1, 800000);

-- Cập nhật số lượng tồn kho của sản phẩm có product_id = ‘P002’ thành 3
UPDATE `Products`
SET `stock` = 3
WHERE `product_id` = 'P002';
SELECT `stock`
FROM `Products`;

-- Cập nhật tên danh mục ‘Thời trang’ thành ‘Thời trang & Phụ kiện
UPDATE `category`
SET `name` = 'Thời Trang & Phụ Kiện'
WHERE `name` = 'Thời trang';

-- 2.5. Xóa danh mục có tên là ‘Sách’
DELETE
FROM `category`
WHERE `name` = 'Sách';
