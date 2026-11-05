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

mergeSortBy :: (a -> Int) -> [a] -> [a]
mergeSortBy _ []  = []
mergeSortBy _ [x] = [x]
mergeSortBy f xs  = mezclar (mergeSortBy f izq) (mergeSortBy f der)
  where
    (izq, der) = splitAt (length xs `div` 2) xs
    mezclar [] ys = ys
    mezclar xs' [] = xs'
    mezclar (a : as') (b : bs)
      | f a <= f b = a : mezclar as' (b : bs)
      | otherwise  = b : mezclar (a : as') bs