SET NAMES utf8mb4;

DROP DATABASE IF EXISTS `qdata_virtual_app`;
CREATE DATABASE `qdata_virtual_app`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `qdata_virtual_app`;

CREATE TABLE `app_customers` (
  `customer_id` bigint NOT NULL AUTO_INCREMENT,
  `customer_code` varchar(32) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `gender` varchar(16) DEFAULT NULL,
  `phone` varchar(32) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `id_card` varchar(32) DEFAULT NULL,
  `birth_date` varchar(32) DEFAULT NULL,
  `city` varchar(64) DEFAULT NULL,
  `registered_at` varchar(32) DEFAULT NULL,
  `status` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `app_products` (
  `product_id` bigint NOT NULL AUTO_INCREMENT,
  `sku` varchar(64) DEFAULT NULL,
  `product_name` varchar(128) DEFAULT NULL,
  `category` varchar(64) DEFAULT NULL,
  `unit_price` decimal(12,2) DEFAULT NULL,
  `stock_qty` int DEFAULT NULL,
  `listed_at` varchar(32) DEFAULT NULL,
  `status` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `app_orders` (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) DEFAULT NULL,
  `customer_id` bigint DEFAULT NULL,
  `order_status` varchar(24) DEFAULT NULL,
  `order_amount` decimal(12,2) DEFAULT NULL,
  `discount_amount` decimal(12,2) DEFAULT NULL,
  `paid_amount` decimal(12,2) DEFAULT NULL,
  `order_time` varchar(32) DEFAULT NULL,
  `paid_time` varchar(32) DEFAULT NULL,
  `shipped_time` varchar(32) DEFAULT NULL,
  `delivery_city` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `app_order_items` (
  `item_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `sku` varchar(64) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `unit_price` decimal(12,2) DEFAULT NULL,
  `line_amount` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `app_payments` (
  `payment_id` bigint NOT NULL AUTO_INCREMENT,
  `payment_no` varchar(64) DEFAULT NULL,
  `order_id` bigint DEFAULT NULL,
  `payment_method` varchar(24) DEFAULT NULL,
  `payment_amount` decimal(12,2) DEFAULT NULL,
  `payment_status` varchar(24) DEFAULT NULL,
  `paid_at` varchar(32) DEFAULT NULL,
  `channel_trade_no` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `app_device_events` (
  `event_id` bigint NOT NULL AUTO_INCREMENT,
  `device_code` varchar(64) DEFAULT NULL,
  `customer_id` bigint DEFAULT NULL,
  `event_type` varchar(32) DEFAULT NULL,
  `event_time` varchar(32) DEFAULT NULL,
  `temperature` decimal(8,2) DEFAULT NULL,
  `battery_pct` int DEFAULT NULL,
  `longitude` decimal(10,6) DEFAULT NULL,
  `latitude` decimal(10,6) DEFAULT NULL,
  `raw_payload` text,
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `app_service_tickets` (
  `ticket_id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_no` varchar(64) DEFAULT NULL,
  `customer_id` bigint DEFAULT NULL,
  `priority` varchar(16) DEFAULT NULL,
  `ticket_status` varchar(24) DEFAULT NULL,
  `created_at` varchar(32) DEFAULT NULL,
  `closed_at` varchar(32) DEFAULT NULL,
  `satisfaction_score` int DEFAULT NULL,
  `description` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `app_customers`
(`customer_code`,`full_name`,`gender`,`phone`,`email`,`id_card`,`birth_date`,`city`,`registered_at`,`status`) VALUES
('CUST001','张三','M','13800000001','zhangsan@example.com','320102199001011234','1990-01-01','南京','2025-01-05 09:10:00','ACTIVE'),
('CUST002','李四','F','13800000002','lisi@example.com','320102198806063456','1988-06-06','苏州','2025-01-06 10:20:00','ACTIVE'),
('CUST003',' 王五 ','X','13800000003','wangwu#example.com','ABC123','1989/02/30','杭州','2025-01-07','ACTIVE'),
('CUST004',NULL,'F','','no_name@example.com','320102199512129999','1995-12-12','上海','2025-01-08 11:00:00','ACTIVE'),
('CUST005','赵六','UNKNOWN','13800000005','zhaoliu@example.com',NULL,NULL,'','not-a-date','LOCKED'),
('CUST005','赵六重复','M','13800000005','zhaoliu@example.com','320102199901019999','1999-01-01','南京','2025-01-09 12:30:00','ACTIVE'),
('','空编码客户','F','12345','emptycode@example','320102200001019999','2000-01-01','无锡','2025-01-10 13:00:00','ACTIVE'),
(NULL,'缺编码客户','M',NULL,NULL,NULL,'1970-13-01','常州','2025-01-11 14:00:00','DELETED');

INSERT INTO `app_products`
(`sku`,`product_name`,`category`,`unit_price`,`stock_qty`,`listed_at`,`status`) VALUES
('SKU-1001','智能水杯','智能硬件',199.00,120,'2025-01-01','ON_SALE'),
('SKU-1002','会员年卡','虚拟商品',399.00,9999,'2025-01-02','ON_SALE'),
('SKU-1003','温湿度传感器','物联网设备',89.90,300,'2025-01-03','ON_SALE'),
('SKU-1003','重复 SKU 传感器','物联网设备',79.90,100,'2025-01-04','ON_SALE'),
('SKU-1004',NULL,'智能硬件',-10.00,20,'2025-01-05','ON_SALE'),
('SKU-1005','库存异常商品','',49.90,-5,'bad-date','ON_SALE'),
('', '空 SKU 商品','其他',0.00,0,'2025-01-06','UNKNOWN'),
(NULL,'缺 SKU 商品',NULL,NULL,NULL,NULL,NULL);

INSERT INTO `app_orders`
(`order_no`,`customer_id`,`order_status`,`order_amount`,`discount_amount`,`paid_amount`,`order_time`,`paid_time`,`shipped_time`,`delivery_city`) VALUES
('ORD202501010001',1,'PAID',199.00,0.00,199.00,'2025-01-12 09:00:00','2025-01-12 09:05:00','2025-01-12 08:55:00','南京'),
('ORD202501010002',2,'SHIPPED',399.00,20.00,379.00,'2025-01-12 10:00:00','2025-01-12 10:03:00','2025-01-13 09:00:00','苏州'),
('ORD202501010003',99,'PAID',89.90,0.00,89.90,'2025-01-12 11:00:00','2025-01-12 11:01:00',NULL,'杭州'),
('ORD202501010004',3,'CANCELLED',-1.00,0.00,0.00,'2025-01-12 12:00:00',NULL,NULL,'上海'),
('ORD202501010004',3,'PAID',178.80,0.00,100.00,'2025/01/12 13:00','2025-01-12 12:59:00',NULL,''),
('',4,'INVALID',NULL,NULL,NULL,'not-a-date',NULL,NULL,'南京'),
(NULL,NULL,NULL,49.90,100.00,-50.00,NULL,NULL,NULL,NULL);

INSERT INTO `app_order_items`
(`order_id`,`product_id`,`sku`,`quantity`,`unit_price`,`line_amount`) VALUES
(1,1,'SKU-1001',1,199.00,199.00),
(2,2,'SKU-1002',1,399.00,399.00),
(3,3,'SKU-1003',1,89.90,89.90),
(3,999,'SKU-NOT-EXIST',1,10.00,10.00),
(4,1,'SKU-1001',-1,199.00,-199.00),
(5,3,'SKU-1003',2,89.90,100.00),
(999,1,'SKU-1001',1,199.00,199.00),
(NULL,NULL,NULL,NULL,NULL,NULL);

INSERT INTO `app_payments`
(`payment_no`,`order_id`,`payment_method`,`payment_amount`,`payment_status`,`paid_at`,`channel_trade_no`) VALUES
('PAY202501120001',1,'WECHAT',199.00,'SUCCESS','2025-01-12 09:05:00','WX-0001'),
('PAY202501120002',2,'ALIPAY',379.00,'SUCCESS','2025-01-12 10:03:00','ALI-0002'),
('PAY202501120003',3,'CARD',89.90,'SUCCESS','2025-01-12 11:01:00','CARD-0003'),
('PAY202501120003',3,'CARD',89.90,'SUCCESS','2025-01-12 11:02:00','CARD-0003-DUP'),
('PAY202501120004',999,'WECHAT',10.00,'SUCCESS','2025-01-12 12:00:00','WX-ORPHAN'),
('PAY202501120005',5,'CASH',-100.00,'SUCCESS','bad-time','CASH-NEG'),
('',4,'UNKNOWN',0.00,'UNKNOWN',NULL,NULL),
(NULL,NULL,NULL,NULL,NULL,NULL,NULL);

INSERT INTO `app_device_events`
(`device_code`,`customer_id`,`event_type`,`event_time`,`temperature`,`battery_pct`,`longitude`,`latitude`,`raw_payload`) VALUES
('DEV-001',1,'LOGIN','2025-01-12 09:00:01',25.30,88,118.796877,32.060255,'{\"ok\":true}'),
('DEV-002',2,'HEARTBEAT','2025-01-12 10:00:01',24.10,76,120.585315,31.298886,'{\"ok\":true}'),
('DEV-003',99,'HEARTBEAT','2025-01-12 11:00:01',999.99,101,200.000000,95.000000,'not-json'),
('DEV-004',3,'UNKNOWN','not-a-time',NULL,-1,NULL,NULL,'{\"battery\":\"low\"}'),
('DEV-004',3,'UNKNOWN','not-a-time',NULL,-1,NULL,NULL,'{\"battery\":\"low\"}'),
('',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(NULL,1,'LOGIN','2025-13-40',-273.50,50,118.123456,32.123456,'{\"bad_date\":true}');

INSERT INTO `app_service_tickets`
(`ticket_no`,`customer_id`,`priority`,`ticket_status`,`created_at`,`closed_at`,`satisfaction_score`,`description`) VALUES
('TKT-001',1,'HIGH','CLOSED','2025-01-13 09:00:00','2025-01-13 10:00:00',5,'正常关闭工单'),
('TKT-002',2,'MEDIUM','OPEN','2025-01-13 11:00:00',NULL,NULL,'未关闭工单'),
('TKT-003',99,'LOW','CLOSED','2025-01-13 12:00:00','2025-01-13 11:00:00',4,'关闭时间早于创建时间'),
('TKT-004',3,'URGENT','DONE','bad-date','2025-01-13 13:00:00',10,'非法优先级和状态'),
('TKT-004',3,'URGENT','DONE','bad-date','2025-01-13 13:00:00',10,'重复工单号'),
('',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
