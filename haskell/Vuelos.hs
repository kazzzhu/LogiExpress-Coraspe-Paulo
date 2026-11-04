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

todosLosDias :: [Dia]
todosLosDias = ["l", "m", "mi", "j", "v", "s", "d"]

parsearDias :: String -> [Dia]
parsearDias "Diario" = todosLosDias
parsearDias s        = map (map toLower) (separar '-' s)

parsearVuelo :: String -> Maybe Vuelo
parsearVuelo linea = case map recortar (separar '|' linea) of
  [o, d, s, l, p, c, ds] ->
    Just (Vuelo o d (horaAMin s) (horaAMin l) (read p) c (parsearDias ds))
  _ -> Nothing

cargarVuelos :: FilePath -> IO [Vuelo]
cargarVuelos ruta = do
  texto <- readFile ruta
  return [v | Just v <- map parsearVuelo (lines texto)]

construirGrafo :: [Vuelo] -> Grafo
construirGrafo vs = [(c, [v | v <- vs, origen v == c]) | c <- nub (map origen vs)]

ciudades :: [Vuelo] -> [Ciudad]
ciudades vs = sort (nub (map origen vs ++ map destino vs))

salidasDe :: Ciudad -> [Vuelo] -> [Vuelo]
salidasDe c = filter ((== c) . origen)

llegadasA :: Ciudad -> [Vuelo] -> [Vuelo]
llegadasA c = filter ((== c) . destino)