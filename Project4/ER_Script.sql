-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema university
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema university
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `university` DEFAULT CHARACTER SET utf8 ;
USE `university` ;

-- -----------------------------------------------------
-- Table `university`.`grade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`grade` (
  `SSN` VARCHAR(45) NOT NULL,
  `SEMESTER` VARCHAR(45) NULL,
  `YEAR` VARCHAR(45) NULL,
  `CNUM` VARCHAR(45) NULL,
  `SECNUM` VARCHAR(45) NULL,
  `GRADE` VARCHAR(45) NULL,
  PRIMARY KEY (`SSN`),
  UNIQUE INDEX `SSN_UNIQUE` (`SSN` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `university`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`student` (
  `SNAME` INT NOT NULL,
  `SNUM` VARCHAR(45) NOT NULL,
  `SSN` VARCHAR(45) NOT NULL,
  `SCADDR` VARCHAR(45) NULL,
  `SCPHONE` VARCHAR(45) NULL,
  `SPADDR` VARCHAR(45) NULL,
  `SPPHONE` VARCHAR(45) NULL,
  `BDATE` DATE NULL,
  `SEX` BINARY(2) NULL,
  `CLASS` VARCHAR(45) NULL,
  `MAJORDEPTCODE` VARCHAR(45) NULL,
  `MINORDEPTCODE` VARCHAR(45) NULL,
  `PROG` VARCHAR(45) NULL,
  `grade_SSN` VARCHAR(45) NOT NULL,
  UNIQUE INDEX `SNUM_UNIQUE` (`SNUM` ASC) VISIBLE,
  PRIMARY KEY (`SNUM`, `grade_SSN`),
  UNIQUE INDEX `SSN_UNIQUE` (`SSN` ASC) VISIBLE,
  INDEX `fk_student_grade1_idx` (`grade_SSN` ASC) VISIBLE,
  CONSTRAINT `fk_student_grade1`
    FOREIGN KEY (`grade_SSN`)
    REFERENCES `university`.`grade` (`SSN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `university`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`department` (
  `DEPTNAME` INT NOT NULL,
  `DEPTCODE` VARCHAR(45) NOT NULL,
  `DEPTOFFICE` VARCHAR(45) NULL,
  `DEPTPHONE` VARCHAR(45) NULL,
  `DEPTCOLLEGE` VARCHAR(45) NULL,
  `student_SNUM` VARCHAR(45) NOT NULL,
  `COLLEGEDEAN` VARCHAR(45) NULL,
  PRIMARY KEY (`DEPTCODE`, `student_SNUM`),
  UNIQUE INDEX `DEPTCODE_UNIQUE` (`DEPTCODE` ASC) VISIBLE,
  UNIQUE INDEX `DEPTNAME_UNIQUE` (`DEPTNAME` ASC) VISIBLE,
  INDEX `fk_department_student1_idx` (`student_SNUM` ASC) VISIBLE,
  CONSTRAINT `fk_department_student1`
    FOREIGN KEY (`student_SNUM`)
    REFERENCES `university`.`student` (`SNUM`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `university`.`section`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`section` (
  `INSTRUCTORNAME` VARCHAR(45) NOT NULL,
  `SEMESTER` VARCHAR(45) NULL,
  `YEAR` YEAR(4) NULL,
  `SECCOURSE` VARCHAR(45) NULL,
  `SECNUM` INT NOT NULL,
  `INSTRUCTOROFFICE` VARCHAR(45) NULL,
  `student_SNUM` VARCHAR(45) NOT NULL,
  `student_grade_SSN` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`SECNUM`, `student_SNUM`, `student_grade_SSN`),
  INDEX `fk_section_student1_idx` (`student_SNUM` ASC, `student_grade_SSN` ASC) VISIBLE,
  CONSTRAINT `fk_section_student1`
    FOREIGN KEY (`student_SNUM` , `student_grade_SSN`)
    REFERENCES `university`.`student` (`SNUM` , `grade_SSN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `university`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`course` (
  `CNAME` VARCHAR(45) NOT NULL,
  `CDESC` VARCHAR(45) NULL,
  `CNUM` INT NOT NULL,
  `CREDIT` INT NULL,
  `LEVEL` VARCHAR(45) NULL,
  `CDEPT` VARCHAR(45) NULL,
  `section_SECNUM` INT NOT NULL,
  PRIMARY KEY (`CNUM`, `section_SECNUM`),
  UNIQUE INDEX `CNUM_UNIQUE` (`CNUM` ASC) VISIBLE,
  INDEX `fk_course_section1_idx` (`section_SECNUM` ASC) VISIBLE,
  CONSTRAINT `fk_course_section1`
    FOREIGN KEY (`section_SECNUM`)
    REFERENCES `university`.`section` (`SECNUM`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `university`.`student_has_course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university`.`student_has_course` (
  `student_SNUM` VARCHAR(45) NOT NULL,
  `student_grade_SSN` VARCHAR(45) NOT NULL,
  `course_CNUM` INT NOT NULL,
  PRIMARY KEY (`student_SNUM`, `student_grade_SSN`, `course_CNUM`),
  INDEX `fk_student_has_course_course1_idx` (`course_CNUM` ASC) VISIBLE,
  INDEX `fk_student_has_course_student1_idx` (`student_SNUM` ASC, `student_grade_SSN` ASC) VISIBLE,
  CONSTRAINT `fk_student_has_course_student1`
    FOREIGN KEY (`student_SNUM` , `student_grade_SSN`)
    REFERENCES `university`.`student` (`SNUM` , `grade_SSN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_has_course_course1`
    FOREIGN KEY (`course_CNUM`)
    REFERENCES `university`.`course` (`CNUM`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


