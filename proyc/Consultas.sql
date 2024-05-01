USE dbproyc;

/*SELECT 1: Desplegar para cada elección el país y el partido político que obtuvo mayor 
            porcentaje de votos en su país. Debe desplegar el nombre de la elección, 
            el año de la elección, el país, el nombre del partido político y 
            el porcentaje que obtuvo de votos en su país*/
            
            
SELECT e.nombre AS Eleccion, b.anio As año, c.nombre AS Pais, p.nombre AS Partido, (b.analfabetos + b.primaria + b.nivelmedio + b.universitario) AS total_votos
FROM tblteleccion e
left JOIN tblpoblacion b ON b.idteleccion = e.idteleccion 
INNER JOIN tblpais c ON b.idpais = c.idpais
INNER JOIN tblpartido p ON b.idpartido = p.idpartido
GROUP BY c.nombre
HAVING MAX(b.analfabetos + b.primaria + b.nivelmedio + b.universitario)
;

            
/*SELECT 2: Desplegar total de votos y porcentaje de votos de mujeres por departamento 
            y país. El ciento por ciento es el total de votos de mujeres por país. 
            (Tip: Todos los porcentajes por departamento de un país deben sumar el 100%)*/    
       /*select * from tblpoblacion */     
            
SELECT c.nombre, d.nombre,
SUM(votos_mujeres) AS total_votos_mujeres_departamento,
SUM(votos_mujeres) * 100.0 / total_votos_pais AS porcentaje_votos_mujeres_pais
FROM (
    SELECT 
        idsexo as idsexo_,
        idpais as idpais_,
        iddepartamento as iddepartamento_,
        SUM((analfabetos+ primaria+ nivelmedio+ universitario)) AS votos_mujeres,
        (SELECT SUM((analfabetos + primaria + nivelmedio + universitario)) FROM tblpoblacion WHERE idpais = b.idpais and idsexo = 1) AS total_votos_pais
    FROM 
        tblpoblacion AS b
        WHERE b.idsexo = 1
        GROUP BY 
        idpais, iddepartamento
) AS subquery 
INNER JOIN tblpais c ON idpais_ = c.idpais
INNER JOIN tbldepartamento d ON iddepartamento_ = d.iddepartamento
GROUP BY c.nombre, d.nombre 
            
/*SELECT 3: Desplegar el nombre del país, nombre del partido político y número de alcaldías 
            de los partidos políticos que ganaron más alcaldías por país.*/ 
            
SELECT c.nombre AS Pais, p.nombre As Partido_Politico, b.idmunicipio
FROM tblpais c
INNER JOIN tblpoblacion b ON c.idpais = b.idpais
INNER JOIN tblpartido p ON b.idpartido = p.idpartido
GROUP BY c.nombre
HAVING MAX(b.analfabetos + b.primaria + b.nivelmedio + b.universitario)
;


/*SELECT 4: Desplegar todas las regiones por país en las que predomina la raza indígena. 
            Es decir, hay más votos que las otras razas.*/  
            
SELECT * FROM tblpoblacion;

SELECT r.nombre As Region, c.nombre As Pais, z.nombre As Raza, (b.analfabetos + b.primaria + b.nivelmedio + b.universitario) As Total_Votos
FROM tblregion r
INNER JOIN tblpais c ON r.idpais = c.idpais
INNER JOIN tblpoblacion b ON c.idpais = b.idpais 
INNER JOIN tblraza z ON b.idraza  = z.idraza 
WHERE (z.idraza = 2)
GROUP BY r.nombre
HAVING SUM(b.analfabetos + b.primaria + b.nivelmedio + b.universitario) > (SELECT SUM(b.analfabetos + b.primaria + b.nivelmedio + b.universitario))
;


            
/*SELECT 5: Desplegar el porcentaje de mujeres universitarias y hombres universitarios 
            que votaron por departamento, donde las mujeres universitarias que votaron 
            fueron más que los hombres universitarios que votaron.*/  

SELECT d.nombre,
SUM(total_votos_mujeres) AS total_votos_mujeres_departamento,
SUM(total_votos_mujeres) * 100.0 / total_votos_departamento AS porcentaje_votos_mujeres_departamento,
SUM(total_votos_hombres) AS total_votos_hombres_departamento,
SUM(total_votos_hombres) * 100.0 / total_votos_departamento AS porcentaje_votos_hombres_departamento
FROM (
    SELECT 
        idsexo as idsexo_,
        idpais as idpais_,
        iddepartamento as iddepartamento_,
        SUM((analfabetos+ primaria+ nivelmedio+ universitario)) AS total_votos_departamento,
        (SELECT SUM((analfabetos + primaria + nivelmedio + universitario)) FROM tblpoblacion WHERE iddepartamento = b.iddepartamento and idsexo = 1) AS total_votos_mujeres,
        (SELECT SUM((analfabetos + primaria + nivelmedio + universitario)) FROM tblpoblacion WHERE iddepartamento = b.iddepartamento and idsexo = 2) AS total_votos_hombres
    FROM 
        tblpoblacion AS b
        GROUP BY idpais_, iddepartamento_
) AS subquery 
INNER JOIN tblpais c ON idpais_ = c.idpais
INNER JOIN tbldepartamento d ON iddepartamento_ = d.iddepartamento
GROUP BY c.nombre, d.nombre 
HAVING porcentaje_votos_mujeres_departamento > porcentaje_votos_hombres_departamento



