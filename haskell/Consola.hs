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