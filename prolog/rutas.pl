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
