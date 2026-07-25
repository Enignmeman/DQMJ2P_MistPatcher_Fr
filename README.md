## To use:

1.) Create the `library/` directory. Download JSZip to `library/`. I used https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js

2.) Download the ndstool source from https://github.com/devkitpro/ndstool and put it into the ndstool folder. wasm_shim.cpp needs to be with all of the other source files

3.) Install emscripten to compile WASM https://emscripten.org/docs/getting_started/downloads.html

4.) After installing emscripten, run `build_wasm.sh`

5.) Run the page using an HTTP server. I use python's built-in option most of the time. `python -m http.server -b 127.0.0.1`

6.) ???
