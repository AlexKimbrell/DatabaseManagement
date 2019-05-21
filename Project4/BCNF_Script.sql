-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema university
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema university
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `university` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
-- -----------------------------------------------------
-- Schema employees
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema employees
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `employees` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `university` ;

-- -----------------------------------------------------
-- Table `university`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`course` (
  `CNUM` INT(11) NOT NULL,
  `CNAME` VARCHAR(45) NULL DEFAULT NULL,
  `CDESC` VARCHAR(45) NULL DEFAULT NULL,
  `CREDIT` INT(11) NULL DEFAULT NULL,
  `LEVEL` INT(11) NULL DEFAULT NULL,
  `CDEPT` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`CNUM`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `university`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`department` (
  `DEPTNAME` VARCHAR(45) NULL DEFAULT NULL,
  `DEPTPHONE` INT(11) NULL DEFAULT NULL,
  `DEPTOFFICE` VARCHAR(45) NULL DEFAULT NULL,
  `DEPTCODE` INT(11) NOT NULL,
  `INST_ID` INT NOT NULL,
  PRIMARY KEY (`DEPTCODE`),
  UNIQUE INDEX `INST_ID_UNIQUE` (`INST_ID` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `university`.`grade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`grade` (
  `SSN` INT(11) NOT NULL,
  `GRADE` INT(11) NULL DEFAULT NULL,
  `CNUM` VARCHAR(45) NULL DEFAULT NULL,
  `SECNUM` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`SSN`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `university`.`section`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`section` (
  `SECNUM` INT(11) NOT NULL,
  `SEM` VARCHAR(45) NULL DEFAULT NULL,
  `YEAR` INT(11) NULL DEFAULT NULL,
  `SECCOURSE` VARCHAR(45) NULL DEFAULT NULL,
  `INST_ID` INT NULL,
  PRIMARY KEY (`SECNUM`),
  UNIQUE INDEX `INST_ID_UNIQUE` (`INST_ID` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `university`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`student` (
  `SSN` INT(11) NOT NULL,
  `SNAME` VARCHAR(45) NULL DEFAULT NULL,
  `SPADDR` VARCHAR(45) NULL DEFAULT NULL,
  `SPHONE` VARCHAR(45) NULL DEFAULT NULL,
  `BDATE` DATETIME NULL DEFAULT NULL,
  `SEX` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`SSN`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `university`.`university`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`university` (
  `SNAME` INT(11) NOT NULL,
  `SNUM` INT(11) NOT NULL,
  `SCADDR` VARCHAR(45) NULL DEFAULT NULL,
  `SCPHONE` VARCHAR(45) NULL DEFAULT NULL,
  `CLASS` VARCHAR(45) NULL DEFAULT NULL,
  `MAJORDEPTCODE` INT(11) NULL DEFAULT NULL,
  `MINORDEPTCODE` INT(11) NULL DEFAULT NULL,
  `PROG` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`SNAME`, `SNUM`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `university`.`college`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`college` (
  `COL_ID` INT NOT NULL AUTO_INCREMENT,
  `DEPTCOLLEGE` VARCHAR(45) NULL,
  `COLLEGEDEAN` VARCHAR(45) NULL,
  PRIMARY KEY (`COL_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `university`.`instructor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`instructor` (
  `INST_ID` INT NOT NULL AUTO_INCREMENT,
  `INSTNAME` VARCHAR(45) NULL,
  `INSTRUCTOROFFICE` VARCHAR(45) NULL,
  PRIMARY KEY (`INST_ID`))
ENGINE = InnoDB;

USE `employees` ;
USE `employees` ;

-- -----------------------------------------------------
-- Placeholder table for view `employees`.`current_dept_emp`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `employees`.`current_dept_emp` (`emp_no` INT, `dept_no` INT, `from_date` INT, `to_date` INT);

-- -----------------------------------------------------
-- Placeholder table for view `employees`.`dept_emp_latest_date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `employees`.`dept_emp_latest_date` (`emp_no` INT, `from_date` INT, `to_date` INT);

-- -----------------------------------------------------
-- View `employees`.`current_dept_emp`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `employees`.`current_dept_emp`;
USE `employees`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `employees`.`current_dept_emp` AS select `l`.`emp_no` AS `emp_no`,`d`.`dept_no` AS `dept_no`,`l`.`from_date` AS `from_date`,`l`.`to_date` AS `to_date` from (`employees`.`dept_emp` `d` join `employees`.`dept_emp_latest_date` `l` on(((`d`.`emp_no` = `l`.`emp_no`) and (`d`.`from_date` = `l`.`from_date`) and (`l`.`to_date` = `d`.`to_date`))));

-- -----------------------------------------------------
-- View `employees`.`dept_emp_latest_date`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `employees`.`dept_emp_latest_date`;
USE `employees`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `employees`.`dept_emp_latest_date` AS select `employees`.`dept_emp`.`emp_no` AS `emp_no`,max(`employees`.`dept_emp`.`from_date`) AS `from_date`,max(`employees`.`dept_emp`.`to_date`) AS `to_date` from `employees`.`dept_emp` group by `employees`.`dept_emp`.`emp_no`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
