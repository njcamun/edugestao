# Firebase App Check — EDUCLASS

O código activa App Check em `lib/src/core/firebase/firebase_bootstrap.dart` logo após `Firebase.initializeApp`.

| Modo | Android | iOS |
|------|---------|-----|
| **Debug** (`flutter run`) | `AndroidDebugProvider()` | `AppleDebugProvider()` |
| **Release** (`flutter build appbundle --release`) | `AndroidPlayIntegrityProvider()` | `AppleDeviceCheckProvider()` |

Release completo: **[FIREBASE_RELEASE.md](./FIREBASE_RELEASE.md)** (Play Console + SHA-1 upload).

## 1. Activar App Check no Console

1. [Firebase Console](https://console.firebase.google.com/) → projecto **edugestao**.
2. **Build** → **App Check**.
3. Registe a app Android (`com.example.edugestao`) e iOS se aplicável.
4. Para cada produto usado, active o fornecedor:
   - **Cloud Firestore** → Play Integrity (Android) / Device Check (iOS)
   - **Authentication** → idem
   - **Storage** → idem

Comece em modo **Não aplicar** (métricas apenas). Quando os pedidos aparecerem como válidos no painel, mude para **Aplicar**.

## 2. Token de depuração (obrigatório em `flutter run`)

1. Execute a app no dispositivo/emulador:

   ```bash
   flutter run
   ```

2. O token aparece sobretudo no **logcat** (não só no log Flutter):

   - Android Studio → **Logcat** → filtro: `DebugAppCheckProvider` ou `AppCheck`
   - Procure uma linha como:  
     `Enter this debug secret into the allow list in the Firebase Console: xxxxxxxx-....`

   O log Flutter pode mostrar `403 App attestation failed` **até** registar o token — é esperado.

3. [Firebase Console](https://console.firebase.google.com/project/edugestao/appcheck) → **App Check** → app Android → **Gerir tokens de depuração** → **Adicionar token** → cole o valor → Guardar.

4. `flutter run` outra vez. O 403 deve desaparecer.

Opcional (evita depender só do logcat):

```bash
flutter run --dart-define=FIREBASE_APP_CHECK_DEBUG_TOKEN=SEU-UUID-DO-LOGCAT
```

O UUID tem de estar **também** registado no Console.

Sem este passo, em debug verá `403` / `Too many attempts` / token placeholder nos pedidos Auth/Firestore.

## 3. Play Integrity (release / Play Store)

1. [Google Cloud Console](https://console.cloud.google.com/) → projecto ligado ao Firebase (**edugestao**).
2. **APIs e serviços** → **Biblioteca** → active **Play Integrity API**.
3. Publique a app na Play Console (teste interno chega para validar Integrity).
4. No Firebase App Check, confirme **Play Integrity** como fornecedor da app Android.

## 4. Regras Firestore com App Check (quando aplicar enforcement)

Exemplo (ajuste ao seu modelo de auth):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null
        && request.appCheck != null
        && request.appCheck.token != null;
    }
  }
}
```

Enquanto estiver em **Não aplicar**, regras antigas continuam a funcionar; App Check só gera métricas.

## 5. Web (opcional)

Em `firebase_bootstrap.dart`, para Web é necessário `ReCaptchaV3Provider('SITE_KEY')` com a chave do Console → App Check → Web → reCAPTCHA v3.

## 6. Verificação

Após registar SHA-1 (ver [FIREBASE_ANDROID.md](./FIREBASE_ANDROID.md)) e o token de debug:

```bash
flutter clean
flutter pub get
flutter run
```

Esperado no log:

- `MAIN: App Check activado (fornecedor debug).`
- Ausência de `Error getting App Check token; using placeholder token` nos pedidos Auth/Firestore.

## Referências

- [App Check Flutter](https://firebase.google.com/docs/app-check/flutter/default-providers)
- [Tokens de depuração](https://firebase.google.com/docs/app-check/android/debug-provider)
