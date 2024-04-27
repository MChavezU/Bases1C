SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblPais` (
  `idpais` INT(11) NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`idpais`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblRegion` (
  `idregion` INT(11) NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(100) NOT NULL ,
  `idpais` INT(11) NOT NULL ,
  PRIMARY KEY (`idregion`, `idpais`) ,
  INDEX `tblPais1` (`idpais` ASC) ,
  CONSTRAINT `tblPais1`
    FOREIGN KEY (`idpais` )
    REFERENCES `dbproyc`.`tblPais` (`idpais` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblDepartamento` (
  `iddepartamento` INT(11) NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(100) NOT NULL ,
  `idregion` INT(11) NOT NULL ,
  `idpais` INT(11) NOT NULL ,
  PRIMARY KEY (`iddepartamento`, `idregion`, `idpais`) ,
  INDEX `tblRegion1` (`idregion` ASC, `idpais` ASC) ,
  CONSTRAINT `tblRegion1`
    FOREIGN KEY (`idregion` , `idpais` )
    REFERENCES `dbproyc`.`tblRegion` (`idregion` , `idpais` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblMunicipio` (
  `idmunicipio` INT(11) NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(100) NOT NULL ,
  `iddepartamento` INT(11) NOT NULL ,
  `idregion` INT(11) NOT NULL ,
  `idpais` INT(11) NOT NULL ,
  PRIMARY KEY (`idmunicipio`, `iddepartamento`, `idregion`, `idpais`) ,
  INDEX `tblDepartamento1` (`iddepartamento` ASC, `idregion` ASC, `idpais` ASC) ,
  CONSTRAINT `tblDepartamento1`
    FOREIGN KEY (`iddepartamento` , `idregion` , `idpais` )
    REFERENCES `dbproyc`.`tblDepartamento` (`iddepartamento` , `idregion` , `idpais` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblPoblacion` (
  `idpoblacion` INT(11) NOT NULL AUTO_INCREMENT ,
  `anio` INT(11) NOT NULL ,
  `analfabetos` INT(11) NOT NULL ,
  `primaria` INT(11) NOT NULL ,
  `nivelmedio` INT(11) NOT NULL ,
  `universitario` INT(11) NOT NULL ,
  `idsexo` INT(11) NOT NULL ,
  `idraza` INT(11) NOT NULL ,
  `idteleccion` INT(11) NOT NULL ,
  `idpartido` INT(11) NOT NULL ,
  `idmunicipio` INT(11) NOT NULL ,
  `iddepartamento` INT(11) NOT NULL ,
  `idregion` INT(11) NOT NULL ,
  `idpais` INT(11) NOT NULL ,
  PRIMARY KEY (`idpoblacion`, `idmunicipio`, `iddepartamento`, `idregion`, `idpais`) ,
  INDEX `tblRaza1` (`idraza` ASC) ,
  INDEX `tblMunicipio1` (`idmunicipio` ASC, `iddepartamento` ASC, `idregion` ASC, `idpais` ASC) ,
  INDEX `tblTEleccion1` (`idteleccion` ASC) ,
  INDEX `tblPartido1` (`idpartido` ASC) ,
  INDEX `tblSexo1` (`idsexo` ASC) ,
  CONSTRAINT `tblRaza1`
    FOREIGN KEY (`idraza` )
    REFERENCES `dbproyc`.`tblRaza` (`idraza` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `tblMunicipio1`
    FOREIGN KEY (`idmunicipio` , `iddepartamento` , `idregion` , `idpais` )
    REFERENCES `dbproyc`.`tblMunicipio` (`idmunicipio` , `iddepartamento` , `idregion` , `idpais` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `tblTEleccion1`
    FOREIGN KEY (`idteleccion` )
    REFERENCES `dbproyc`.`tblTEleccion` (`idteleccion` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `tblPartido1`
    FOREIGN KEY (`idpartido` )
    REFERENCES `dbproyc`.`tblPartido` (`idpartido` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `tblSexo1`
    FOREIGN KEY (`idsexo` )
    REFERENCES `dbproyc`.`tblSexo` (`idsexo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = ndbcluster
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblSexo` (
  `idsexo` INT(11) NOT NULL AUTO_INCREMENT ,
  `detalle` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`idsexo`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblRaza` (
  `idraza` INT(11) NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`idraza`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblTEleccion` (
  `idteleccion` INT(11) NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`idteleccion`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `dbproyc`.`tblPartido` (
  `idpartido` INT(11) NOT NULL AUTO_INCREMENT ,
  `siglas` VARCHAR(25) NOT NULL ,
  `nombre` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`idpartido`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
