# Nightfall Project

A local multiplayer party game suite — a Flutter mobile app and an Angular companion website.  
Pass one device around your group. No internet required.

---

## What's in this repo

```
Nightfall/
├── nightfall_project/   # Flutter mobile app  (v4.3.3)
├── nightfall-web/       # Angular companion website
├── Rulebook/            # Physical rulebook scan (Bosnian and English)
└── README.md
```

---

## The Mobile App — `nightfall_project/`

### Overview

A fully offline social deduction game manager for real-life groups.  
The app acts as narrator and game master: it assigns secret roles, guides each night step, resolves outcomes, and tracks a persistent leaderboard — all without a server.

Two complete games are bundled:

| Game | Min. players | Language |
|------|-------------|----------|
| **Werewolves** | 5 | EN / BS |
| **Impostor** | 3 | EN / BS |

### Getting started

```bash
cd nightfall_project
flutter pub get
flutter run
```

Requires Flutter SDK `^3.9.2`.

---

### Werewolves

A social deduction game where villagers try to root out hidden werewolves through logic, discussion, and voting, while the werewolves hunt them in the dark.

#### Roles — 18 total

**Village alliance** (win by eliminating all werewolves)

| Role | Points | Ability |
|------|--------|---------|
| Villager | 1 | No special ability |
| Doctor | 1 | Heals one player per night; cannot heal the same player twice in a row |
| Guard | 1 | Inspects one player per night; sees Werewolf/Clear result |
| Plague Doctor | 1 | Heals one player per night with a small chance of accidentally killing them |
| Twins | 1 | Must be assigned in pairs; if one is hanged, the other turns into an Avenging Twin |
| Knight | 1 | Has two lives — armor absorbs the first lethal hit |
| Executioner | 1 | If hanged by the village, drags one additional player to their death |
| Infected | 1 | Kills the Doctor if healed; kills the Vampire if the werewolves target them |
| Drunk | 1 | Loyal villager, but the Guard sees them as a Werewolf |
| Shaman | 1 | Every second night sees the true role of one player, bypassing all disguises |
| Wraith | 1 | Completely immortal — cannot be killed by werewolves, plague, hanging, or execution |

**Werewolf alliance** (win by outnumbering the villagers)

| Role | Points | Ability |
|------|--------|---------|
| Werewolf | 2 | Kills one player per night with the pack (1–3 can be assigned) |
| Vampire | 2 | Kills with the werewolves; invisible to the Guard |
| Avenging Twin | 3 | Not assignable directly; spawns when a Twin is hanged; joins the pack |
| Dire Wolf | 2 | Hunts with the pack; on odd nights silences one player, blocking their ability the following night |

**Specials** (independent win conditions)

| Role | Points | Win condition |
|------|--------|---------------|
| Jester | 3 | Wins by getting hanged by the village |
| Puppet Master | 0* | Transforms into the first hanged player's role and inherits their points |
| Gambler | 0* | On Night 1 secretly bets on which alliance wins; earns their points if correct |

*Variable — depends on outcome.

#### Night step order

1. **Gambler** — first night only; places alliance bet
2. **Werewolves** — Werewolf + Vampire + Avenging Twin choose a victim
3. **Dire Wolf** — odd nights only; silences one non-wolf player
4. **Doctor** — heals one player (skipped if silenced)
5. **Guard** — inspects one player (skipped if silenced)
6. **Plague Doctor** — heals with risk (skipped if silenced)
7. **Shaman** — even nights only; sees true role (skipped if silenced)

#### Game phases

| Phase | Description |
|-------|-------------|
| **1 — Role Setup** | Narrator configures role counts. The app validates balance and saves settings. |
| **2 — Role Discovery** | Each player privately taps their tile to flip their SECRET role card. |
| **3 — Night Phase** | Narrator walks through each active role step by step. Dawn result dialog resolves deaths. |
| **4 — Day Phase** | Countdown timer, discussion, vote to hang. Handles Executioner retaliation, Puppet Master transformation, win detection. |
| **5 — Victory** | Animated win screen, win sound, points awarded and saved to leaderboard. |

---

### Impostor

A word-based social deduction game. One player gets a different word from everyone else — they are the Impostor. Players describe the word without saying it; the group votes on who they think the Impostor is.

**14 word categories:** Locations, Food, Cartoons, Famous People, Objects, Anime, Islam, Landmarks, Fighters, Brands, Games, Sports, Animals, Movies.

---

### Screens & navigation

