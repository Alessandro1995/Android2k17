-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema android2k17
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema android2k17
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `android2k17` DEFAULT CHARACTER SET utf8 ;
USE `android2k17` ;

-- -----------------------------------------------------
-- Table `android2k17`.`BAR`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`BAR` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`BAR` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `address` VARCHAR(1023) NOT NULL,
  `latitude` DECIMAL(10,8) NOT NULL,
  `longitude` DECIMAL(11,8) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`CUSTOMER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`CUSTOMER` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`CUSTOMER` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `email` VARCHAR(1024) NOT NULL,
  `password` VARCHAR(256) NOT NULL,
  `device_token` VARCHAR(64) NOT NULL DEFAULT 'NO_TOKEN',
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`EVENT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`EVENT` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`EVENT` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `BAR_ID` INT UNSIGNED NOT NULL,
  `title` VARCHAR(511) NOT NULL,
  `description` TEXT NULL,
  `start_datetime` DATETIME NULL,
  `end_datetime` DATETIME NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_EVENT_BAR1_idx` (`BAR_ID` ASC),
  CONSTRAINT `fk_EVENT_BAR1`
    FOREIGN KEY (`BAR_ID`)
    REFERENCES `android2k17`.`BAR` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`ITEM_SIZE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`ITEM_SIZE` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`ITEM_SIZE` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `size_description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`ITEM_CATEGORY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`ITEM_CATEGORY` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`ITEM_CATEGORY` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`GLOBAL_MENU_ITEM`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`GLOBAL_MENU_ITEM` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`GLOBAL_MENU_ITEM` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`MENU_ITEM`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`MENU_ITEM` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`MENU_ITEM` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `BAR_ID` INT UNSIGNED NOT NULL,
  `ITEM_CATEGORY_ID` INT UNSIGNED NOT NULL,
  `GLOBAL_MENU_ITEM_ID` INT UNSIGNED NULL,
  `menu_item_name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `image_url` VARCHAR(255) NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_MENU_ITEM_BAR1_idx` (`BAR_ID` ASC),
  INDEX `fk_MENU_ITEM_ITEM_CATEGORY1_idx` (`ITEM_CATEGORY_ID` ASC),
  INDEX `fk_MENU_ITEM_GLOBAL_MENU_ITEM1_idx` (`GLOBAL_MENU_ITEM_ID` ASC),
  CONSTRAINT `fk_MENU_ITEM_BAR1`
    FOREIGN KEY (`BAR_ID`)
    REFERENCES `android2k17`.`BAR` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MENU_ITEM_ITEM_CATEGORY1`
    FOREIGN KEY (`ITEM_CATEGORY_ID`)
    REFERENCES `android2k17`.`ITEM_CATEGORY` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MENU_ITEM_GLOBAL_MENU_ITEM1`
    FOREIGN KEY (`GLOBAL_MENU_ITEM_ID`)
    REFERENCES `android2k17`.`GLOBAL_MENU_ITEM` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`INGREDIENT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`INGREDIENT` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`INGREDIENT` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ingredient_name` VARCHAR(256) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`ITEM_ADDITION`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`ITEM_ADDITION` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`ITEM_ADDITION` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `addition_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `name_UNIQUE` (`addition_name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`MEASUREMENT_UNIT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`MEASUREMENT_UNIT` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`MEASUREMENT_UNIT` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`DELIVERY_PLACE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`DELIVERY_PLACE` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`DELIVERY_PLACE` (
  `ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`BAR_HAS_DELIVERY_PLACE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`BAR_HAS_DELIVERY_PLACE` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`BAR_HAS_DELIVERY_PLACE` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `floor` INT UNSIGNED NOT NULL,
  `BAR_ID` INT UNSIGNED NOT NULL,
  `DELIVERY_PLACE_ID` INT UNSIGNED NOT NULL,
  INDEX `fk_BAR_HAS_DELIVERY_PLACE_BAR1_idx` (`BAR_ID` ASC),
  PRIMARY KEY (`ID`),
  INDEX `fk_BAR_HAS_DELIVERY_PLACE_DELIVERY_PLACE1_idx` (`DELIVERY_PLACE_ID` ASC),
  CONSTRAINT `fk_BAR_HAS_DELIVERY_PLACE_BAR1`
    FOREIGN KEY (`BAR_ID`)
    REFERENCES `android2k17`.`BAR` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BAR_HAS_DELIVERY_PLACE_DELIVERY_PLACE1`
    FOREIGN KEY (`DELIVERY_PLACE_ID`)
    REFERENCES `android2k17`.`DELIVERY_PLACE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`CREDIT_CARD`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`CREDIT_CARD` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`CREDIT_CARD` (
  `ID` INT NOT NULL,
  `CUSTOMER_ID` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_CREDIT_CARD_CUSTOMER1_idx` (`CUSTOMER_ID` ASC),
  CONSTRAINT `fk_CREDIT_CARD_CUSTOMER1`
    FOREIGN KEY (`CUSTOMER_ID`)
    REFERENCES `android2k17`.`CUSTOMER` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`CUSTOMER_ORDER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`CUSTOMER_ORDER` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`CUSTOMER_ORDER` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `BAR_HAS_DELIVERY_PLACE_ID` INT UNSIGNED NOT NULL,
  `CUSTOMER_ID` INT UNSIGNED NOT NULL,
  `CREDIT_CARD_ID` INT NULL,
  `using_credit_card` TINYINT(1) NOT NULL,
  `total_price` DOUBLE NOT NULL,
  `is_paid` TINYINT(1) NOT NULL DEFAULT 0,
  `status` VARCHAR(255) NOT NULL,
  `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `destroy_code` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ID`, `BAR_HAS_DELIVERY_PLACE_ID`),
  INDEX `fk_CUSTOMER_ORDER_CUSTOMER1_idx` (`CUSTOMER_ID` ASC),
  INDEX `fk_CUSTOMER_ORDER_BAR_HAS_DELIVERY_PLACE1_idx` (`BAR_HAS_DELIVERY_PLACE_ID` ASC),
  INDEX `fk_CUSTOMER_ORDER_CREDIT_CARD1_idx` (`CREDIT_CARD_ID` ASC),
  CONSTRAINT `fk_CUSTOMER_ORDER_CUSTOMER1`
    FOREIGN KEY (`CUSTOMER_ID`)
    REFERENCES `android2k17`.`CUSTOMER` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUSTOMER_ORDER_BAR_HAS_DELIVERY_PLACE1`
    FOREIGN KEY (`BAR_HAS_DELIVERY_PLACE_ID`)
    REFERENCES `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUSTOMER_ORDER_CREDIT_CARD1`
    FOREIGN KEY (`CREDIT_CARD_ID`)
    REFERENCES `android2k17`.`CREDIT_CARD` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`ORDER_ITEM`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`ORDER_ITEM` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`ORDER_ITEM` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `MENU_ITEM_ID` INT UNSIGNED NOT NULL,
  `CUSTOMER_ORDER_ID` INT UNSIGNED NOT NULL,
  `order_item_name` VARCHAR(511) NOT NULL,
  `total_price` FLOAT NOT NULL,
  `rating` INT UNSIGNED NULL,
  `quantity` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_ORDER_ITEM_MENU_ITEM1_idx` (`MENU_ITEM_ID` ASC),
  INDEX `fk_ORDER_ITEM_CUSTOMER_ORDER1_idx` (`CUSTOMER_ORDER_ID` ASC),
  CONSTRAINT `fk_ORDER_ITEM_MENU_ITEM1`
    FOREIGN KEY (`MENU_ITEM_ID`)
    REFERENCES `android2k17`.`MENU_ITEM` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ORDER_ITEM_CUSTOMER_ORDER1`
    FOREIGN KEY (`CUSTOMER_ORDER_ID`)
    REFERENCES `android2k17`.`CUSTOMER_ORDER` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`QUEUED_GROUP`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`QUEUED_GROUP` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`QUEUED_GROUP` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `on_pause` TINYINT(1) NOT NULL DEFAULT 0,
  `queue_time` DATETIME NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`EVENT_ADD_DISCOUNT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`EVENT_ADD_DISCOUNT` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`EVENT_ADD_DISCOUNT` (
  `EVENT_ID` INT UNSIGNED NOT NULL,
  `MENU_ITEM_ID` INT UNSIGNED NOT NULL,
  `discount` FLOAT NOT NULL,
  PRIMARY KEY (`EVENT_ID`, `MENU_ITEM_ID`),
  INDEX `fk_EVENT_ADD_DISCOUNT_EVENT1_idx` (`EVENT_ID` ASC),
  INDEX `fk_EVENT_ADD_DISCOUNT_MENU_ITEM1_idx` (`MENU_ITEM_ID` ASC),
  CONSTRAINT `fk_EVENT_ADD_DISCOUNT_EVENT1`
    FOREIGN KEY (`EVENT_ID`)
    REFERENCES `android2k17`.`EVENT` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EVENT_ADD_DISCOUNT_MENU_ITEM1`
    FOREIGN KEY (`MENU_ITEM_ID`)
    REFERENCES `android2k17`.`MENU_ITEM` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`CUSTOMER_PREFER_GLOBAL_MENU_ITEM`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`CUSTOMER_PREFER_GLOBAL_MENU_ITEM` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`CUSTOMER_PREFER_GLOBAL_MENU_ITEM` (
  `GLOBAL_MENU_ITEM_ID` INT UNSIGNED NOT NULL,
  `CUSTOMER_ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`GLOBAL_MENU_ITEM_ID`, `CUSTOMER_ID`),
  INDEX `fk_CUSTOMER_PREFER_GLOBAL_MENU_ITEM_CUSTOMER1_idx` (`CUSTOMER_ID` ASC),
  CONSTRAINT `fk_CUSTOMER_PREFER_GLOBAL_MENU_ITEM_GLOBAL_MENU_ITEM1`
    FOREIGN KEY (`GLOBAL_MENU_ITEM_ID`)
    REFERENCES `android2k17`.`GLOBAL_MENU_ITEM` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUSTOMER_PREFER_GLOBAL_MENU_ITEM_CUSTOMER1`
    FOREIGN KEY (`CUSTOMER_ID`)
    REFERENCES `android2k17`.`CUSTOMER` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`MENU_ITEM_HAS_INGREDIENT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`MENU_ITEM_HAS_INGREDIENT` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`MENU_ITEM_HAS_INGREDIENT` (
  `MENU_ITEM_ID` INT UNSIGNED NOT NULL,
  `INGREDIENT_ID` INT UNSIGNED NOT NULL,
  `quantity` VARCHAR(45) NULL,
  PRIMARY KEY (`MENU_ITEM_ID`, `INGREDIENT_ID`),
  INDEX `fk_MENU_ITEM_HAS_INGREDIENT_INGREDIENT1_idx` (`INGREDIENT_ID` ASC),
  CONSTRAINT `fk_MENU_ITEM_HAS_INGREDIENT_MENU_ITEM1`
    FOREIGN KEY (`MENU_ITEM_ID`)
    REFERENCES `android2k17`.`MENU_ITEM` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MENU_ITEM_HAS_INGREDIENT_INGREDIENT1`
    FOREIGN KEY (`INGREDIENT_ID`)
    REFERENCES `android2k17`.`INGREDIENT` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`MENU_ITEM_HAS_SIZE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`MENU_ITEM_HAS_SIZE` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`MENU_ITEM_HAS_SIZE` (
  `MENU_ITEM_ID` INT UNSIGNED NOT NULL,
  `ITEM_SIZE_ID` INT UNSIGNED NOT NULL,
  `price` FLOAT NOT NULL,
  INDEX `fk_ITEM_OF_SIZE_MENU_ITEM1_idx` (`MENU_ITEM_ID` ASC),
  PRIMARY KEY (`MENU_ITEM_ID`, `ITEM_SIZE_ID`),
  CONSTRAINT `fk_ITEM_OF_SIZE_ITEM_SIZE1`
    FOREIGN KEY (`ITEM_SIZE_ID`)
    REFERENCES `android2k17`.`ITEM_SIZE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ITEM_OF_SIZE_MENU_ITEM1`
    FOREIGN KEY (`MENU_ITEM_ID`)
    REFERENCES `android2k17`.`MENU_ITEM` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`ORDER_IN_GROUP`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`ORDER_IN_GROUP` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`ORDER_IN_GROUP` (
  `CUSTOMER_ORDER_ID` INT UNSIGNED NOT NULL,
  `QUEUED_GROUP_ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`CUSTOMER_ORDER_ID`, `QUEUED_GROUP_ID`),
  INDEX `fk_ORDER_IN_GROUP_QUEUED_GROUP1_idx` (`QUEUED_GROUP_ID` ASC),
  CONSTRAINT `fk_ORDER_IN_GROUP_CUSTOMER_ORDER1`
    FOREIGN KEY (`CUSTOMER_ORDER_ID`)
    REFERENCES `android2k17`.`CUSTOMER_ORDER` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ORDER_IN_GROUP_QUEUED_GROUP1`
    FOREIGN KEY (`QUEUED_GROUP_ID`)
    REFERENCES `android2k17`.`QUEUED_GROUP` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`MENU_ITEM_HAS_ADDITION`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`MENU_ITEM_HAS_ADDITION` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`MENU_ITEM_HAS_ADDITION` (
  `MENU_ITEM_ID` INT UNSIGNED NOT NULL,
  `ITEM_ADDITION_ID` INT UNSIGNED NOT NULL,
  `price` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`MENU_ITEM_ID`, `ITEM_ADDITION_ID`),
  INDEX `fk_ITEM_OF_ADDITION_ITEM_ADDITION1_idx` (`ITEM_ADDITION_ID` ASC),
  CONSTRAINT `fk_ITEM_OF_ADDITION_MENU_ITEM1`
    FOREIGN KEY (`MENU_ITEM_ID`)
    REFERENCES `android2k17`.`MENU_ITEM` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ITEM_OF_ADDITION_ITEM_ADDITION1`
    FOREIGN KEY (`ITEM_ADDITION_ID`)
    REFERENCES `android2k17`.`ITEM_ADDITION` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`CUSTOMER_PREFER_MENU_ITEM`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`CUSTOMER_PREFER_MENU_ITEM` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`CUSTOMER_PREFER_MENU_ITEM` (
  `MENU_ITEM_ID` INT UNSIGNED NOT NULL,
  `CUSTOMER_ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`MENU_ITEM_ID`, `CUSTOMER_ID`),
  INDEX `fk_CUSTOMER_PREFER_MENU_ITEM_MENU_ITEM1_idx` (`MENU_ITEM_ID` ASC),
  INDEX `fk_CUSTOMER_PREFER_MENU_ITEM_CUSTOMER1_idx` (`CUSTOMER_ID` ASC),
  CONSTRAINT `fk_CUSTOMER_PREFER_MENU_ITEM_MENU_ITEM1`
    FOREIGN KEY (`MENU_ITEM_ID`)
    REFERENCES `android2k17`.`MENU_ITEM` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUSTOMER_PREFER_MENU_ITEM_CUSTOMER1`
    FOREIGN KEY (`CUSTOMER_ID`)
    REFERENCES `android2k17`.`CUSTOMER` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`OPENING_HOUR`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`OPENING_HOUR` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`OPENING_HOUR` (
  `BAR_ID` INT UNSIGNED NOT NULL,
  `day_of_week` INT NOT NULL,
  `time_open` TIME NOT NULL,
  `working_time` INT NOT NULL,
  PRIMARY KEY (`BAR_ID`, `day_of_week`, `time_open`),
  INDEX `fk_OPENING_HOUR_BAR1_idx` (`BAR_ID` ASC),
  CONSTRAINT `fk_OPENING_HOUR_BAR1`
    FOREIGN KEY (`BAR_ID`)
    REFERENCES `android2k17`.`BAR` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`BAR_TABLE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`BAR_TABLE` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`BAR_TABLE` (
  `DELIVERY_PLACE_ID` INT UNSIGNED NOT NULL,
  `table_number` INT NULL,
  PRIMARY KEY (`DELIVERY_PLACE_ID`),
  CONSTRAINT `fk_BAR_TABLE_DELIVERY_PLACE1`
    FOREIGN KEY (`DELIVERY_PLACE_ID`)
    REFERENCES `android2k17`.`DELIVERY_PLACE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `android2k17`.`BAR_COUNTER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `android2k17`.`BAR_COUNTER` ;

CREATE TABLE IF NOT EXISTS `android2k17`.`BAR_COUNTER` (
  `DELIVERY_PLACE_ID` INT UNSIGNED NOT NULL,
  `counter_name` VARCHAR(255) NULL,
  PRIMARY KEY (`DELIVERY_PLACE_ID`),
  CONSTRAINT `fk_BAR_TABLE_DELIVERY_PLACE10`
    FOREIGN KEY (`DELIVERY_PLACE_ID`)
    REFERENCES `android2k17`.`DELIVERY_PLACE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `android2k17`.`BAR`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`BAR` (`ID`, `name`, `description`, `address`, `latitude`, `longitude`) VALUES (1, 'Star Pub', 'Questo è il bar più bello della storia dei bar!', 'Via Garibaldi 45', 46.06802028, 11.14992142);
INSERT INTO `android2k17`.`BAR` (`ID`, `name`, `description`, `address`, `latitude`, `longitude`) VALUES (2, 'Pub Losco', 'Bar brutto', 'Via Manci 23', 46.0672552, 11.12101110);
INSERT INTO `android2k17`.`BAR` (`ID`, `name`, `description`, `address`, `latitude`, `longitude`) VALUES (3, 'Dal Lurido', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Via Dei Caduti 88', -39.81422, -73.24589);
INSERT INTO `android2k17`.`BAR` (`ID`, `name`, `description`, `address`, `latitude`, `longitude`) VALUES (4, 'Birra&Birra', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Via Roma 2', -31.95021, -65.05354);
INSERT INTO `android2k17`.`BAR` (`ID`, `name`, `description`, `address`, `latitude`, `longitude`) VALUES (5, 'Il Vinaio', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Via Trento 21', 39.98333, 98.86667);
INSERT INTO `android2k17`.`BAR` (`ID`, `name`, `description`, `address`, `latitude`, `longitude`) VALUES (6, 'Da Edo', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Piazza Duomo 9', 5.4179, 100.3296);
INSERT INTO `android2k17`.`BAR` (`ID`, `name`, `description`, `address`, `latitude`, `longitude`) VALUES (7, 'Mc Bar', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Via Torquato Taramelli 14', 14.91667, -87.26667);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`CUSTOMER`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`CUSTOMER` (`ID`, `username`, `date_of_birth`, `email`, `password`, `device_token`) VALUES (1, 'mario', '1990-01-01', 'mario@gmail.com', 'c8320f959b0bf807b30f8992fe822595a45ebff2a9a564b79e766e911f7f5f72', DEFAULT);
INSERT INTO `android2k17`.`CUSTOMER` (`ID`, `username`, `date_of_birth`, `email`, `password`, `device_token`) VALUES (2, 'giulia', '1991-01-01', 'giulia@gmail.com', '9183fc9bba81502fd496aab53e070b24278edf9ea8110f8ae97bd3e5b8585536', DEFAULT);
INSERT INTO `android2k17`.`CUSTOMER` (`ID`, `username`, `date_of_birth`, `email`, `password`, `device_token`) VALUES (3, 'professore', '1980-01-01', 'prof@gmail.com', 'b70a0dcc7063f83b6bd26cf903860b4a3cd98795d777cc66f541495cc45e06bc', DEFAULT);
INSERT INTO `android2k17`.`CUSTOMER` (`ID`, `username`, `date_of_birth`, `email`, `password`, `device_token`) VALUES (4, 'ada', '1995-01-01', 'ada@gmail.com', '06c154f680cf4f6bc0a0f37d76ab8db1812a9eb28c2a23c7780d87ea0e71c5c2', DEFAULT);
INSERT INTO `android2k17`.`CUSTOMER` (`ID`, `username`, `date_of_birth`, `email`, `password`, `device_token`) VALUES (5, 'giovanni', '1995-01-01', 'gio@gmail.com', 'ad6d30351a225c810d9e6600fd43c10a7e16c511c62112ecd73d27e9579404da', DEFAULT);
INSERT INTO `android2k17`.`CUSTOMER` (`ID`, `username`, `date_of_birth`, `email`, `password`, `device_token`) VALUES (6, 'umberto', '1995-01-01', 'umbi@gmail.com', '21042dac9280ad19c734a5ed15d44aa99d1313a7b687a2978e116e7ce8b3a779', DEFAULT);
INSERT INTO `android2k17`.`CUSTOMER` (`ID`, `username`, `date_of_birth`, `email`, `password`, `device_token`) VALUES (7, 'alessandro', '1995-01-01', 'ale@gmail.com', '38f8a1ee75737eb1da00c8b51ec61fc0175a3466581da09adc60f554719b1713', DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`EVENT`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`EVENT` (`ID`, `BAR_ID`, `title`, `description`, `start_datetime`, `end_datetime`) VALUES (1, 1, 'SCONTI', 'SCONTI ABITUALI', NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`ITEM_SIZE`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (1, 'Piccola');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (2, 'Media');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (3, 'Grande');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (4, 'Bicchiere');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (5, 'Bottiglia 75cl');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (6, 'Tazzina');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (7, '50cl');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (8, 'Piccolo');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (9, 'Medio');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (10, 'Lattina');
INSERT INTO `android2k17`.`ITEM_SIZE` (`ID`, `size_description`) VALUES (11, 'Pinta');

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`ITEM_CATEGORY`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`ITEM_CATEGORY` (`ID`, `category_name`) VALUES (1, 'Birre');
INSERT INTO `android2k17`.`ITEM_CATEGORY` (`ID`, `category_name`) VALUES (2, 'Vini');
INSERT INTO `android2k17`.`ITEM_CATEGORY` (`ID`, `category_name`) VALUES (3, 'Bevande analcoliche');
INSERT INTO `android2k17`.`ITEM_CATEGORY` (`ID`, `category_name`) VALUES (4, 'Cocktails');
INSERT INTO `android2k17`.`ITEM_CATEGORY` (`ID`, `category_name`) VALUES (5, 'Cocktails analcolici');
INSERT INTO `android2k17`.`ITEM_CATEGORY` (`ID`, `category_name`) VALUES (6, 'Caffetteria');

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`GLOBAL_MENU_ITEM`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (1, 'Coca cola');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (2, 'Birra Guinnes');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (3, 'Pinot Grigio');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (4, 'Thè alla pesca');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (5, 'Birra chiara');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (6, 'Thè al limone');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (7, 'Vino rosso della casa');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (8, 'Vino bianco della casa');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (9, 'Caffè');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (10, 'Birra Rossa');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (11, 'Birra Scura');
INSERT INTO `android2k17`.`GLOBAL_MENU_ITEM` (`ID`, `name`) VALUES (12, 'Birra Weizen');

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`MENU_ITEM`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (1, 1, 3, 1, 'CocaCola', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus facilisis aliquet.', '279173f3.nuajik.io/416-large_default/coca-cola-classic.jpg');
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (2, 1, 1, 2, 'Birra Guinnes', 'Morbi sollicitudin sed diam semper commodo.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (3, 1, 2, 3, 'Pinot Grigio', 'Curabitur efficitur diam ac scelerisque lobortis. Mauris at enim et quam lacinia aliquet vel vitae eros', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (4, 1, 3, 4, 'Thè alla pesca', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus facilisis aliquet.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (5, 1, 1, 5, 'Birra chiara', ' Donec quis mauris elit. Donec malesuada molestie neque, quis semper massa fermentum ut.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (6, 1, 3, 6, 'Thè al limone', 'Morbi sollicitudin sed diam semper commodo.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (7, 1, 2, 7, 'Vino rosso della casa', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus facilisis aliquet.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (8, 1, 2, 8, 'Vino bianco della casa', 'Curabitur efficitur diam ac scelerisque lobortis. Mauris at enim et quam lacinia aliquet vel vitae eros', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (9, 1, 6, 9, 'Caffè', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus facilisis aliquet.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (10, 1, 1, 10, 'Birra Rossa', ' Donec quis mauris elit. Donec malesuada molestie neque, quis semper massa fermentum ut.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (11, 1, 1, 11, 'Birra Scura', 'Morbi sollicitudin sed diam semper commodo.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (12, 1, 1, 12, 'Birra Weizen', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus facilisis aliquet.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (13, 2, 3, 1, 'Coca-cola', ' Donec quis mauris elit. Donec malesuada molestie neque, quis semper massa fermentum ut.', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (14, 3, 2, 3, 'Pinot Grigio', 'Curabitur efficitur diam ac scelerisque lobortis. Mauris at enim et quam lacinia aliquet vel vitae eros', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (15, 4, 2, 3, 'Pinot Grigio', 'Curabitur efficitur diam ac scelerisque lobortis. Mauris at enim et quam lacinia aliquet vel vitae eros', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (16, 5, 2, 3, 'Pinot Grigio', 'Curabitur efficitur diam ac scelerisque lobortis. Mauris at enim et quam lacinia aliquet vel vitae eros', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (17, 6, 2, 3, 'Pinot Grigio', 'Curabitur efficitur diam ac scelerisque lobortis. Mauris at enim et quam lacinia aliquet vel vitae eros', NULL);
INSERT INTO `android2k17`.`MENU_ITEM` (`ID`, `BAR_ID`, `ITEM_CATEGORY_ID`, `GLOBAL_MENU_ITEM_ID`, `menu_item_name`, `description`, `image_url`) VALUES (18, 7, 2, 3, 'Pinot Grigio', 'Curabitur efficitur diam ac scelerisque lobortis. Mauris at enim et quam lacinia aliquet vel vitae eros', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`INGREDIENT`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`INGREDIENT` (`ID`, `ingredient_name`) VALUES (1, 'Alcool');

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`ITEM_ADDITION`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`ITEM_ADDITION` (`ID`, `addition_name`) VALUES (1, 'ghiaccio');
INSERT INTO `android2k17`.`ITEM_ADDITION` (`ID`, `addition_name`) VALUES (2, 'limone');
INSERT INTO `android2k17`.`ITEM_ADDITION` (`ID`, `addition_name`) VALUES (3, 'arancia');
INSERT INTO `android2k17`.`ITEM_ADDITION` (`ID`, `addition_name`) VALUES (4, 'temp. ambiente');

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`DELIVERY_PLACE`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (1);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (2);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (3);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (4);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (5);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (6);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (7);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (8);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (9);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (10);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (11);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (12);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (13);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (14);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (15);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (16);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (17);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (18);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (19);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (20);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (21);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (22);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (23);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (24);
INSERT INTO `android2k17`.`DELIVERY_PLACE` (`ID`) VALUES (25);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`BAR_HAS_DELIVERY_PLACE`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (1, 1, 1, 1);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (2, 1, 1, 2);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (3, 1, 1, 6);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (4, 1, 1, 7);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (5, 1, 1, 8);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (6, 1, 1, 9);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (7, 1, 2, 3);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (8, 1, 2, 4);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (9, 1, 2, 5);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (10, 1, 2, 6);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (11, 1, 2, 7);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (12, 1, 2, 8);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (13, 1, 2, 9);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (14, 1, 2, 10);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (15, 1, 2, 11);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (16, 1, 3, 1);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (17, 1, 3, 6);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (18, 1, 4, 2);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (19, 1, 4, 6);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (20, 1, 5, 3);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (21, 1, 5, 6);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (22, 1, 6, 4);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (23, 1, 6, 6);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (24, 1, 7, 5);
INSERT INTO `android2k17`.`BAR_HAS_DELIVERY_PLACE` (`ID`, `floor`, `BAR_ID`, `DELIVERY_PLACE_ID`) VALUES (25, 1, 7, 6);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`CREDIT_CARD`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`CREDIT_CARD` (`ID`, `CUSTOMER_ID`, `name`) VALUES (1, 1, 'CARTA_PAYPAL');
INSERT INTO `android2k17`.`CREDIT_CARD` (`ID`, `CUSTOMER_ID`, `name`) VALUES (2, 1, 'CARTA_MASTERCARD');
INSERT INTO `android2k17`.`CREDIT_CARD` (`ID`, `CUSTOMER_ID`, `name`) VALUES (3, 2, 'CARTA_PREPAGATA');
INSERT INTO `android2k17`.`CREDIT_CARD` (`ID`, `CUSTOMER_ID`, `name`) VALUES (4, 3, 'CARTA_GOLD');

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`EVENT_ADD_DISCOUNT`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`EVENT_ADD_DISCOUNT` (`EVENT_ID`, `MENU_ITEM_ID`, `discount`) VALUES (1, 2, 30);
INSERT INTO `android2k17`.`EVENT_ADD_DISCOUNT` (`EVENT_ID`, `MENU_ITEM_ID`, `discount`) VALUES (1, 5, 30);
INSERT INTO `android2k17`.`EVENT_ADD_DISCOUNT` (`EVENT_ID`, `MENU_ITEM_ID`, `discount`) VALUES (1, 10, 30);
INSERT INTO `android2k17`.`EVENT_ADD_DISCOUNT` (`EVENT_ID`, `MENU_ITEM_ID`, `discount`) VALUES (1, 11, 30);
INSERT INTO `android2k17`.`EVENT_ADD_DISCOUNT` (`EVENT_ID`, `MENU_ITEM_ID`, `discount`) VALUES (1, 12, 30);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`MENU_ITEM_HAS_INGREDIENT`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`MENU_ITEM_HAS_INGREDIENT` (`MENU_ITEM_ID`, `INGREDIENT_ID`, `quantity`) VALUES (2, 1, '5');
INSERT INTO `android2k17`.`MENU_ITEM_HAS_INGREDIENT` (`MENU_ITEM_ID`, `INGREDIENT_ID`, `quantity`) VALUES (4, 1, '6');

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`MENU_ITEM_HAS_SIZE`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (1, 1, 3.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (1, 2, 5.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (1, 3, 8.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (2, 1, 3.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (2, 2, 5.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (3, 4, 3.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (3, 5, 15.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (4, 9, 3.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (5, 1, 3.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (5, 2, 5.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (5, 3, 9.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (6, 9, 3.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (7, 4, 3.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (7, 5, 12.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (8, 4, 3.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (8, 5, 14.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (9, 6, 1.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (10, 7, 5.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (11, 7, 5.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (12, 7, 5.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (13, 10, 2.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (14, 4, 3.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (14, 5, 13.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (15, 4, 3.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (15, 5, 14.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (16, 4, 3.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (16, 5, 15.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (17, 4, 3.50);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (17, 5, 16.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (18, 4, 4.00);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_SIZE` (`MENU_ITEM_ID`, `ITEM_SIZE_ID`, `price`) VALUES (18, 5, 17.00);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`MENU_ITEM_HAS_ADDITION`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`MENU_ITEM_HAS_ADDITION` (`MENU_ITEM_ID`, `ITEM_ADDITION_ID`, `price`) VALUES (1, 1, 0);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_ADDITION` (`MENU_ITEM_ID`, `ITEM_ADDITION_ID`, `price`) VALUES (1, 2, 0.5);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_ADDITION` (`MENU_ITEM_ID`, `ITEM_ADDITION_ID`, `price`) VALUES (1, 3, 0.5);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_ADDITION` (`MENU_ITEM_ID`, `ITEM_ADDITION_ID`, `price`) VALUES (2, 1, 0);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_ADDITION` (`MENU_ITEM_ID`, `ITEM_ADDITION_ID`, `price`) VALUES (2, 2, 0);
INSERT INTO `android2k17`.`MENU_ITEM_HAS_ADDITION` (`MENU_ITEM_ID`, `ITEM_ADDITION_ID`, `price`) VALUES (2, 3, 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`OPENING_HOUR`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`OPENING_HOUR` (`BAR_ID`, `day_of_week`, `time_open`, `working_time`) VALUES (1, 5, '18:00:00', 8);
INSERT INTO `android2k17`.`OPENING_HOUR` (`BAR_ID`, `day_of_week`, `time_open`, `working_time`) VALUES (1, 6, '18:00:00', 8);
INSERT INTO `android2k17`.`OPENING_HOUR` (`BAR_ID`, `day_of_week`, `time_open`, `working_time`) VALUES (1, 7, '18:00:00', 6);
INSERT INTO `android2k17`.`OPENING_HOUR` (`BAR_ID`, `day_of_week`, `time_open`, `working_time`) VALUES (2, 5, '20:00:00', 4);
INSERT INTO `android2k17`.`OPENING_HOUR` (`BAR_ID`, `day_of_week`, `time_open`, `working_time`) VALUES (2, 6, '21:00:00', 4);
INSERT INTO `android2k17`.`OPENING_HOUR` (`BAR_ID`, `day_of_week`, `time_open`, `working_time`) VALUES (2, 7, '20:00:00', 5);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`BAR_TABLE`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (6, 1);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (7, 2);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (8, 3);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (9, 4);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (10, 5);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (11, 6);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (12, 7);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (13, 8);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (14, 9);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (15, 10);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (16, 11);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (17, 12);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (18, 13);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (19, 14);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (20, 15);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (21, 16);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (22, 17);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (23, 18);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (24, 19);
INSERT INTO `android2k17`.`BAR_TABLE` (`DELIVERY_PLACE_ID`, `table_number`) VALUES (25, 20);

COMMIT;


-- -----------------------------------------------------
-- Data for table `android2k17`.`BAR_COUNTER`
-- -----------------------------------------------------
START TRANSACTION;
USE `android2k17`;
INSERT INTO `android2k17`.`BAR_COUNTER` (`DELIVERY_PLACE_ID`, `counter_name`) VALUES (1, 'Sala musica');
INSERT INTO `android2k17`.`BAR_COUNTER` (`DELIVERY_PLACE_ID`, `counter_name`) VALUES (2, 'Chiosco cortile');
INSERT INTO `android2k17`.`BAR_COUNTER` (`DELIVERY_PLACE_ID`, `counter_name`) VALUES (3, 'Piano terra');
INSERT INTO `android2k17`.`BAR_COUNTER` (`DELIVERY_PLACE_ID`, `counter_name`) VALUES (4, 'Piano 1°');
INSERT INTO `android2k17`.`BAR_COUNTER` (`DELIVERY_PLACE_ID`, `counter_name`) VALUES (5, 'Piano 2°');

COMMIT;

