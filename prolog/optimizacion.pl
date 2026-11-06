% Modulo 3: optimizacion y ordenamiento de rutas

% Suma de precios con acumulador
costo_ruta(Ruta, Costo) :-
    costo_ruta(Ruta, 0, Costo).

costo_ruta([], Acc, Acc).
costo_ruta([C|Resto], Acc, Costo) :-
    vuelo(C, _, _, _, _, Precio, _),
    Acc1 is Acc + Precio,
    costo_ruta(Resto, Acc1, Costo).

% Llegada del ultimo vuelo menos salida del primero (incluye esperas)
tiempo_ruta([Primero|Resto], Tiempo) :-
    vuelo(Primero, _, _, Salida, _, _, _),
    last([Primero|Resto], Ultimo),
    vuelo(Ultimo, _, _, _, Llegada, _, _),
    Tiempo is Llegada - Salida.
