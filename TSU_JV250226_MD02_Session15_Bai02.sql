create database SaleManagement;
use SaleManagement;
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price FLOAT NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO Products (product_name, price, quantity) VALUES
('Cà phê sữa đá', 25000, 100),
('Trà đào cam sả', 30000, 80),
('Bạc xỉu', 28000, 60),
('Matcha đá xay', 45000, 40),
('Sinh tố xoài', 35000, 50);



create table Customers (
customer_id int auto_increment primary key,
full_name varchar(100) not null,
email varchar(100) not null unique
);

INSERT INTO Customers (full_name, email) VALUES
('Nguyễn Văn An', 'nguyenvana@example.com'),
('Trần Thị Bích', 'tranbich@example.com'),
('Lê Hoàng Nam', 'lehoangnam@example.com'),
('Phạm Minh Châu', 'minhchau@example.com'),
('Đỗ Tuấn Kiệt', 'dotuankiet@example.com');

create table Orders (
order_id int auto_increment primary key,
customer_id int,
order_date date not null,
foreign key (customer_id) references Customers(customer_id) on delete cascade
);

INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2025-06-10'),
(2, '2025-06-11'),
(3, '2025-06-12'),
(4, '2025-06-13'),
(5, '2025-06-14');

create table OrderDetails(
detail_id int auto_increment primary key,
order_id int,
product_id int,
quantity int not null,
foreign key (order_id) references Orders(order_id),
foreign key (product_id) references Products (product_id)
);

INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 2),   -- Nguyễn Văn A mua 2 Cà phê sữa đá
(1, 2, 1),   -- và 1 Trà đào cam sả
(2, 3, 2),   -- Trần Thị Bích mua 2 Bạc xỉu
(2, 1, 1),   -- và 1 Cà phê sữa đá
(3, 4, 1),   -- Lê Hoàng Nam mua 1 Matcha đá xay
(3, 5, 1),   -- và 1 Sinh tố xoài
(4, 2, 2),   -- Phạm Minh Châu mua 2 Trà đào cam sả
(5, 3, 1),   -- Đỗ Tuấn Kiệt mua 1 Bạc xỉu
(5, 4, 2),   -- và 2 Matcha đá xay
(5, 1, 1);   -- và thêm 1 Cà phê sữa đá

select * from products;
select * from orders;
select * from customers;

-- Lấy danh sách tất cả sản phẩm và số lượng đã bán.
SELECT 
    p.product_id, p.product_name, sum(o.quantity) AS soluong_ban
FROM
    Products p
        JOIN
    orderdetails o ON o.product_id = p.product_id
GROUP BY product_id , product_name;
 
-- Tìm khách hàng có giá trị đơn hàng lớn nhất.
SELECT 
    c.customer_id,
    c.full_name AS customer_Name,
    SUM(odt.quantity * price) AS tong_tien
FROM
    Customers c
        JOIN
    orders o ON o.customer_id = c.customer_id
        JOIN
    orderdetails odt ON odt.order_id = o.order_id
        JOIN
    products p ON p.product_id = odt.product_id
GROUP BY c.customer_id , c.full_name
ORDER BY tong_tien DESC
LIMIT 1;

-- Cập nhật giá sản phẩm có product_id = 1 và số lượng tương ứng.
SELECT 
    product_id, price, product_name, quantity
FROM
    Products
WHERE
    product_id = 1;
UPDATE products 
SET 
    price = 40000,
    quantity = 50
WHERE
    product_id = 1;

-- Xóa tất cả đơn hàng cũ hơn 1 năm .
set sql_safe_updates = 0;
delete 
from orders o
where o.order_date < curdate() - interval 1 year;
set sql_safe_updates = 1;

-- Tính tổng doanh thu từ tất cả đơn hàng.
SELECT 
    SUM(od.quantity * p.price) AS tong_doanh_thu
FROM
    orders o
        JOIN
    orderDetails od ON od.order_id = o.order_id
        JOIN
    products p ON p.product_id = od.product_id;

-- Lấy danh sách khách hàng, số lượng đơn hàng và tổng giá trị đơn hàng của họ.

SELECT 
    c.customer_id,
    c.full_name AS customer_Name,
    COUNT(o.order_id) AS so_don_hang,
    SUM(od.quantity * price) AS hoa_don_tong_tien
FROM
    customers c
        JOIN
    orders o ON o.customer_id = c.customer_id
        JOIN
    orderdetails od ON od.order_id = o.order_id
        JOIN
    products p ON p.product_id = od.product_id
GROUP BY c.customer_id , full_name;

-- Tìm sản phẩm có doanh thu cao nhất.

SELECT 
    p.product_id,
    p.product_name,
    SUM(od.quantity * p.price) AS doanh_thu
