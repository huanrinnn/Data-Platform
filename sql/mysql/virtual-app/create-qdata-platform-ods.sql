SET NAMES utf8mb4;

DROP DATABASE IF EXISTS `qdata_platform_ods`;
CREATE DATABASE `qdata_platform_ods`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `qdata_platform_ods`;

CREATE TABLE `ods_app_customers` LIKE `qdata_virtual_app`.`app_customers`;
CREATE TABLE `ods_app_products` LIKE `qdata_virtual_app`.`app_products`;
CREATE TABLE `ods_app_orders` LIKE `qdata_virtual_app`.`app_orders`;
CREATE TABLE `ods_app_order_items` LIKE `qdata_virtual_app`.`app_order_items`;
CREATE TABLE `ods_app_payments` LIKE `qdata_virtual_app`.`app_payments`;
CREATE TABLE `ods_app_device_events` LIKE `qdata_virtual_app`.`app_device_events`;
CREATE TABLE `ods_app_service_tickets` LIKE `qdata_virtual_app`.`app_service_tickets`;
