-- 2.1  Truy vấn cơ bản
-- Liệt kê tất cả người dùng trong hệ thống.

SELECT `u`.`user_id`, `u`.`name` `TenNguoiDung`, `u`.`email`
FROM `users` `u`;

-- Liệt kê tên và giá của tất cả sản phẩm.
SELECT `p`.`product_id`, `p`.`name` `Ten`, `p`.`price` `Gia`
FROM `products` `p`;

-- Liệt kê tên danh mục và mô tả.

SELECT `c`.`name` `TenDanhMuc`, `c`.`desciption` `MoTa`
FROM `category` `c`;

-- Liệt kê mã sản phẩm, tên và số lượng tồn kho.

SELECT `p`.`product_id` `MaSanPham`, `p`.`name` `TenSanPham`, `p`.`stock` `SoLuongTonKho`
FROM `products` `p`;

-- Liệt kê đơn hàng gồm order_id, user_id, total_amount.
SELECT `o`.`order_id`, `o`.`user_id`, `o`.`total_amount`
FROM `orders` `o`;

-- Liệt kê các bản ghi trong bảng Order_Detail.

SELECT `od`.`order_id`, `od`.`product_id`, `od`.`price_at_time`, `od`.`quantity`
FROM `order_detail` `od`;

-- 2.2 Truy vấn có điều kiện
-- Liệt kê người dùng có email kết thúc bằng “@gmail.com”.
SELECT `u`.`user_id`, `u`.`name`, `u`.`email`
FROM `users` `u`
WHERE `email` LIKE '%@gmail.com';

-- Liệt kê sản phẩm có giá trên 1 triệu đồng.
SELECT `p`.`product_id`, `p`.`name`, `p`.`price`
FROM `products` `p`
WHERE `p`.`price` > 1000000;

-- Liệt kê đơn hàng có tổng tiền lớn hơn 5 triệu.

SELECT `o`.`order_id`, `o`.`total_amount`
FROM `orders` `o`
WHERE `total_amount` > 5000000;

-- Liệt kê sản phẩm còn hàng (stock > 0).
SELECT `p`.`name` `SanPham`, `p`.`stock` AS `HangTonKho`
FROM `products` `p`;

-- Liệt kê đơn hàng được tạo sau ngày 2024-06-05.
SELECT `o`.`order_id`, `o`.`created_at`
FROM `orders` `o`
WHERE `o`.`created_at` > '2024-06-05';

-- Liệt kê danh mục có tên là “Sách”.
SELECT `c`.`name`, `c`.`desciption`
FROM `category` `c`
WHERE `name` = 'Sách';

-- 2.3 Truy vấn có nhóm dữ liệu
-- Đếm số lượng sản phẩm thuộc mỗi danh mục.
SELECT `c`.`category_id`, `c`.`name`, COUNT(DISTINCT `p`.`product_id`) `TongSoLuong`
FROM `products` `p`
         JOIN `category` `c` ON `p`.`category_id` = `c`.`category_id`
GROUP BY `c`.`category_id`, `c`.`name`;

-- Tính tổng số lượng tồn kho theo từng danh mục sản phẩm.
SELECT `c`.`category_id`, `c`.`name`, SUM(`p`.`stock`) `TonKho`
FROM `category` `c`
         JOIN `products` `p` ON `p`.`category_id` = `c`.`category_id`
GROUP BY `c`.`category_id`;

-- Tính tổng tiền mỗi người đã đặt hàng (theo user_id).
SELECT `u`.`user_id`, `u`.`name`, SUM(`o`.`total_amount`) `TongTien`
FROM `orders` `o`
         JOIN `users` `u` ON `u`.`user_id` = `o`.`user_id`
GROUP BY `u`.`user_id`, `u`.`name`;

-- Tính số lượng đơn hàng của mỗi người dùng.
SELECT `u`.`user_id`, `u`.`name`, COUNT(`o`.`order_id`) `TongDonHang`
FROM `orders` `o`
         JOIN `users` `u` ON `u`.`user_id` = `o`.`user_id`
GROUP BY `u`.`user_id`, `u`.`name`;

