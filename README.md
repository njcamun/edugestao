# EduGestao - Sistema de Gestão Escolar (Flutter Multiplataforma + Firebase)

Solução multiplataforma (Web e Android) para gestão escolar, utilizando o ecossistema Firebase.

## 🚀 Como Executar Localmente

### 1. Pré-requisitos
*   Flutter SDK (3.3.0+)
*   Firebase CLI (`npm install -g firebase-tools`)
*   Conta no Firebase Console

### 2. Configuração do Firebase
O projecto utiliza Firebase (Firestore + Auth). Siga estes passos:

1.  Crie um projecto no [Firebase Console](https://console.firebase.google.com/).
2.  Ative **Authentication** (E-mail/Senha e Google).
3.  Ative **Cloud Firestore** em modo de teste.
4.  Execute o comando de configuração na raiz:
    ```bash
    flutterfire configure
    ```
    *Selecione as plataformas **web** e **android**.*

5.  **Configuração Google Sign-In (Android):**
    Obtenha o SHA-1 no Windows (PowerShell):
    ```powershell
    keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
    ```
    Copie o SHA-1, cole nas configurações do App Android no Firebase Console e baixe o novo `google-services.json` para `android/app/`.

### 3. Execução
```bash
flutter pub get
# Para Web
flutter run -d chrome
# Para Android
flutter run
```

---

## 🏗️ Arquitetura

*   **Framework:** Flutter (Responsivo: Web/Mobile)
*   **Estado:** Riverpod
*   **Navegação:** GoRouter (com redireccionamento de autenticação)
*   **Backend:** Firebase Auth, Firestore, Google Sign-In

---

## 📄 Estado Atual do Projecto

1.  **Autenticação:** ✅ Login funcional via E-mail/Senha e Google (Multiplataforma).
2.  **Dashboard:** 🚧 Em desenvolvimento (Placeholder).
3.  **Alunos:** 🚧 Em desenvolvimento (Placeholder).
4.  **Matrículas:** 🚧 Em desenvolvimento (Placeholder).
5.  **Financeiro:** 🚧 Em desenvolvimento (Placeholder).

---

## 🛠️ Próximos Passos
*   [ ] Reconstrução do Módulo de Alunos (CRUD Firestore).
*   [ ] Reconstrução do Módulo de Turmas e Salas.
*   [ ] Implementação do Módulo Financeiro automatizado.
