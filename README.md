# QuickSlot Flutter App

Flutter client for QuickSlot, a small sports-slot booking app backed by the
QuickSlot API in `../QuickSlot_Api`.

## Run Locally

Start the backend first:

```bash
cd ../QuickSlot_Api
docker compose up -d --build
```

Install and run the app:

```bash
cd ../quickslot
flutter pub get
flutter run
```

For an Android emulator, `assets/.env` should use:

```env
QUICKSLOT_API_BASE_URL=http://10.0.2.2:5001
QUICKSLOT_SOCKET_URL=ws://10.0.2.2:5001
```

For a physical phone, replace `10.0.2.2` with the laptop's LAN IP address and
keep the phone on the same Wi-Fi network.

## Demo Users

The login screen includes one-tap seeded users:

- John Doe: `test@example.com` / `password123`
- Jane Smith: `jane@example.com` / `password123`

## App Structure

- `lib/core`: API, socket, configuration, connectivity utilities
- `lib/domain`: entities, repository contracts, use cases, booking failure classifier
- `lib/data`: JSON models and repository implementations
- `lib/presentation`: pages, reusable widgets, Cubit/Bloc state

State management uses `flutter_bloc` because the booking flow has explicit
loading, loaded, empty, conflict, and error states. Keeping that state outside
widgets makes the double-booking conflict easy to handle and test.

## Verification

```bash
flutter test
```

