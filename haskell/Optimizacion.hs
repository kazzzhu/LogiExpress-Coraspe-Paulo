module Optimizacion where

import Vuelos

data Criterio = Costo | Tiempo deriving (Show, Eq)

costoRuta :: [Vuelo] -> Int
costoRuta = foldr ((+) . precio) 0

tiempoRuta :: [Vuelo] -> Int
tiempoRuta [] = 0
tiempoRuta r  = llegada (last r) - salida (head r)

medida :: Criterio -> [Vuelo] -> Int
medida Costo  = costoRuta
medida Tiempo = tiempoRuta