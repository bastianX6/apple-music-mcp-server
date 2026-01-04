# Hybrid Tool Realistic Smoke Prompts

Prompts orientados a casos de usuario. Cada uno se redacta como intención natural; el LLM debe inferir la herramienta adecuada. Ejecutar en orden y respetar dependencias (por ejemplo, obtener IDs en pasos previos).

## Catalog discovery & lookup (catalog auth)
1) Encuentra la canción “Shape of You – Ed Sheeran” y dime su duración.
2) Dame sugerencias de búsqueda para “tay”.
3) Pide hints de autocompletado para “cold”.
4) Trae el top 5 de canciones en los charts más reproducidos.
5) Lista los géneros disponibles.
6) Busca el álbum “1989 (Taylor’s Version)” y luego trae sus detalles completos (usa el albumId encontrado).
7) Para el artista “Daft Punk”, dame su vista de top songs (limita a 5).
8) Obtén el tracklist de ese álbum (usa el albumId del paso 6; limita a 5 tracks).
9) Busca la estación con id ra.978194965 y confirma su título y descripción.
10) Haz una consulta mixta en una sola llamada usando el songId del paso 1 y el albumId del paso 6.

## Library (requiere Music-User-Token)
11) Lista mis playlists (hasta 5).
12) Lista mis canciones recientes en la librería (hasta 5).
13) Busca en mi librería la canción “Imagine” (hasta 3 resultados).
14) Trae recursos de librería mixtos: usa un librarySongId del paso 12 o 13 y un libraryAlbumId obtenido de recently added o de algún álbum de librería disponible.
15) Trae los tracks de una playlist de librería (usa un playlistId del paso 11 o del playlist que se cree en el paso 24; limita a 5).
16) Verifica ítems agregados recientemente en la librería.

## User history & recommendations (requiere Music-User-Token)
17) ¿Qué escuché recientemente? (limita a 5).
18) Solo pistas recientes (limita a 5 canciones).
19) Estaciones escuchadas recientemente (limita a 5).
20) Pide recomendaciones (top 3) y luego detalla la primera usando su id.
21) Pide los contenidos de esa recomendación (limita a 5 elementos).
22) Pide heavy rotation (limita a 5).
23) Pide los datos de Replay del año más reciente disponible, incluyendo las vistas de top-songs y top-artists.

## Playlist management (requiere Music-User-Token)
24) Crea una playlist llamada “LLM Test Mix” con la descripción “Smoke test playlist”.
25) Añade 2 tracks a esa playlist usando canciones encontradas en las búsquedas de catálogo (por ejemplo, del paso 1).
26) Crea una carpeta de playlists llamada “LLM Folder”.

## Library add/favorites & ratings (requiere Music-User-Token; puede devolver 405)
27) Intenta agregar una canción a la librería (usa el songId del paso 1) y registra el estado devuelto.
28) Intenta marcar esa canción como favorita y registra el estado devuelto.
29) Marca like a esa canción y luego elimina el like.

## Utility
30) Obtén el storefront del usuario (útil para cachear en llamadas de catálogo).
31) Obtén la mejor etiqueta de idioma dada la storefront US y Accept-Language es-ES.

## Escape hatch
32) Como fallback, ejecuta una búsqueda en catálogo US de “radiohead” (songs, limit 3) para confirmar conectividad básica.
