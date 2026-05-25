# Release Readiness Checklist — EDUCLASS

## Security

- Confirm `JWT_ACCESS_SECRET` and `JWT_REFRESH_SECRET` are set per environment (backend).
- Confirm no debug bypasses are enabled in production.
- Confirm admin bootstrap is controlled with `BOOTSTRAP_ADMIN_EMAIL` only during setup.
- Review role permissions for sensitive actions (finance, settings, reports).
- Deploy **Firestore security rules** per institution (see `FIREBASE_FIRESTORE.md`).

## Environment Configuration

- Validate separate configs for `dev`, `staging`, and `prod`.
- Validate Firebase project and API endpoints per environment.
- Android: SHA-1 + `android/app/google-services.json` + App Check debug token (see `FIREBASE_ANDROID.md`, `FIREBASE_APP_CHECK.md`).
- Validate required `--dart-define` values for production builds.

## Quality Gates

### Flutter

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze lib
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

## Application Smoke Tests

- [ ] Login (Google / email)
- [ ] Dashboard loads (KPIs, chart)
- [ ] Create / edit student
- [ ] Create class and enrollment
- [ ] Generate monthly fees and confirm payment
- [ ] Staff + salary processing (finance role)
- [ ] Inventory asset + maintenance
- [ ] Launch grade + export boletim PDF / CSV
- [ ] Schedule class + conflict warning (same room or professor)
- [ ] Create notification + mark read + sync on second device
- [ ] Reports: students list PDF, finance PDF, grades pauta
- [ ] Settings: institution data saved
- [ ] Manual sync from layout (if available)

## Data and Operations

- Validate DB backup and restore procedure.
- Validate migration plan (Drift v4) and rollback plan before deploy.
- Windows: confirm users understand sync is upload-oriented.

## Monitoring

- Ensure backend logs include contextual IDs.
- Ensure frontend and backend error reporting is active.
- Define alert thresholds for critical failures.
