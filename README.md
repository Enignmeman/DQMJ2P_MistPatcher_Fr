To use:
1.) Create the `library/` directory. Download JSZip to `library/`. I used https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js
2.) Install emscripten to compile WASM https://emscripten.org/docs/getting_started/downloads.html
3.) After installing emscripten, run build_wasm.sh
4.) Run the page using an HTTP server. I use python's built-in option most of the time. `python -m http.server -b 127.0.0.1`
5.) ???
