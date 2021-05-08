\. create.sql
\. crear_espectaculo.sql
\. eliminar_espectaculo.sql
insert Recintos values("recinto1","localizacion","estadio",100);

insert Localidades values("a123","libre","goma","buena");
insert Localidades values("a321","ocupada","goma","mala");
insert Localidades values("a223","libre","goma","buena");
insert Localidades values("a233","libre","goma","buena");

call crear_espectaculo("elFabas",2021,"musical","descripcion",21,"propietario","recinto1","localizacion","grada1,grada2",
    "a123,a321;a223,a233","Adulto,Infantil","22,23.23;24.24,25.25");

/*call eliminar_espectaculo("elFabas",2021);