```
NightfallIntroScreen  (animated splash)
└── SplitHomeScreen   (swipe left = Werewolves / swipe right = Impostor)
    ├── WerewolfGameLayout
    │   ├── WerewolfPlayersScreen
    │   ├── WerewolfRolesScreen
    │   ├── WerewolfLeaderboardsScreen → PlayerAnalyticsScreen
    │   └── Game flow: Phase 1 → 2 → 3 ↔ 4 → 5
    └── ImpostorGameLayout
        ├── ImpostorPlayersScreen
        ├── ImpostorCategoriesScreen
        ├── ImpostorLeaderboardsScreen
        └── Game flow: Phase 1 → 2 → 3
```

> **Easter egg:** hold the version string in the bottom-right corner of the home screen for 1 second to see the credits.

---

### Architecture

- **State management** — `provider` (`LanguageService`, `SoundSettingsService` as `ChangeNotifier`s)
- **Storage** — `shared_preferences` (players, role config, leaderboard, settings, language). No network calls.
- **Audio** — `audioplayers` with a single global `AudioPlayer` managed by `SoundSettingsService`. Supports `playGlobal(path, loop)` and `stopAll()`.
- **Fonts** — `Press Start 2P` (headers) + `VT323` (body) via `google_fonts`
- **Background** — `PixelStarfieldBackground`: an animated `CustomPainter` that draws descending pixel stars; present on every game screen

#### Key services

| Service | Responsibility |
|---------|---------------|
| `LanguageService` | EN / BS toggle; persisted to SharedPreferences |
| `SoundSettingsService` | Single global audio player; mute toggle; persisted |
| `WerewolfRoleService` | In-memory list of all 18 roles |
| `WerewolfPlayerService` | Player CRUD persisted to SharedPreferences |
| `WerewolfGameSettingsService` | Saves role configuration per player count |
| `TimerSettingsService` | Day phase timer mode (5 min / 10 min / 30 s per player / ∞) |
| `PlayerAnalyticsService` | Per-player game history (role, win/loss, points, timestamp) |

#### Dependencies

```yaml
google_fonts:       ^6.3.3   # Press Start 2P + VT323
audioplayers:       ^6.5.1   # Audio playback
shared_preferences: ^2.5.4   # Local persistence
provider:           ^6.1.2   # State management
```

---

## The Web App — `nightfall-web/`

### Overview

An Angular companion website for players who want to browse roles or read the rulebook before or after a session. It is informational — not a playable game.

Live at: **Vercel** (deploy via `npm run build`, output `dist/nightfall-web/browser`)

### Pages

| Route | Page | Description |
|-------|------|-------------|
| `/roles` | Roles | All 18 Werewolves roles grouped by alliance. Click any card to expand its full description and points. |
| `/rulebook` | Rulebook | Paginated book-style rulebook covering setup, alliances, night/day phases, character abilities, and scoring. |

### Running locally

```bash
cd nightfall-web
npm install
npm start
```

Requires Node.js + npm. Angular CLI `^21.1.5`.

### Architecture

- **Framework** — Angular 21 (standalone components, Angular signals, no NgModules)
- **Routing** — `@angular/router` with lazy-loaded page routes
- **Styling** — Hand-written CSS with custom properties (`--nf-bg-deep`, `--nf-frame`, `--font-pixel`, `--font-body`, etc.). No CSS framework.
- **Language** — Signal-based `LanguageService`; EN / BS toggle; persisted to `localStorage`. Uses the same translation key names as the Flutter app.
- **Background** — `StarfieldComponent`: canvas-based pixel starfield running outside the Angular zone for performance

#### Key dependencies

```json
"@angular/core":   "^21.1.0"
"@angular/router": "^21.1.0"
"rxjs":            "~7.8.0"
"typescript":      "~5.9.2"
"vitest":          "^4.0.8"
```

---

## Localisation

Both apps support **English (EN)** and **Bosnian (BS)**.  
The Flutter app resolves keys from `lib/services/translations_en.dart` and `lib/services/translations_bs.dart`.  
The web app uses `src/app/shared/language/translations.ts` with the same key names.  
Missing BS keys fall back to English automatically.

---

## Shared assets

Role artwork is shared between both apps. The Flutter app is the canonical source:

```
nightfall_project/assets/images/werewolves/
    Villager.png  Werewolf.png  Doctor.png  Guard.png
    Plague Doctor.png  Twins.png  Avenging Twin.png  Vampire.png
    Jester.png  Drunk.png  Knight.png  Puppet Master.png
    Executioner.png  Infected.png  Gambler.png  Shaman.png
    Wraith.png  Dire Wolf.png
```

The web app serves the same images from `nightfall-web/public/images/werewolves/`.

---

## Credits

| Role | Name |
|------|------|
| Lead Developer | Vedad Keskin |
| Game Design | Nidal Keskin |
| Art Design | Iman-Bejana Keskin |
| QA Testing | Amar Bešić |
| Hotspot Provider | Said Keskin |