-- Tính số lượng sản phẩm khác nhau trong từng đơn hàng.
SELECT `od`.`order_id`, COUNT(DISTINCT `od`.`product_id`) `SoLuongSanPhamKhacNhau`
FROM `order_detail` `od`
GROUP BY `od`.`order_id`;

-- Liệt kê các người dùng có tổng số tiền đơn hàng > 10 triệu.
SELECT `u`.`user_id`, `u`.`name`, SUM(`o`.`total_amount`) AS `TongTien`
FROM `users` `u`
         JOIN `orders` `o` ON `o`.`user_id` = `u`.`user_id`
GROUP BY `u`.`user_id`, `u`.`name`
HAVING `TongTien` > 10000000
ORDER BY `TongTien` DESC;

-- Liệt kê danh mục có tổng số sản phẩm tồn kho > 100.
SELECT `c`.`category_id`, `c`.`name`, SUM(`p`.`stock`) `TonKho`
FROM `category` `c`
         JOIN `products` `p` ON `p`.`category_id` = `c`.`category_id`
GROUP BY `c`.`category_id`, `c`.`name`
HAVING `TonKho` > 100;

-- Liệt kê đơn hàng có nhiều hơn 2 loại sản phẩm.
SELECT `od`.`order_id`, COUNT(DISTINCT `od`.`product_id`)
FROM `order_detail` `od`
GROUP BY `od`.`order_id`
HAVING COUNT(DISTINCT `od`.`product_id`) > 2;

-- Liệt kê người dùng có hơn 1 đơn hàng.
SELECT `u`.`user_id`, `u`.`name`, COUNT(DISTINCT `o`.`order_id`) `SoDonHang`
FROM `users` `u`
         JOIN `orders` `o` ON `o`.`user_id` = `u`.`user_id`
GROUP BY `u`.`user_id`, `u`.`name`
HAVING `SoDonHang` > 1;

-- 2.4. Truy vấn sử dụng đầy đủ các mệnh đề
-- Liệt kê 5 sản phẩm có giá cao nhất
SELECT `p`.`product_id`, `p`.`name`, `p`.`price`
FROM `products` `p`
ORDER BY `p`.`price` DESC
LIMIT 5;

-- Liệt kê tên sản phẩm và giá, sắp xếp theo price tăng dần

SELECT `p`.`name`, `p`.`price`
FROM `products` `p`
ORDER BY `p`.`price`;

-- Liệt kê tất cả đơn hàng, hiển thị thêm cột VAT = 10% tổng tiền.
SELECT `o`.`order_id`, FORMAT((`o`.`total_amount` * 0.1), 0) `VAT (10%)`
FROM `orders` `o`;

-- 2.5. Truy vấn lồng
-- Liệt kê sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm.

SELECT `p`.`product_id`, `p`.`name`, FORMAT(`p`.`price`, 0)
FROM `products` `p`
WHERE `p`.`price` > (SELECT AVG(`p2`.`price`)
                     FROM `products` `p2`);

-- Liệt kê người dùng đã từng đặt ít nhất 1 đơn hàng.
SELECT `u`.`name`, `u`.`user_id`, COUNT(`u`.`user_id`) `SoDonHang`
FROM `orders` `o`
         JOIN `users` `u` ON `u`.`user_id` = `o`.`user_id`
GROUP BY `u`.`user_id`, `u`.`name`;

-- Liệt kê tên sản phẩm xuất hiện trong đơn hàng có tổng tiền > 20 triệu.
SELECT DISTINCT `p`.`name`, `o`.`order_id`
FROM `products` `p`
         JOIN `order_detail` `od` ON `od`.`product_id` = `p`.`product_id`
         JOIN `orders` `o` ON `o`.`order_id` = `od`.`order_id`
WHERE `o`.`total_amount` > 20000000;


-- Liệt kê đơn hàng chứa sản phẩm thuộc danh mục “Điện tử”.

SELECT DISTINCT `o`.`order_id`, `p`.`name`
FROM `orders` `o`
         JOIN `order_detail` `od` ON `od`.`order_id` = `o`.`order_id`
         JOIN `products` `p` ON `p`.`product_id` = `od`.`product_id`
         JOIN `category` `c` ON `p`.`category_id` = `c`.`category_id`
WHERE `c`.`name` = 'Điện tử';

