delimiter //

DROP PROCEDURE IF EXISTS eliminar_espectaculo //

CREATE PROCEDURE eliminar_espectaculo(IN nombre_espectaculo_in varchar(30),IN anho_in INT)

BEGIN

    DELETE FROM Espectaculo 
    WHERE Espectaculo.nombre=nombre_espectaculo_in AND Espectaculo.anho=anho_in;

END//
delimiter ;
        
