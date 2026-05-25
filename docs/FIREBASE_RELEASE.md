# Firebase & Android — build RELEASE (EDUCLASS)

Guia para `flutter build appbundle --release` / instalação via Play Store (teste interno).

Projecto: **edugestao** · Pacote: **com.example.edugestao**

---

## 1. Keystore de release

```powershell
cd "D:\Projectos Flutter\edugestao"
.\scripts\create-release-keystore.ps1
```

Isto cria:

- `android/upload-keystore.jks` (não commitar)
- `android/key.properties` (não commitar; modelo em `key.properties.example`)

---

## 2. SHA-1 / SHA-256 de RELEASE no Firebase

```powershell
.\scripts\firebase-android-sha.ps1
```

Copie os valores da variante **`release`** (não só debug).

1. [Firebase → Definições → App Android](https://console.firebase.google.com/project/edugestao/settings/general)
2. Adicione **SHA-1** e **SHA-256** do keystore **upload**
3. Mantenha também os de **debug** se continuar com `flutter run`
4. Descarregue novo `google-services.json` → `android/app/google-services.json`

---

## 3. App Check em release (Play Integrity)

### Console

1. [App Check](https://console.firebase.google.com/project/edugestao/appcheck) → app Android
2. Fornecedor: **Play Integrity** (não Debug)
3. Active para Firestore, Auth, Storage
4. Comece com **Não aplicar**; depois **Aplicar** quando métricas estiverem OK

### Google Cloud

1. [APIs](https://console.cloud.google.com/apis/library/playintegrity.googleapis.com?project=edugestao) → active **Play Integrity API**

### Play Console

Play Integrity **só funciona de forma fiável** quando a app está assinada com o certificado de upload registado na Play:

1. Crie app em [Google Play Console](https://play.google.com/console)
2. Pacote: `com.example.edugestao`
3. Envie um **AAB** de teste interno:

   ```bash
   flutter build appbundle --release
   ```

   Ficheiro: `build/app/outputs/bundle/release/app-release.aab`

4. Instale a partir da faixa de **teste interno** (não APK sideload manual) para validar Integrity

> APK release instalado com `adb install` fora da Play Store costuma **falhar** App Check / Integrity.

---

## 4. Comportamento no código

| Comando | App Check |
|---------|-----------|
| `flutter run` | Debug (`AndroidDebugProvider`) |
| `flutter run --release` | Play Integrity |
| `flutter build appbundle --release` | Play Integrity |

Teste local de release **antes** da Play Store (só QA):

```bash
flutter run --release --dart-define=APP_CHECK_USE_DEBUG=true
```

Usa fornecedor debug mesmo em release — **não usar em produção**.

---

## 5. Build e verificação

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Checklist:

- [ ] `android/key.properties` existe
- [ ] SHA-1/256 de **release** no Firebase
- [ ] `google-services.json` actualizado
- [ ] Play Integrity API activa
- [ ] AAB em teste interno na Play
- [ ] App Check: Play Integrity registado no Firebase

---

## 6. Debug vs release (resumo)

| | Debug (`flutter run`) | Release (loja) |
|--|----------------------|----------------|
| Assinatura | Debug keystore | `upload-keystore.jks` |
| SHA-1 Firebase | Debug | Upload / Play App Signing |
| App Check | Token debug no Console | Play Integrity |
| Doc | [FIREBASE_APP_CHECK.md](./FIREBASE_APP_CHECK.md) | Este ficheiro |

Ver também: [FIREBASE_ANDROID.md](./FIREBASE_ANDROID.md)
