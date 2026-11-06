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
