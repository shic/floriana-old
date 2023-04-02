# myguide

Generate keystore

/Applications/Android\ Studio.app/Contents/jre/Contents/Home/bin/keytool -genkey -v -keystore ./storeFile.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload


Build
-----

flutter build apk --tree-shake-icons


Canvas 2.8 MB (Not recommended)
flutter build web --web-renderer=canvaskit --release  


Build for web (HTML)

Build for web
-------------
1. ```flutter build web --release --web-renderer=html```
2. ```flutter build apk --flavor prod --tree-shake-icons```
3. ```open /Users/shi/Documents/workspaceMyguide/myguide/build/web/assets/fonts```
4. move ```myguide/build/app/intermediates/merged_assets/devRelease/out/flutter_assets/fonts/MaterialIcons-Regular.otf``` to ```myguide/build/web/assets/fonts```
5. Remove notice.txt 
6. 
6. Remove font
7. ```firebase deploy```



Deploy
-------

firebase deploy



Notes
-----

Defualt Build

2.3 MB 的 main.dart.js；

2.8 MB 的 canvaskit.wasm；

1.5 MB 的 MaterialIcons-Regular.otf；

284 kB 的 CupertinoIcons.ttf。


