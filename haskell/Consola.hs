module Consola where

import Data.Char (toLower)
import Data.List (intercalate)
import System.Exit (exitSuccess)
import System.IO
import Vuelos
import Optimizacion

rellenar :: Int -> String -> String
rellenar n s = s ++ replicate (n - length s) ' '

mostrarVuelo :: Vuelo -> IO ()
mostrarVuelo v = putStrLn ("  " ++ rellenar 7 (codigo v) ++ rellenar 14 (origen v)
  ++ minAHora (salida v) ++ "  ->  " ++ rellenar 14 (destino v) ++ minAHora (llegada v)
  ++ "  " ++ rellenar 6 (show (precio v)) ++ intercalate "-" (dias v))

mostrarVuelos :: [Vuelo] -> IO ()
mostrarVuelos [] = putStrLn "  (ninguno)"
mostrarVuelos vs = mapM_ mostrarVuelo vs

mostrarRuta :: Int -> [Vuelo] -> IO ()
mostrarRuta i r = do
  putStrLn ("\nRuta " ++ show i ++ " | costo: " ++ show (costoRuta r)
    ++ " | tiempo total: " ++ minAHora (tiempoRuta r) ++ " h | escalas: " ++ show (length r - 1))
  mapM_ mostrarVuelo r

mostrarOptima :: String -> Maybe [Vuelo] -> IO ()
mostrarOptima _ Nothing       = putStrLn "No hay rutas para ese dia."
mostrarOptima titulo (Just r) = putStrLn ("\n" ++ titulo) >> mostrarRuta 1 r

leer :: String -> IO String
leer prompt = do
  putStr prompt
  hFlush stdout
  fin <- isEOF
  if fin then exitSuccess else fmap (unwords . words) getLine

leerEntero :: String -> IO Int
leerEntero prompt = do
  s <- leer prompt
  case reads s of
    [(n, "")] | n >= 0 -> return n
    _ -> putStrLn "Debe ser un entero mayor o igual a 0." >> leerEntero prompt

leerCiudad :: [Vuelo] -> String -> IO Ciudad
leerCiudad vs prompt = do
  s <- leer prompt
  case [c | c <- ciudades vs, map toLower c == map toLower s] of
    (c : _) -> return c
    [] -> do
      putStrLn ("Ciudad no encontrada. Disponibles: " ++ intercalate ", " (ciudades vs))
      leerCiudad vs prompt

nombresDias :: [(String, Dia)]
nombresDias =
  [ ("lunes", "l"), ("martes", "m"), ("miercoles", "mi"), ("miércoles", "mi")
  , ("jueves", "j"), ("viernes", "v"), ("sabado", "s"), ("sábado", "s")
  , ("domingo", "d") ]

leerDia :: IO Dia
leerDia = do
  s <- leer "Dia (lunes ... domingo): "
  case lookup (map toLower s) nombresDias of
    Just d  -> return d
    Nothing -> putStrLn "Dia no valido." >> leerDia

leerK :: IO (Maybe Int)
leerK = do
  s <- leer "Maximo de escalas K (Enter = sin limite): "
  case reads s of
    _ | null s -> return Nothing
    [(n, "")] | n >= 0 -> return (Just n)
    _ -> putStrLn "Debe ser un entero mayor o igual a 0." >> leerK

leerCriterio :: IO Criterio
leerCriterio = do
  s <- leer "Ordenar por (costo/tiempo): "
  case map toLower s of
    "costo"  -> return Costo
    "tiempo" -> return Tiempo
    _        -> putStrLn "Escriba costo o tiempo." >> leerCriterio

leerConsulta :: [Vuelo] -> IO (Ciudad, Ciudad, Dia)
leerConsulta vs = do
  o <- leerCiudad vs "Origen: "
  d <- leerCiudad vs "Destino: "
  dia <- leerDia
  return (o, d, dia)