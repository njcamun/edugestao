# Firebase Android — EDUCLASS

Pacote Android: **`com.example.edugestao`** (`android/app/build.gradle.kts`).

Projecto Firebase: **`edugestao`** (ver `lib/firebase_options.dart`).

Os avisos `DEVELOPER_ERROR`, `GoogleApiManager` / `Unknown calling package name` e falhas de Google Sign-In costumam resumir-se a:

1. **SHA-1** (e por vezes SHA-256) não registado no Firebase / Google Cloud.
2. Falta de **`android/app/google-services.json`** actualizado.
3. **App Check** sem token de debug registado — ver [FIREBASE_APP_CHECK.md](./FIREBASE_APP_CHECK.md).

---

## Checklist rápido

| Passo | Onde | Estado |
|-------|------|--------|
| SHA-1 debug no Firebase | Console → Definições → App Android | ☐ |
| `google-services.json` em `android/app/` | Descarregar após adicionar SHA | ☐ |
| App Check activado + token debug | [FIREBASE_APP_CHECK.md](./FIREBASE_APP_CHECK.md) | ☐ |
| `flutter run` sem `DEVELOPER_ERROR` repetido | Logcat | ☐ |

---

## 1. Obter SHA-1 e SHA-256 (debug)

Na raiz do projecto:

```powershell
cd android
.\gradlew signingReport
```

Na secção **Variant: debug** da app `:app`, copie **SHA-1** e **SHA-256**.

Alternativa:

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

> Cada máquina de desenvolvimento pode ter um keystore diferente. Todos os SHA-1 usados em `flutter run` devem estar no Console.

Script auxiliar (raiz do repo):

```powershell
.\scripts\firebase-android-sha.ps1
```

---

## 2. Registar impressões digitais no Firebase

1. Abra [Firebase Console](https://console.firebase.google.com/) → **edugestao**.
2. **Definições do projecto** (engrenagem) → **As suas apps**.
3. App Android → confirme pacote **`com.example.edugestao`**.
4. **Adicionar impressão digital** → cole o **SHA-1** de debug.
5. Repita com **SHA-256** (recomendado para Auth recente).
6. **Guardar**.

O Firebase cria/actualiza o cliente OAuth Android no Google Cloud. Aguarde **5–15 minutos** antes de testar.

### Google Cloud (se Sign-In ainda falhar)

1. [Google Cloud Console](https://console.cloud.google.com/) → projecto **edugestao**.
2. **APIs e serviços** → **Credenciais**.
3. Cliente OAuth **Android** → confirme pacote `com.example.edugestao` e o mesmo SHA-1.
4. Active **Google Sign-In** / People API se ainda não estiverem activas.

---

## 3. `google-services.json`

Após adicionar SHA, descarregue o JSON actualizado:

**Definições do projecto** → app Android → **google-services.json**

Coloque em:

```text
android/app/google-services.json
```

Modelo: `android/app/google-services.json.example` (não substitui o ficheiro real).

O ficheiro real está no `.gitignore` — cada developer/CI deve tê-lo localmente.

---

## 4. FlutterFire (opcional)

Se mudar de projecto Firebase ou `applicationId`:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Actualiza `lib/firebase_options.dart` e o `google-services.json`.

---

## 5. App Check

Implementado no código. Passos no Console: **[FIREBASE_APP_CHECK.md](./FIREBASE_APP_CHECK.md)**.

---

## 6. Build release (Play Store)

Para keystore de upload, SHA-1 de release e Play Integrity, siga **[FIREBASE_RELEASE.md](./FIREBASE_RELEASE.md)**.

---

## 7. Verificar

```bash
flutter clean
flutter pub get
flutter run
```

Logs esperados:

```text
MAIN: Firebase inicializado com sucesso.
MAIN: App Check activado (fornecedor debug).
```

Reduzir / eliminar:

- `ConnectionResult{statusCode=DEVELOPER_ERROR}`
- `Error getting App Check token; using placeholder token`

---

## Notas

- **Windows desktop**: Firebase não é inicializado (`main.dart`) para evitar crash do plugin.
- **iOS**: registe também o bundle `com.example.edugestao` e SHA/certificados no Firebase se publicar na App Store.
