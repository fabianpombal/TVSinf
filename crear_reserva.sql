delimiter //

drop procedure if exists crear_reserva//

create procedure crear_reserva(in dni_in varchar(9),in nombre_espectaculo_in varchar(10),in pagada boolean,in nombre_grada_in varchar(10),in lista mediumtext)
/*formato de la lista: numero_localidad, tipo_espectador;numero_localidad, tipo_espectador*/
begin

declare estado_aux varchar(10);
declare precio_aux dec(5.2);
declare a_cobrar dec(5.2);
declare nombre_recinto_aux varchar(20);
declare fecha_aux datetime;
declare estado_previo varchar(10);
declare lista_aux mediumtext;
declare lista_aux_2 mediumtext;

declare _next_localidad text;
declare _next_tipo_espectador text;
declare _next_bloque text;
declare _nextlen text;

declare _next_localidad2 text;
declare _next_tipo_espectador2 text;
declare _next_bloque2 text;
declare _nextlen2 text;

start transaction;

set @instante_actual=now();
set a_cobrar=0.0;

select nombre_recinto 
from se_celebra_en 
where nombre_espectaculo_in=nombre_espectaculo into nombre_recinto_aux; 
select lista into lista_aux;

select fecha from Espectaculo where nombre=nombre_espectaculo_in into fecha_aux;

select nombre_recinto 
from se_celebra_en 
where nombre_espectaculo_in=nombre_espectaculo into nombre_recinto_aux; 
select lista into lista_aux_2;
iterator_estado:

    loop
     
        if length(trim(lista_aux_2))=0 or lista_aux_2 is null then leave iterator_estado;
        end if;

        set _next_bloque2=substring_index(lista_aux_2,';',1);
        set _next_localidad2=substring_index(_next_bloque2,',',1);
        set _next_tipo_espectador2=substring_index(_next_bloque2,',',-1);
        
        set _nextlen2=length(_next_bloque2);

        select _next_localidad2;
        select localidades.estado from localidades where localidades.numero=_next_localidad2 into estado_previo;
        select estado_previo;
        if estado_previo='Libre' then 
            if pagada=true then
                iterator:
                loop
                
                    if length(trim(lista_aux))=0 or lista_aux is null then leave iterator;
                    end if;

                    set _next_bloque=substring_index(lista_aux,';',1);
                    set _next_localidad=substring_index(_next_bloque,',',1);
                    set _next_tipo_espectador=substring_index(_next_bloque,',',-1);
                    
                    set _nextlen=length(_next_bloque);
                    select precios.precio from Precios where nombre_espectaculo=nombre_espectaculo_in
                    and tipo_espectador=_next_tipo_espectador and nombre_grada=nombre_grada_in
                    into precio_aux;

                    set a_cobrar=precio_aux+a_cobrar;

                    set lista_aux=insert(lista_aux,1,_nextlen+1,'');
                    
                end loop;
        
                    select a_cobrar;
                    insert paga VALUES(a_cobrar,dni_in,nombre_grada_in);

                    if now() > fecha_aux - interval 45 minute then
                    select "primer if";
                        insert reserva values(null,@instante_actual,true,dni_in,nombre_espectaculo_in,a_cobrar);
                    else 
                    select "en el else";
                        insert reserva values(null,@instante_actual,false,dni_in,nombre_espectaculo_in,a_cobrar);
                    end if;

                else 
                    if now()>fecha_aux-interval 45 minute then
                        
                        insert reserva values(null,@instante_actual,true,dni_in,nombre_espectaculo_in,0);
                    else 
                    
                        insert reserva values(null,@instante_actual,false,dni_in,nombre_espectaculo_in,0);
                    end if;
                end if;

            iterator2:
            
            loop
           
                if length(trim(lista))=0 or lista is null then
                leave iterator2;
                end if;

        
                set _next_bloque=substring_index(lista_aux,';',1);
                set _next_localidad=substring_index(_next_bloque,',',1);
                set _next_tipo_espectador=substring_index(_next_bloque,',',-1);
                set _nextlen=length(_next_bloque);
                if pagada=true then set estado_aux='Reservada';
                else set estado_aux='Prerreservada';
                end if;

                update Localidades set estado=estado_aux where Localidades.numero=_next_localidad;
                set lista = INSERT(lista,1,_nextlen + 1,'');

                end loop;
        end if;

        set lista_aux_2=insert(lista_aux_2,1,_nextlen2+1,'');

        
    end loop;





commit;
end//


delimiter ;
