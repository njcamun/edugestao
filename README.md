# EDUCLASS – Gestão Escolar

Aplicação multiplataforma (**Android, Web, Windows**) para gestão escolar, com arquitetura **offline-first** (Drift/SQLite) e sincronização com **Firebase** (Auth + Firestore).

## Pré-requisitos

- Flutter SDK 3.3.0+
- Conta Firebase (Auth + Firestore)
- Android debug: [docs/FIREBASE_ANDROID.md](docs/FIREBASE_ANDROID.md), [docs/FIREBASE_APP_CHECK.md](docs/FIREBASE_APP_CHECK.md)
- Android **release** / Play Store: [docs/FIREBASE_RELEASE.md](docs/FIREBASE_RELEASE.md)

## Execução rápida

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # após alterações Drift
flutter analyze lib
flutter test
flutter run
```

## Módulos (estado actual)

| Área | Rota | Funcionalidades |
|------|------|-----------------|
| Painel | `/` | KPIs, gráfico, avisos pendentes |
| Secretaria | `/alunos` | Alunos, turmas, matrículas |
| Funcionários | `/funcionarios` | CRUD, presença |
| Salários | `/salarios` | Folha mensal (perfil financeiro) |
| Finanças | `/financeiro` | Propinas, custos, recibos PDF |
| Inventário | `/inventario` | Activos e manutenções |
| Notas | `/notas` | Lançamento 0–20, médias, PDF/CSV |
| Horários | `/horarios` | Grade por turma, conflitos sala/professor |
| Notificações | `/notificacoes` | Avisos, criar aviso, sync cloud |
| Relatórios | `/relatorios` | Alunos, financeiro, notas (boletim, pauta, CSV) |
| Definições | `/configuracoes` | Instituição, utilizadores |
| Hub | `/modulos` | Acesso a todos os módulos |

## Arquitectura

- **UI / estado:** Flutter + Riverpod  
- **Navegação:** GoRouter + `ResponsiveLayout`  
- **Local:** Drift **schema v4** (`notas_avaliacao`, `horarios_aula`, funcionários, salários, inventário, …)  
- **Nuvem:** Firebase Auth + Firestore  
- **Sync:** `syncAll` + push local + listeners realtime (Android/Web); Windows faz sobretudo upload  

Documentação Firestore: [docs/FIREBASE_FIRESTORE.md](docs/FIREBASE_FIRESTORE.md)

## Segurança – admin inicial

```bash
flutter run --dart-define=BOOTSTRAP_ADMIN_EMAIL=teu_email@dominio.com
```

Sem este define, novos perfis iniciam como `user`.

## Checklist antes de release

1. Configurar Firebase Android (SHA-1 + `android/app/google-services.json`).  
2. Smoke test: login → aluno → matrícula → mensalidade → pagamento → nota → horário → PDF.  
3. `flutter analyze` e `flutter test` sem erros.  
4. Regras Firestore de produção (não usar só o exemplo do doc).  

Detalhe: [docs/release-readiness-checklist.md](docs/release-readiness-checklist.md)

## CI

Workflow em `.github/workflows/ci.yml` (Flutter + backend).

```bash
cd backend && npm ci && npm run lint && npm run test && npm run build
```
