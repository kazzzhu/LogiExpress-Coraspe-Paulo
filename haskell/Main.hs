module Main where

import Data.Char (toLower)
import System.IO
import Vuelos
import Rutas
import Optimizacion
import Consola

archivo :: FilePath
archivo = "../vuelos.txt"

tmcInicial :: Int
tmcInicial = 45

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  vs <- cargar
  loop vs tmcInicial

cargar :: IO [Vuelo]
cargar = do
  vs <- cargarVuelos archivo
  putStrLn (show (length vs) ++ " vuelos cargados.")
  return vs

mostrarMenu :: IO ()
mostrarMenu = putStr (unlines
  [ ""
  , "========== LogiExpress =========="
  , "1. Recargar vuelos.txt"
  , "2. Configurar TMC"
  , "3. Vuelos que salen de una ciudad"
  , "4. Vuelos que llegan a una ciudad"
  , "5. Rutas validas"
  , "6. Ruta mas barata"
  , "7. Ruta mas rapida"
  , "8. Reporte de rutas ordenado"
  , "0. Salir"
  ])

loop :: [Vuelo] -> Int -> IO ()
loop vs tmc = do
  mostrarMenu
  op <- leer "Opcion: "
  case op of
    "0" -> putStrLn "Hasta luego."
    "1" -> cargar >>= \vs' -> loop vs' tmc
    "2" -> do
      putStrLn ("TMC actual: " ++ show tmc ++ " min")
      t <- leerEntero "Nuevo TMC en minutos: "
      putStrLn ("TMC fijado en " ++ show t ++ " min.")
      loop vs t
    "3" -> do
      c <- leerCiudad vs "Ciudad: "
      putStrLn ("\nVuelos que salen de " ++ c ++ ":")
      mostrarVuelos (salidasDe c vs)
      loop vs tmc
    "4" -> do
      c <- leerCiudad vs "Ciudad: "
      putStrLn ("\nVuelos que llegan a " ++ c ++ ":")
      mostrarVuelos (llegadasA c vs)
      loop vs tmc
    "5" -> do
      (o, d, dia) <- leerConsulta vs
      k <- leerK
      let rs = buscarRutas k o d dia
      putStrLn ("\n" ++ show (length rs) ++ " ruta(s) encontrada(s):")
      mapM_ (uncurry mostrarRuta) (zip [1 ..] rs)
      loop vs tmc
    "6" -> do
      (o, d, dia) <- leerConsulta vs
      mostrarOptima "Ruta mas barata:" (masBarata (buscarRutas Nothing o d dia))
      loop vs tmc
    "7" -> do
      (o, d, dia) <- leerConsulta vs
      mostrarOptima "Ruta mas rapida:" (masRapida (buscarRutas Nothing o d dia))
      loop vs tmc
    "8" -> do
      criterio <- leerCriterio
      (o, d, dia) <- leerConsulta vs
      let rs = reporte criterio (buscarRutas Nothing o d dia)
      putStrLn ("\n" ++ show (length rs) ++ " ruta(s) ordenada(s) por " ++ map toLower (show criterio) ++ ":")
      mapM_ (uncurry mostrarRuta) (zip [1 ..] rs)
      loop vs tmc
    _ -> putStrLn "Opcion no valida." >> loop vs tmc
  where
    buscarRutas k o d dia = rutas (construirGrafo vs) tmc dia k o d