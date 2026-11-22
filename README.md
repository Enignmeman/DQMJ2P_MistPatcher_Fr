# README Français
> Ce dépôt est un fork de https://github.com/CerisWhite/DQMJ2P_MistPatcher, modifié pour appliquer la traduction française pour DQMJ2Pro au lieu de la trad anglaise, avec une interface en français

## Utilisation:

1.) Téléchargez JSZip et mettez-le dans `library/`. Utilisez https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js

2.) Téléchargez le code source de ndstool depuis https://github.com/devkitpro/ndstool et mettez-le dans le dossier `ndstool/`. `wasm_shim.cpp` doit être avec les autres fichiers de ce code source.

3.) Installez emscripten (servira à compiler WASM): https://emscripten.org/docs/getting_started/downloads.html

4.) Après l'installation de emscripten, lancez `build_wasm.sh`

5.) Faites fonctionner la page via un serveur HTTP. (L'option intégrée de Python fonctionne pour tester localement: `python -m http.server -b 127.0.0.1`)


## Notes

- Ce patcheur est prévu à la base pour la traduction anglaise actuelle, qui a plus de fonctionalités pratiques que la traduction française actuelle.

- Actuellement, la bannière custom de la trad anglaise est celle qui est appliquée, au lieu de celle de la trad française.

- Contrairement à la version de CerisWhite, il n'y a pas de site web public disponible actuellement indiqué dans la description du dépot.

- Le délai pour le script `archiver.sh` ayant pour but de vérifier les MàJ du dépot de la traduction française est à une vérification toutes les 24h.

## The server

It's kinda braindead. I use archiver.sh to create the files. I serve them with nginx configured like this:

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