/*SELECT 6: Desplegar el nombre del país, la región y el promedio de votos por departamento. 
            Por ejemplo: si la región tiene tres departamentos, se debe sumar todos los 
            votos de la región y dividirlo dentro de tres (número de departamentos de la región).*/   

SELECT c.nombre, r.nombre, (Total_votos)/Cantidad_Regiones As Promedio_Votos
FROM (
    SELECT  
        idregion As idregion_,
        idpais As idpais_,
        SUM(analfabetos + primaria + nivelmedio + universitario) As Total_votos,
        (SELECT COUNT(nombre) FROM tbldepartamento GROUP BY idregion_) As Cantidad_Regiones
    FROM 
        tblpoblacion As b
        GROUP BY idpais_, idregion_
)As subquery
INNER JOIN tblpais c ON idpais_ = c.idpais
INNER JOIN tblregion r ON idregion_ = r.idregion
GROUP BY idpais_, idregion_

/*SELECT 7: Desplegar el nombre del país y el porcentaje de votos por raza.*/  

SELECT p.nombre, r.nombre, 

    ROUND((sum(po.analfabetos)*100)
    /
    (SELECT SUM(analfabetos)
        FROM tblPoblacion
        WHERE idpais=po.idpais),2)
    as PORCENTAJE
    
    FROM tblPais p
        JOIN tblPoblacion po ON po.idpais = p.idpais
        JOIN tblRaza r ON r.idraza = po.idraza
        
    GROUP BY po.idpais, po.idraza
    ORDER BY p.idpais, po.idraza
    ;

/*SELECT 8: Desplegar el nombre del país en el cual las elecciones han sido más peleadas.
            Para determinar esto se debe calcular la diferencia de porcentajes de votos
            entre el partido que obtuvo más votos y el partido que obtuvo menos votos*/            

SELECT c.nombre, MAX(Diferencia_Votos) As Eleccion_Mas_Peleadas
FROM (
    SELECT 
    idpais as idpais_,
    iddepartamento  as iddepartamento_,
    MAX(analfabetos + primaria + nivelmedio + universitario), MIN(analfabetos + primaria + nivelmedio + universitario), (MAX(analfabetos + primaria + nivelmedio + universitario) - MIN(analfabetos + primaria + nivelmedio + universitario)) As Diferencia_Votos 
    FROM 
    tblpoblacion As b
) AS querys
INNER JOIN tblpais c ON idpais_ = c.idpais 
INNER JOIN tbldepartamento d ON iddepartamento_ = d.iddepartamento
GROUP BY c.nombre, d.nombre
                
/*SELECT 9: Desplegar el nombre del país, el porcentaje de votos de ese país en el que 
            han votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre de país,
            el de mayor porcentaje).*/   

SELECT c.nombre As Pais,b.analfabetos As Analfabetos, ((b.analfabetos + b.primaria + b.nivelmedio + b.universitario) / COUNT(b.analfabetos + b.primaria + b.nivelmedio + b.universitario)) * 100  As Porcentaje_Votos
FROM tblregion r
INNER JOIN tblpais c ON r.idpais = c.idpais
INNER JOIN tblpoblacion b ON c.idpais = b.idpais 
GROUP BY c.nombre
HAVING MAX(b.analfabetos)
;

/*SELECT 10: Desplegar la lista de departamentos de Guatemala y número de votos obtenidos, 
             para los departamentos que obtuvieron más votos que el departamento de Guatemala.*/   
             
SELECT p.nombre, d.nombre, (SUM(po.analfabetos+po.primaria+po.nivelmedio+po.universitario)) as TVotos
FROM tblDepartamento d
JOIN tblPoblacion po ON po.iddepartamento = d.iddepartamento
JOIN tblPais p ON p.idpais = po.idpais
WHERE (d.idpais = 3) 
GROUP BY po.idpais, po.iddepartamento
HAVING SUM(po.analfabetos+po.primaria+po.nivelmedio+po.universitario) > (SELECT SUM(analfabetos+primaria+nivelmedio+universitario)
                                                                             FROM tblPoblacion WHERE (idpais=3 AND iddepartamento=20))
    ORDER BY TVotos DESC
;