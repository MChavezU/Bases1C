USE dbproyc;

/*Creación Tabla Temporal*/
CREATE TEMPORARY TABLE dtload(
      noc int AUTO_INCREMENT,
      neleccion varchar(100) NOT NULL,
      anio int NOT NULL,
      pais varchar(100) NOT NULL,
      region varchar(100) NOT NULL,
      depto varchar(100) NOT NULL,
      municipio varchar(100) NOT NULL,
      spartido varchar(100) NOT NULL,
      npartido varchar(100) NOT NULL,
      sexo varchar(50) NOT NULL,
      raza varchar(50) NOT NULL,
      analfabetos int NOT NULL,
      primaria int NOT NULL,
      nmedio int NOT NULL,
      univer int NOT NULL,
      primary key(noc)
);

/*VERIFICAR CREACION - TABLA TEMPORAL VACIA*/
SELECT * from dtload;

/*EJECUCIÓN LOAD DATA INFILE - Carga de datos a tabla temporal*/
LOAD DATA INFILE 'C:\\Users\\Usuario\\Desktop\\U012024\\Bases1\\Clase\\Proyecto\\Proy\\fuente00.csv' INTO TABLE dtload
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
(noc,neleccion,anio,pais,region,depto,municipio,spartido,npartido,sexo,raza,analfabetos,primaria,nmedio,univer);

/*VERIFICAR CARGA TEMPORAL*/
SELECT * FROM dtload;

/*GENERACION LOAD A NUEVO MODELO DESARROLLADO*/
/*Cargar Tipo Elección*/
INSERT INTO tblTEleccion(nombre)
    SELECT DISTINCT neleccion 
    FROM dtload ORDER BY neleccion
    ;

/*Cargar tblSexo*/
INSERT INTO tblSexo(detalle)
    SELECT DISTINCT sexo 
    FROM dtload ORDER BY sexo
    ;
    
 /*Cargar tblRaza*/
INSERT INTO tblRaza(nombre)
    SELECT DISTINCT raza 
    FROM dtload ORDER BY raza
    ;

/*Cargar tblPartido*/
INSERT INTO tblPartido(siglas, nombre)
    SELECT DISTINCT spartido, npartido 
    FROM dtload ORDER BY npartido;
    ;

/*Cargar paises*/
INSERT INTO tblPais(nombre)
    SELECT DISTINCT pais 
    FROM dtload ORDER BY pais
    ;
    
/*Cargar Regiones de pais*/
INSERT INTO tblRegion(idpais, nombre)
    SELECT DISTINCT p.idpais, dtl.REGION
        FROM dtload  dtl
            JOIN tblPais p ON dtl.pais = p.nombre
        ORDER BY p.idpais, dtl.REGION
        ;

/*Cargar Deptos x Region*/
INSERT INTO tblDepartamento(idregion, idpais, nombre)
    SELECT DISTINCT r.idregion, p.idpais, dtl.DEPTO
        FROM dtload dtl
            JOIN tblRegion r ON dtl.region = r.nombre
            JOIN tblPais p ON r.idpais = p.idpais AND dtl.pais=p.nombre
            ORDER BY p.idpais, r.idregion, dtl.DEPTO
            ;
            
/*Cargar Municipios x Deptos*/
INSERT INTO tblMunicipio(idregion, idpais, iddepartamento, nombre)
    SELECT DISTINCT r.idregion, p.idpais, d.iddepartamento, dtl.MUNICIPIO
        FROM dtload dtl
            JOIN tblRegion r ON dtl.region = r.nombre
            JOIN tblPais p ON r.idpais = p.idpais AND dtl.pais=p.nombre
            JOIN tbldepartamento d ON d.idpais = p.idpais AND d.idregion = r.idregion AND dtl.DEPTO=d.nombre
            ORDER BY P.idpais, r.idregion, d.iddepartamento, dtl.MUNICIPIO
            ;
            
 /*Carga Datos Generales*/
 INSERT INTO tblPoblacion(anio, analfabetos, primaria, nivelmedio, universitario, idsexo, idraza, idteleccion, idpartido, idmunicipio, iddepartamento, idregion, idpais)
 
 SELECT dtl.anio, dtl.analfabetos, dtl.primaria, dtl.nmedio, dtl.univer, s.idsexo, rs.idraza, te.idteleccion, np.idpartido, m.idmunicipio, d.iddepartamento, r.idregion, p.idpais
        FROM dtload dtl
            JOIN tblRegion r ON dtl.region = r.nombre
            JOIN tblPais p ON r.idpais = p.idpais AND dtl.pais=p.nombre
            JOIN tblDepartamento d ON d.idpais = p.idpais AND d.idregion = r.idregion AND dtl.DEPTO=d.nombre
            JOIN tblMunicipio m ON m.iddepartamento = d.iddepartamento AND m.idregion = r.idregion AND m.idpais = p.idpais AND dtl.MUNICIPIO = m.nombre
            
            JOIN tblSexo s ON s.detalle = dtl.sexo
            JOIN tblRaza rs ON rs.nombre = dtl.raza
            JOIN tblTEleccion te ON te.nombre = dtl.neleccion
            JOIN tblPartido np ON np.siglas = dtl.spartido
            
            ORDER BY P.idpais, r.idregion, d.iddepartamento, dtl.MUNICIPIO
            ;
 
