module Rutas where

import Data.Maybe (fromMaybe)
import Vuelos

operaEn :: Dia -> Vuelo -> Bool
operaEn d v = d `elem` dias v

conecta :: Int -> Vuelo -> Vuelo -> Bool
conecta tmc anterior siguiente = salida siguiente >= llegada anterior + tmc

vecinos :: Grafo -> Ciudad -> [Vuelo]
vecinos g c = fromMaybe [] (lookup c g)

rutas :: Grafo -> Int -> Dia -> Maybe Int -> Ciudad -> Ciudad -> [[Vuelo]]
rutas g tmc dia k o d = buscar o [o] Nothing (fromMaybe maxBound k)
  where
    buscar actual visitados previo escalas =
      [ [v] | v <- candidatos actual previo, destino v == d ] ++
      [ v : resto
      | escalas > 0
      , v <- candidatos actual previo
      , destino v /= d
      , destino v `notElem` visitados
      , resto <- buscar (destino v) (destino v : visitados) (Just v) (escalas - 1)
      ]

    candidatos c previo = (filter (respetaTmc previo) . filter (operaEn dia)) (vecinos g c)

    respetaTmc Nothing _  = True
    respetaTmc (Just p) v = conecta tmc p v