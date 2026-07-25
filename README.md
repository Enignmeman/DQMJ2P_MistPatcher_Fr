## To use:

1.) Create the `library/` directory. Download JSZip to `library/`. I used https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js

2.) Download the ndstool source from https://github.com/devkitpro/ndstool and put it into the ndstool folder. wasm_shim.cpp needs to be with all of the other source files

3.) Install emscripten to compile WASM https://emscripten.org/docs/getting_started/downloads.html

4.) After installing emscripten, run `build_wasm.sh`

5.) Run the page using an HTTP server. I use python's built-in option most of the time. `python -m http.server -b 127.0.0.1`

6.) ???

## The server

It's kinda braindead. I use archiver.sh to create the files. I serve them with an nginx configured like this:

```
	root /var/www/mist;

	location = /version {
		default_type text/plain;
		add_header Cache-Control "no-store" always;
	}

	location ^~ /archive/ {
		add_header Cache-Control "public, max-age=31536000, immutable" always;
	}

	location / {
		index index.html;
		try_files $uri $uri/ =404;
		add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0" always;
		add_header Pragma "no-cache" always;
		add_header Expires 0 always;
	}
```

This just makes the archive files cached on the client and all other files fall through normally.
