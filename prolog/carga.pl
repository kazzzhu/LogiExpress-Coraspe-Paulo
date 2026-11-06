% Modulo 1: carga dinamica y consultas basicas

% Tiempo: HH:MM <-> minutos desde las 00:00

hora_a_min(Hora, Min) :-
    split_string(Hora, ":", " ", [HS, MS]),
    number_string(H, HS),
    number_string(M, MS),
    Min is H * 60 + M.

min_a_hora(Min, Hora) :-
    H is Min // 60,
    M is Min mod 60,
    format(string(Hora), "~|~`0t~d~2+:~|~`0t~d~2+", [H, M]).

% Dias de operacion: "Diario" o "L-M-Mi" -> [l, m, mi]

dias("Diario", [l, m, mi, j, v, s, d]) :- !.
dias(Texto, Dias) :-
    split_string(Texto, "-", " ", Partes),
    maplist(dia_atomo, Partes, Dias).

dia_atomo(Texto, Dia) :-
    string_lower(Texto, Minusculas),
    atom_string(Dia, Minusculas).

% Lectura de vuelos.txt hacia la base de conocimientos

% vuelo(Codigo, Origen, Destino, SalidaMin, LlegadaMin, Precio, Dias)
:- dynamic vuelo/7.

cargar_vuelos(Archivo) :-
    retractall(vuelo(_, _, _, _, _, _, _)),
    read_file_to_string(Archivo, Texto, []),
    split_string(Texto, "\n", "\r ", Lineas),
    exclude(==(""), Lineas, NoVacias),
    maplist(guardar_vuelo, NoVacias).

guardar_vuelo(Linea) :-
    split_string(Linea, "|", " ", [O, D, S, L, P, C, Ds]),
    atom_string(Origen, O),
    atom_string(Destino, D),
    hora_a_min(S, Salida),
    hora_a_min(L, Llegada),
    number_string(Precio, P),
    atom_string(Codigo, C),
    dias(Ds, Dias),
    !,
    assertz(vuelo(Codigo, Origen, Destino, Salida, Llegada, Precio, Dias)).
guardar_vuelo(Linea) :-
    format("Linea ignorada (formato invalido): ~w~n", [Linea]).

% Tiempo Minimo de Conexion (minutos)

:- dynamic tmc/1.

tmc(45).

fijar_tmc(T) :-
    integer(T),
    T >= 0,
    retractall(tmc(_)),
    assertz(tmc(T)).

% Consultas por ciudad

salidas(Ciudad, Codigos) :-
    findall(C, vuelo(C, Ciudad, _, _, _, _, _), Codigos).

llegadas(Ciudad, Codigos) :-
    findall(C, vuelo(C, _, Ciudad, _, _, _, _), Codigos).

ciudad(C) :- vuelo(_, C, _, _, _, _, _).
ciudad(C) :- vuelo(_, _, C, _, _, _, _).

ciudades(Lista) :-
    setof(C, ciudad(C), Lista).
