delimiter //

DROP PROCEDURE IF EXISTS crear_espectaculo //

CREATE PROCEDURE crear_espectaculo (IN nombre_esp varchar(30),IN anho_esp INT,in fecha_in datetime,IN tipo_esp_in varchar(10),IN descripcion_esp varchar(100),
    IN duracion_esp INT, IN propietario_esp varchar(30),IN nombre_rec varchar(30), IN localizacion_rec varchar(100),
    IN lista_gradas MEDIUMTEXT,IN lista_localidades MEDIUMTEXT,IN lista_espectadores MEDIUMTEXT, IN lista_precios MEDIUMTEXT)

BEGIN

DECLARE grada_aux TEXT;
DECLARE bloque_espectadores_aux TEXT;
DECLARE bloque_precios TEXT;
DECLARE long_grada INT;
DECLARE long_precios INT;
DECLARE nombre_grada_aux varchar(10);
DECLARE bloque_precios_aux TEXT;
DECLARE precio_espectador TEXT;
DECLARE tipo_esp TEXT;
DECLARE tipo_esp_aux TEXT;
DECLARE precio_espectador_aux TEXT;
DECLARE long_precio_espectador INT;
DECLARE long_tipo_esp INT; 
DECLARE bloque_localidades MEDIUMTEXT;
DECLARE bloque_localidades_aux MEDIUMTEXT;
DECLARE long_localidades INT;
DECLARE localidad MEDIUMTEXT;
DECLARE long_localidad_aux INT;
DECLARE localidad_aux varchar(5);

INSERT INTO Espectaculo VALUES(nombre_esp,anho_esp,descripcion_esp,tipo_esp_in,fecha_in,duracion_esp,propietario_esp);
INSERT INTO se_celebra_en VALUES(nombre_rec,localizacion_rec,nombre_esp,anho_esp,fecha_in);


iterator:
LOOP

    IF LENGTH(TRIM(lista_gradas)) = 0 OR lista_gradas IS NULL THEN
        LEAVE iterator;
    END IF;

    SET grada_aux = SUBSTRING_INDEX(lista_gradas,',',1);
    SET bloque_precios = SUBSTRING_INDEX(lista_precios,';',1);
    SET bloque_localidades = SUBSTRING_INDEX(lista_localidades,';',1);

    SET long_grada=LENGTH(grada_aux);
    SET long_precios= LENGTH(bloque_precios);
    SET long_localidades=LENGTH(bloque_localidades);

    SET nombre_grada_aux=TRIM(grada_aux);
    SET bloque_precios_aux=TRIM(bloque_precios);
    SET bloque_localidades_aux=TRIM(bloque_localidades);
   
    INSERT Gradas(nombre,num_max_localidades) VALUES(nombre_grada_aux,10);
    INSERT tiene(nombre_recinto,nombre_grada) VALUES(nombre_rec,nombre_grada_aux);


    SET bloque_espectadores_aux=lista_espectadores;
    
    iterator2:
    LOOP

        IF LENGTH(TRIM(bloque_precios_aux))=0 OR bloque_precios_aux IS NULL THEN   
            LEAVE iterator2;
        END IF;

        SET tipo_esp=SUBSTRING_INDEX(bloque_espectadores_aux,',',1);
        SET precio_espectador=SUBSTRING_INDEX(bloque_precios_aux,',',1);
       

        SET long_tipo_esp = LENGTH (tipo_esp);
        SET long_precio_espectador=LENGTH(precio_espectador);
        

        SET tipo_esp_aux= TRIM(tipo_esp);
        SET precio_espectador_aux = TRIM(precio_espectador);
       

        INSERT Precios (precio,tipo_espectador,nombre_espectaculo,anho,nombre_grada) VALUES (precio_espectador_aux,tipo_esp_aux,nombre_esp,anho_esp,nombre_grada_aux);

        SET bloque_espectadores_aux = INSERT(bloque_espectadores_aux,1,long_tipo_esp+1,'');
        SET bloque_precios_aux=INSERT(bloque_precios_aux,1,long_precio_espectador+1,'');

    END LOOP;

    iterator3: 
    LOOP
        IF LENGTH(TRIM(bloque_localidades_aux))=0 OR bloque_localidades_aux IS NULL THEN
            LEAVE iterator3;
        END IF;
         
        SET localidad=SUBSTRING_INDEX(bloque_localidades_aux,',',1);
        SET long_localidad_aux=LENGTH(localidad);
        SET localidad_aux=TRIM(localidad);

        INSERT se_agrupa_en(numero_localidad,nombre_grada) VALUES(localidad_aux,nombre_grada_aux);
    
        SET bloque_localidades_aux=INSERT(bloque_localidades_aux,1,long_localidad_aux+1,'');

    END LOOP;

    SET lista_gradas = INSERT(lista_gradas,1,long_grada+1,'');
    SET lista_precios=INSERT(lista_precios,1,long_precios+1,'');
    SET lista_localidades=INSERT (lista_localidades,1,long_localidades+1,'');

END LOOP;

END //

delimiter ;