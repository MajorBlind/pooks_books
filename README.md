# Pooks' Books 📚

A cozy, personal book-reviewing and reading-journal desktop app. Track what you're reading, log your thoughts, and watch your reading goals fill in — all in a warm, card-based "Cozy Journal" interface.

![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows%20%7C%20Linux-lightgrey)
![Flutter](https://img.shields.io/badge/built%20with-Flutter-02569B?logo=flutter)

## What It Does

Pooks' Books is a personal reading journal — think of it as a diary for your books, not just a list of titles. Log books you're reading, want to read, or have finished, then write full reviews with your own custom fields for feelings, characters, and favorite quotes.

### Features

- **Status-based library** — Books are grouped into horizontally scrollable shelves: *Reading*, *Want to Read*, and *Read*
- **Rich reviews** — Rate books, jot your favorite quote, and track whether you'd recommend it with simple Yes / Maybe / Not Really pills
- **Feelings & characters tracking** — Tag how a book made you feel with multi-select chips (add your own), and keep a running, growable list of characters
- **Automatic cover art** — Book covers are fetched automatically via the Open Library API
- **Reading goals dashboard** — Set a yearly reading goal and track progress with a donut chart
- **Auto-updates** — The app checks for and installs new versions on its own, so you're always on the latest release
- **Local & private** — Your library is stored locally in a SQLite database — no account, no cloud sync required

## Built With

- **[Flutter](https://flutter.dev) / Dart** — cross-platform desktop UI framework
- **sqflite_common_ffi** — local SQLite database
- **fl_chart** — reading goals donut chart
- **http** — networking for cover art lookups
- **[Open Library API](https://openlibrary.org/developers/api)** — book cover art
- **shared_preferences** — lightweight settings storage (e.g. yearly reading goal)
- **auto_updater** — in-app update checking and installation
- **GitHub Actions** — CI/CD pipeline that builds macOS, Windows, and Linux binaries in parallel and attaches them to a GitHub Release whenever a version tag is pushed

## Compatibility

| Platform | Status |
|---|---|
| macOS | ✅ Supported (auto-updates included) |
| Windows | 🚧 Coming soon |
| Linux | 🚧 Coming soon |
| Mobile (iOS/Android) | 🚧 Planned for a future release |

## Download & Installation

1. Go to the [**Releases**](../../releases) page of this repository.
2. Download the zip file for your operating system from the latest release.
3. Unzip the file and move the app to your **Applications** folder (macOS) or wherever you keep your programs (Windows/Linux).
4. Open the app.

### "Unidentified Developer" Warning (macOS)

Since this app isn't distributed through the App Store or signed with a paid developer certificate yet, macOS may block the first launch with a warning. Here's how to get past it:

1. Try to open the app — you'll see a warning that it's from an unidentified developer and can't be opened.
2. Open **System Settings → Privacy & Security**.
3. Scroll down to the **Security** section — you'll see a message that "Pooks' Books" was blocked.
4. Click **Open Anyway**.
5. Confirm by clicking **Open** in the follow-up prompt (you may need to enter your password or use Touch ID).

*(Alternative: right-click (or Control-click) the app icon → **Open** → **Open** again in the dialog that appears.)*

> **Note:** This warning appears because the app isn't yet code-signed with a paid developer certificate — not because anything is actually wrong with it. Code signing is on the roadmap for a future release.