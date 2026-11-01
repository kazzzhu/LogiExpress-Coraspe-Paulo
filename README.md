# LogiExpress - Motor de rutas de vuelos

Proyecto 1 de Tópicos Especiales de Programación (UCAB).
El programa lee los vuelos de `vuelos.txt` y busca las rutas entre dos ciudades para un día de la semana, respetando los días de operación, el tiempo mínimo de conexión entre escalas y sin repetir ciudades. También saca la ruta más barata, la más rápida y un reporte de rutas ordenado.

Integrantes: Ricardo Coraspe y Paulo Troncone.

## Requisitos

- SWI-Prolog 9 o superior
- GHC 9 o superior (solo se usa la librería base, no hace falta cabal ni stack)

## Cómo ejecutarlo

### Prolog

Desde la raíz del repo:

```
swipl prolog/main.pl
```

y dentro de Prolog:

```
?- iniciar.
```

Para correr las pruebas:

```
swipl -g run_tests -t halt prolog/pruebas.pl
```

### Haskell

```
cd haskell
runghc Main.hs
```

En los dos casos se abre un menú donde se puede cambiar el TMC (por defecto 45 minutos), ver los vuelos que salen o llegan a una ciudad, buscar rutas y ver la más barata o la más rápida. Las ciudades se escriben normal, por ejemplo `Pto Ordaz`, y el día como `lunes`, `martes`, etc.

## Archivos

```
vuelos.txt              datos de los vuelos
prolog/
  carga.pl              lectura del archivo, horas, TMC y consultas por ciudad
  rutas.pl              búsqueda de rutas
  optimizacion.pl       costo, tiempo, mergesort, más barata y más rápida
  consola.pl            lectura de datos y forma de mostrar los resultados
  main.pl               menú (predicado iniciar)
  pruebas.pl            pruebas
haskell/
  Vuelos.hs             tipo Vuelo, lectura del archivo y consultas por ciudad
  Rutas.hs              búsqueda de rutas
  Optimizacion.hs       costo, tiempo, mergesort, más barata y más rápida
  Consola.hs            lectura de datos y forma de mostrar los resultados
  Main.hs               menú
docs/                   informe en PDF
```
