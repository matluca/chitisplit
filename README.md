# Chi Ti Split app

![](assets/icon/icon.png)

This project to help manage and split expenses between friends. The application is developed using
Flutter, and can be made available as phone or web application.

### Build app for Android

For building the app and creating APK releases for Android, go to the project root and run
```
flutter build apk --split-per-abi
```
This produces three APK files and stores them in `./build/app/outputs/apk/release`. In order to
create a fat APK, remove the `--split-per-abi` flag. The right APK for a 64bit device is
`app-arm64-v8a-release.apk`.

See [Build and release an Android app](https://flutter.dev/docs/deployment/android) for further
details.

### Build web app

For building the app for a web version release, go to the project root and run
```
flutter build web
```
This generates all the necessary files in `./build/web`. To test locally, launch a web server.
For example, navigate to `./build/web` and run `python -m http.server 8080`, which makes the web
version available under `localhost:8080`.

See [Build and release a web app](https://flutter.dev/docs/deployment/web) for further
details.

### Deploy to Firebase

The web app is hosted using Firebase hosting. To update it, run
```bash
firebase deploy --only hosting
```
The app will then be available at [https://chi-ti-split.web.app](https://chi-ti-split.web.app) or
[https://chi-ti-split.firebaseapp.com](https://chi-ti-split.firebaseapp.com)