FROM
    products p
        JOIN
    orderdetails od ON od.product_id = p.product_id
GROUP BY p.product_id , p.product_name
ORDER BY doanh_thu DESC
LIMIT 1;

-- Lấy danh sách đơn hàng và thông tin khách hàng cho đơn hàng có tổng giá trị lớn hơn 500.
SELECT 
    o.order_id,
    c.full_name AS customer_name,
    c.email,
    SUM(od.quantity * p.price) AS tien_don_hang
FROM
    orders o
        JOIN
    orderdetails od ON od.order_id = o.order_id
        JOIN
    customers c ON c.customer_id = o.customer_id
        JOIN
    products p ON p.product_id = od.product_id
GROUP BY o.order_id , c.full_name , c.email
HAVING tien_don_hang > 100000;

-- Sắp xếp sản phẩm theo số lượng bán từ cao đến thấp.
SELECT 
    p.product_id,
    p.product_name,
    COUNT(od.quantity) AS so_luong_ban
FROM
    products p
        JOIN
    orderdetails od ON od.product_id = p.product_id
GROUP BY p.product_id , p.product_name
ORDER BY so_luong_ban DESC;

-- Tìm khách hàng đã đặt hàng nhiều nhất trong tháng này.
SELECT 
    c.customer_id,
    c.full_name AS customer_name,
    COUNT(od.order_id) AS so_don_hang
FROM
    customers c
        JOIN
    orders o ON o.customer_id = c.customer_id
        JOIN
    orderdetails od ON od.order_id = o.order_id
WHERE
    MONTH(order_date) = MONTH(NOW())
        AND YEAR(order_date) = YEAR(NOW())
GROUP BY c.customer_id , c.full_name
ORDER BY so_don_hang DESC
LIMIT 1;

-- Thống kê số tiền tồn kho của mỗi sản phẩm ( công thức tính = quantity * price ).
SELECT 
    p.product_id,
    p.product_name,
    p.quantity AS so_luong_ton_kho,
    (p.quantity * p.price) AS so_tien
FROM
    products p;



-- Cập nhật cho từng dòng theo order_id và product_id
ALTER TABLE orderdetails
ADD status VARCHAR(50);
UPDATE orderdetails SET status = 'Đã thanh toán' WHERE order_id = 1 AND product_id = 1;
UPDATE orderdetails SET status = 'Đã thanh toán' WHERE order_id = 1 AND product_id = 2;
UPDATE orderdetails SET status = 'Đã thanh toán' WHERE order_id = 2 AND product_id = 3;
UPDATE orderdetails SET status = 'Đã thanh toán' WHERE order_id = 2 AND product_id = 1;
UPDATE orderdetails SET status = 'Chưa thanh toán' WHERE order_id = 3 AND product_id = 4;
UPDATE orderdetails SET status = 'Chưa thanh toán' WHERE order_id = 3 AND product_id = 5;
UPDATE orderdetails SET status = 'Đang xử lý' WHERE order_id = 4 AND product_id = 2;
UPDATE orderdetails SET status = 'Đã thanh toán' WHERE order_id = 5 AND product_id = 3;
UPDATE orderdetails SET status = 'Đã thanh toán' WHERE order_id = 5 AND product_id = 4;
UPDATE orderdetails SET status = 'Đã thanh toán' WHERE order_id = 5 AND product_id = 1;
SELECT status FROM orderdetails;

-- Tìm các đơn hàng chưa được thanh toán

select o.order_id, od.status
from orders o
join orderdetails od on o.order_id = od.order_id
where od.status ='chưa thanh toán' or  od.status = 'Đang xử lý';

-- Lấy danh sách sản phẩm không có trong bất kỳ đơn hàng nào.

SELECT 
    p.product_id, p.product_name
FROM
    products p
WHERE
    NOT EXISTS( SELECT 
            od.product_id
        FROM
            orderdetails od
        WHERE
            od.product_id = p.product_id);
            
-- Tìm các khách hàng chưa từng đặt hàng.   

select c.customer_id, c.full_name
from customers c
where not exists (
select 1
 from orders o
 where o.customer_id = c.customer_id
);


-- Tìm sản phẩm có giá lớn hơn giá trung bình của tất cả sản phẩm và giá lớn hơn giá của sản phẩm  có product_id = 1.
-- dùng CTE - Common Table Expression

with product_Price as (
select p.product_id, p.product_name, p.price as gia_san_pham
from products p
),
average_Price as (
select avg(gia_san_pham) as avg_Price
from product_Price
)
select pdp.product_id, pdp.product_name, pdp.gia_san_pham
from product_Price pdp
join average_Price avgp on pdp.gia_san_pham > avgp.avg_Price 
where pdp.gia_san_pham > (select 
p.price from products p
where p.product_id = 1
);
