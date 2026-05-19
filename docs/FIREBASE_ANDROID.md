# Firebase Android — EDUCLASS

O pacote Android da app é **`com.example.edugestao`** (ver `android/app/build.gradle.kts`).

Os erros `DEVELOPER_ERROR` / `ConnectionResult{statusCode=DEVELOPER_ERROR}` no logcat costumam indicar que o **SHA-1 de debug** (ou release) não está registado no projeto Firebase, ou que falta o ficheiro `google-services.json`.

## 1. Obter SHA-1 (debug)

Na raiz do projecto Flutter:

```powershell
cd android
.\gradlew signingReport
```

Procure a variante **debug** e copie o valor **SHA-1**.

Alternativa (se tiver `keytool` no PATH):

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

## 2. Registar no Firebase Console

1. Abra [Firebase Console](https://console.firebase.google.com/) → o projecto ligado a `lib/firebase_options.dart`.
2. **Definições do projecto** → **As suas apps** → app Android.
3. Confirme que o **nome do pacote** é `com.example.edugestao`.
4. Em **Impressões digitais do certificado SHA**, adicione o SHA-1 de **debug** e, para builds de loja, o SHA-1 de **release**.
5. Guarde e, se pedido, descarregue de novo o `google-services.json`.

## 3. Colocar `google-services.json`

Copie o ficheiro para:

```
android/app/google-services.json
```

Este ficheiro **não deve** ser commitado se o repositório for público (já está referenciado em `.gitignore` quando aplicável). Use o exemplo em `android/app/google-services.json.example`.

## 4. Reconfigurar FlutterFire (opcional)

Se alterar o projecto Firebase ou o package name:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Isto actualiza `lib/firebase_options.dart` e o `google-services.json`.

## 5. Verificar

```bash
flutter clean
flutter pub get
flutter run
```

No log deve aparecer `MAIN: Firebase inicializado com sucesso.` sem `DEVELOPER_ERROR` repetido ao usar Firestore/Auth.

## Notas

- **Windows desktop**: Firebase é ignorado em `main.dart` de propósito.
- **Package name de produção**: antes de publicar na Play Store, altere `applicationId` para o ID definitivo (ex. `ao.edugestao.app`) e repita os passos 2–4.
