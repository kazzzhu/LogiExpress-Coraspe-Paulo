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