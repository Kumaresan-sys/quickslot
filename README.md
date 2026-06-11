# quickslot ![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0-blue?logo=flutter) ![License: MIT](https://img.shields.io/badge/License-MIT-green)

## Overview

**quickslot** is a modern, premium Flutter starter template that provides a clean architecture, state‑management setup, and ready‑to‑use UI components. Ideal for developers looking to jump‑start a new mobile app with best practices.

## Features

- ✨ Elegant UI with dark‑mode support
- 📦 Pre‑configured dependencies (provider, go_router, freezed)
- 🧪 Unit & widget testing setup
- 🚀 CI/CD ready (GitHub Actions workflow)
- 📱 Responsive layout for phones and tablets

## Getting Started

### Prerequisites

- Flutter SDK **≥ 3.0** (see the badge above)
- Dart 2.19+
- Android Studio / VS Code

### Installation

```bash
git clone https://github.com/Kumaresanj/quickslot.git
cd quickslot
flutter pub get
```

### Running the App

Configure the backend endpoints in `assets/.env`:

```env
QUICKSLOT_API_BASE_URL=http://10.0.2.2:5001
QUICKSLOT_SOCKET_URL=ws://10.0.2.2:5001
```

```bash
flutter run
```

For production or staging, replace the values with the matching HTTPS/WSS
endpoints before building.

## Usage

Explore the `lib/` directory to find:

- `core/` – essential services and utilities
- `features/` – feature‑specific modules
- `ui/` – reusable widgets and screens

Modify `main.dart` to start customizing your application.

## Roadmap

- [ ] Add support for Riverpod integration
- [ ] Publish a package to `pub.dev`
- [ ] Provide dark‑mode theme toggling UI

## Changelog

**v1.0.0** – Initial release with core architecture and sample screens.

## Contributing

Contributions are welcome! Please fork the repository, create a feature branch, and submit a pull request. Follow the [code of conduct](CODE_OF_CONDUCT.md).

## License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

## Contact

**Kumaresan J** – [GitHub](https://github.com/Kumaresanj) – Email: kumaresanj@example.com
