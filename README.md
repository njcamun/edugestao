# EduGestao - Sistema de Gestao Escolar (Flutter + Firebase)

Aplicacao multiplataforma (Web e Android) para gestao escolar, com arquitetura offline-first (Drift/SQLite) e sincronizacao com Firebase.

## Como Executar Localmente

### 1) Pre-requisitos
- Flutter SDK (3.3.0+)
- Firebase CLI (`npm install -g firebase-tools`)
- Conta no Firebase Console

### 2) Configuracao Firebase
1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/).
2. Ative Authentication (Email/Senha e Google).
3. Ative Cloud Firestore.
4. Execute na raiz:
   ```bash
   flutterfire configure
   ```
   Selecione pelo menos `web` e `android`.

### 3) Configuracao Google Sign-In (Android)
No Windows (PowerShell):
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```
Copie o SHA-1 para o Firebase Console e atualize `android/app/google-services.json`.

### 4) Execucao
```bash
flutter pub get
flutter run -d chrome
# ou
flutter run
```

## Estado Atual da Aplicacao

### Modulos implementados
- Autenticacao (Google, email/senha e anonimo)
- Dashboard operacional e financeiro
- Gestao de alunos
- Gestao de turmas
- Matriculas
- Financeiro (mensalidades, pagamentos e custos)
- Relatorios (incluindo geracao de PDF)
- Configuracoes e perfis de utilizador

### Arquitetura
- UI e estado: Flutter + Riverpod
- Navegacao: GoRouter
- Persistencia local: Drift/SQLite
- Nuvem: Firebase Auth + Cloud Firestore
- Sync: pull inicial + push local + listeners realtime (quando suportado)

## Seguranca e Bootstrap de Admin

O projeto nao usa mais email hardcoded para privilegios de admin.

Para bootstrap inicial de admin em ambiente controlado, use:
```bash
flutter run --dart-define=BOOTSTRAP_ADMIN_EMAIL=teu_email@dominio.com
```

Se `BOOTSTRAP_ADMIN_EMAIL` nao for definido, novos perfis iniciam como `user`.

## Quality Gate (CI e validacao local)

O repositório inclui workflow de CI em `.github/workflows/ci.yml` com validacoes para Flutter e backend.

Antes de abrir PR, execute localmente:

### Flutter
```bash
flutter pub get
flutter analyze
flutter test
```

### Backend
```bash
cd backend
npm ci
npm run lint
npm run test
npm run build
```

Se qualquer comando falhar, corrija antes de submeter alteracoes.

Checklist operacional de release: `docs/release-readiness-checklist.md`.
