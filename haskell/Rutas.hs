module Rutas where

import Data.Maybe (fromMaybe)
import Vuelos

operaEn :: Dia -> Vuelo -> Bool
operaEn d v = d `elem` dias v

conecta :: Int -> Vuelo -> Vuelo -> Bool
conecta tmc anterior siguiente = salida siguiente >= llegada anterior + tmc

vecinos :: Grafo -> Ciudad -> [Vuelo]
vecinos g c = fromMaybe [] (lookup c g)