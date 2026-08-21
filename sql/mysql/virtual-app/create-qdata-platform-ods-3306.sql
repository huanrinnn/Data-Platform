SET NAMES utf8mb4;

DROP DATABASE IF EXISTS `qdata_platform_ods`;
CREATE DATABASE `qdata_platform_ods`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `qdata_platform_ods`;

CREATE TABLE `ods_app_customers` (
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

CREATE TABLE `ods_app_products` (
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

CREATE TABLE `ods_app_orders` (
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

CREATE TABLE `ods_app_order_items` (
  `item_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `sku` varchar(64) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `unit_price` decimal(12,2) DEFAULT NULL,
  `line_amount` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ods_app_payments` (
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

CREATE TABLE `ods_app_device_events` (
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

CREATE TABLE `ods_app_service_tickets` (
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
