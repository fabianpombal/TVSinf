DROP TRIGGER IF EXISTS trigger_eliminar_espectaculo ;

delimiter //
CREATE TRIGGER trigger_eliminar_espectaculo BEFORE DELETE ON Espectaculo FOR EACH ROW
BEGIN
    
    
    
    DELETE se_agrupa_en,se_celebra_en,tiene FROM se_agrupa_en
        INNER JOIN se_celebra_en
            ON se_celebra_en.nombre_espectaculo=old.nombre        
        INNER JOIN tiene
            ON tiene.nombre_recinto=se_celebra_en.nombre_recinto
        WHERE tiene.nombre_grada=se_agrupa_en.nombre_grada;

    
    DELETE Gradas,se_celebra_en,tiene FROM Gradas  
        INNER JOIN se_celebra_en
            ON se_celebra_en.nombre_espectaculo=old.nombre
        INNER JOIN tiene 
            ON tiene.nombre_recinto=se_celebra_en.nombre_recinto;

    DELETE tiene, se_celebra_en FROM tiene 
        INNER JOIN se_celebra_en
            ON se_celebra_en.nombre_espectaculo=old.nombre AND se_celebra_en.anho=old.anho
        WHERE tiene.nombre_recinto=se_celebra_en.nombre_recinto ;
        
    DELETE FROM Precios WHERE Precios.nombre_espectaculo=old.nombre AND Precios.anho=old.anho;

    DELETE FROM se_celebra_en WHERE se_celebra_en.nombre_espectaculo=old.nombre AND se_celebra_en.anho=old.anho;
END //

delimiter ;