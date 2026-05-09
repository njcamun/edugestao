# Release Readiness Checklist

## Security
- Confirm `JWT_ACCESS_SECRET` and `JWT_REFRESH_SECRET` are set per environment.
- Confirm no debug bypasses are enabled in production.
- Confirm admin bootstrap is controlled with `BOOTSTRAP_ADMIN_EMAIL` only during setup.
- Review role permissions for sensitive actions (finance, settings, reports).

## Environment Configuration
- Validate separate configs for `dev`, `staging`, and `prod`.
- Validate Firebase project and API endpoints per environment.
- Validate required `--dart-define` values for production builds.

## Quality Gates
- Run Flutter checks:
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test`
- Run backend checks:
  - `npm ci`
  - `npm run lint`
  - `npm run test`
  - `npm run build`

## Data and Operations
- Validate DB backup and restore procedure.
- Validate migration plan and rollback plan before deploy.
- Validate application smoke tests:
  - login
  - student creation
  - enrollment
  - monthly fee generation
  - payment confirmation
  - report generation

## Monitoring
- Ensure backend logs include contextual IDs.
- Ensure frontend and backend error reporting is active.
- Define alert thresholds for critical failures.
