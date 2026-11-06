% Modulo 2: busqueda de rutas validas (DFS con backtracking)

% El primer vuelo no tiene escala previa; los demas deben salir
% al menos TMC minutos despues de la llegada del vuelo anterior.
conecta(inicio, _).
conecta(Llegada, Salida) :-
    number(Llegada),
    tmc(T),
    Salida >= Llegada + T.

% camino(Origen, Destino, Dia, K, Visitados, LlegadaPrevia, Ruta)
% Ruta es la lista de codigos de vuelo; K son las escalas que quedan.

% Caso base: vuelo directo al destino
camino(Origen, Destino, Dia, _, _, Previa, [C]) :-
    vuelo(C, Origen, Destino, Salida, _, _, Dias),
    memberchk(Dia, Dias),
    conecta(Previa, Salida).

% Caso recursivo: escala en una ciudad no visitada
camino(Origen, Destino, Dia, K, Visitados, Previa, [C|Resto]) :-
    K > 0,
    vuelo(C, Origen, Escala, Salida, Llegada, _, Dias),
    Escala \== Destino,
    \+ memberchk(Escala, Visitados),
    memberchk(Dia, Dias),
    conecta(Previa, Salida),
    K1 is K - 1,
    camino(Escala, Destino, Dia, K1, [Escala|Visitados], Llegada, Resto).

ruta(Origen, Destino, Dia, K, Ruta) :-
    camino(Origen, Destino, Dia, K, [Origen], inicio, Ruta).

rutas(Origen, Destino, Dia, K, Rutas) :-
    findall(R, ruta(Origen, Destino, Dia, K, R), Rutas).

% Sin limite de escalas: como no se repiten ciudades, nunca hay
% mas de (numero de ciudades - 1) escalas.
sin_limite(K) :-
    ciudades(Cs),
    length(Cs, N),
    K is N - 1.
