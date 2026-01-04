# Hybrid Tool Realistic Smoke Prompts

Prompts orientados a casos de usuario. Cada uno nombra explícitamente el tool para evitar ambigüedad. Ejecutar en orden, respetando dependencias (por ejemplo, obtener storefront implícito en el primer llamado a catálogo).

## Catalog discovery & lookup (catalog auth)
1) Encuentra la canción “Shape of You – Ed Sheeran” y dime su duración usando `search_catalog` con `{ "term": "Shape of You Ed Sheeran", "types": "songs", "limit": 3 }`.
2) Dame sugerencias de búsqueda para “tay” usando `get_search_suggestions` con `{ "term": "tay", "kinds": "terms" }`.
3) Pide hints para “cold” con `get_search_hints` `{ "term": "cold", "limit": 5 }`.
4) Trae los charts top 5 de canciones usando `get_charts` `{ "types": "songs", "chart": "most-played", "limit": 5 }`.
5) Lista los géneros disponibles con `get_genres` `{}`.
6) Busca el álbum “1989 (Taylor’s Version)” con `search_catalog` `{ "term": "1989 Taylor", "types": "albums", "limit": 2 }` y luego obtén detalles del álbum usando `get_catalog_resource` con el albumId resultante.
7) Para el artista “Daft Punk”, obtén su vista de top songs usando `get_catalog_view` `{ "type": "artists", "id": "<artistId>", "view": "top-songs", "limit": 5 }`.
8) Obtén el tracklist de un álbum usando `get_catalog_relationship` `{ "type": "albums", "id": "<albumId>", "relationship": "tracks", "limit": 5 }`.
9) Busca estaciones con `get_stations` `{ "ids": "ra.978194965" }` y confirma el título y descripción.
10) Usa `get_catalog_multi_by_type_ids` `{ "ids": { "songs": "<songId>", "albums": "<albumId>" } }` para verificar multi-fetch en una llamada.

## Library (requires Music-User-Token)
11) Lista mis playlists (máximo 5) usando `get_library_playlists` `{ "limit": 5 }`.
12) Lista mis canciones recientes en librería usando `get_library_songs` `{ "limit": 5 }`.
13) Busca en mi librería la canción “Imagine” con `library_search` `{ "term": "Imagine", "types": "library-songs", "limit": 3 }`.
14) Obtén recursos de librería mixtos usando `get_library_multi_by_type_ids` `{ "ids": { "library-songs": "<librarySongIdFromStep12Or13>", "library-albums": "<libraryAlbumIdFromStep19OrRecentlyAdded>" } }`.
15) Trae relaciones de una playlist de librería (tracks) con `get_library_relationship` `{ "type": "playlists", "id": "<playlistIdFromStep11Or24>", "relationship": "tracks", "limit": 5 }`.
16) Verifica recently-added con `get_library_recently_added` `{}`.

## User history & recommendations (requires Music-User-Token)
17) ¿Qué escuché recientemente? `get_recently_played` `{ "limit": 5 }`.
18) Solo pistas recientes: `get_recently_played_tracks` `{ "limit": 5, "types": "songs" }`.
19) Estaciones recientes: `get_recently_played_stations` `{ "limit": 5 }`.
20) Pide recomendaciones (top 3) con `get_recommendations` `{ "limit": 3 }`; luego pide el detalle de la primera con `get_recommendation` `{ "id": "<recoId>" }`.
21) Pide la relación de contenidos de esa recomendación con `get_recommendation_relationship` `{ "id": "<recoId>", "relationship": "contents", "limit": 5 }`.
22) Pide heavy rotation con `get_heavy_rotation` `{ "limit": 5 }`.
23) Pide replay data del último año disponible (usa 2025 si no sabes) con `get_replay_data` `{ "filter[year]": "2025", "views": "top-songs" }`.

## Playlist management (requires Music-User-Token)
24) Crea una playlist “LLM Test Mix” con `create_playlist` `{ "name": "LLM Test Mix", "description": "Smoke test playlist" }`.
25) Añade 2 tracks a esa playlist con `add_playlist_tracks` `{ "playlistId": "<newPlaylistId>", "trackIds": "<songId1FromCatalogSearch>,<songId2FromCatalogSearch>" }`.
26) Crea una carpeta de playlists “LLM Folder” con `create_playlist_folder` `{ "name": "LLM Folder" }`.

## Library add/favorites & ratings (requires Music-User-Token; may 405)
27) Intenta agregar una canción a librería con `add_library_resources` `{ "ids": { "songs": "<songId>" } }` y registra el status (202 o 405).
28) Intenta marcar favoritos con `add_favorites` `{ "ids": "<songId>", "resourceType": "songs" }` y registra el status (202 o 405).
29) Marca like a una canción con `set_rating` `{ "resourceType": "songs", "id": "<songId>", "value": 1 }`, luego bórralo con `delete_rating` `{ "resourceType": "songs", "id": "<songId>" }`.

## Utility
30) Obtén el storefront del usuario con `get_user_storefront` `{}` (debe cachéar para siguientes llamadas de catálogo).
31) Obtén la mejor etiqueta de idioma con `get_best_language_tag` `{ "storefront": "us", "acceptLanguage": "es-ES" }`.

## Escape hatch
32) Como fallback, usa `generic_get` `{ "path": "v1/catalog/us/search?term=radiohead&types=songs&limit=3" }` para confirmar conectividad básica.
