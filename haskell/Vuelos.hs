module Vuelos where

import Data.Char (isSpace, toLower)
import Data.List (dropWhileEnd, nub, sort)

type Ciudad = String
type Dia = String

data Vuelo = Vuelo { 
    origen  :: Ciudad
  , destino :: Ciudad
  , salida  :: Int
  , llegada :: Int
  , precio  :: Int
  , codigo  :: String
  , dias    :: [Dia]
  } deriving (Show, Eq)

type Grafo = [(Ciudad, [Vuelo])]

separar :: Char -> String -> [String]
separar c s = case break (== c) s of
  (antes, [])        -> [antes]
  (antes, _ : resto) -> antes : separar c resto

recortar :: String -> String
recortar = dropWhileEnd isSpace . dropWhile isSpace

horaAMin :: String -> Int
horaAMin h = case separar ':' h of
  [hh, mm] -> read hh * 60 + read mm
  _        -> error ("Hora invalida: " ++ h)

minAHora :: Int -> String
minAHora m = dosDigitos (m `div` 60) ++ ":" ++ dosDigitos (m `mod` 60)
  where dosDigitos n = (if n < 10 then "0" else "") ++ show n