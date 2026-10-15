# Call of Duty: Black Ops II (Zombies) on iPhone

*[Leer en español](BLACK_OPS_2.es.md)*

This fork of [Madeira](https://github.com/willfaust/Madeira) is tuned for one
game: **Call of Duty: Black Ops II Zombies**, played offline through the
[Plutonium](https://plutonium.pw) T6 client.

> [!IMPORTANT]
> **Tested on one phone only: iPhone 15 Pro Max (iOS 27.0).** There it reaches
> the main menu and plays Zombies matches at about **60 FPS** with the settings
> below. Other iPhones have not been tried. Expect it to run slower on older
> chips and with less memory.

No game files, Plutonium files or other copyrighted content are included in
this repository or in its releases. You need your own legal copy of Black Ops
II. This project is not affiliated with Activision, Treyarch, Valve or the
Plutonium team.

## What this fork changes

Stock Madeira cannot start Plutonium's Black Ops II client. The client is
protected with Themida, which hides parts of the game until a hardware
breakpoint fires. The emulator ignored those breakpoints, so the protected
routines silently did nothing. The game then hung on its first fastfile with a
black screen ([FEX-Emu issue #5966](https://github.com/FEX-Emu/FEX/issues/5966)).

| Area | Change |
|---|---|
| FEX (x86 emulator) | Implements x86 hardware execute breakpoints (debug registers DR0-DR3 and DR7) for 32-bit programs. This is what makes Plutonium start and load. |
| Madeira runtime | The livelock watchdog no longer counts the emulator's own trap instructions. Before, it killed the game's loader thread after 50 breakpoints, so the game stuck on the loading logo. |
| Madeira runtime | Windows thread priorities now reach iOS. Audio mixer threads run with real-time scheduling, which fixes choppy, laggy audio. |
| Madeira runtime | `MADEIRA_NO_SAMPLER=1` turns off the built-in thread sampler, which pauses every thread for a moment every 20 seconds. |
| Controllers | Optional software calibration for worn or noisy controllers: rest offsets, dead zones, trigger thresholds, button debounce and stick smoothing (`MADEIRA_PAD_CAL`). |
| Build | Build-script fixes for the current toolchains, including Xcode 27. |

The source for every change is public. The emulator, Wine and DXMT changes
live on the `bo2` branch of this account's forks of
[FEX](https://github.com/Manudev24/FEX/tree/bo2), [wine](https://github.com/Manudev24/wine/tree/bo2) and
[dxmt](https://github.com/Manudev24/dxmt/tree/bo2), which this repository uses as submodules.

## 1. Install the app

1. Download `Madeira-BO2-*.ipa` from this fork's [Releases](https://github.com/Manudev24/Madeira/releases) page.
2. Sideload it with your own Apple ID, using SideStore, AltStore, Sideloadly,
   Plume or a similar tool. The IPA is unsigned; your sideloading tool signs it.
3. Enable JIT and check that **Settings** shows green checks for **JIT** and
   **Memory+**, exactly as in upstream Madeira (see [JIT setup](JIT.md) and the
   main [README](../README.md#installing)).

This build uses the same bundle identifier as upstream Madeira. Installing it
replaces upstream Madeira but keeps your games and settings.

## 2. Get the game files

You need Black Ops II with its Zombies content and any Zombies map packs you
own. Choose one way to get them.

### Option A: Steam inside Madeira

1. In Madeira, sign in to Steam ([Steam sign-in](STEAM_SIGNIN.md)).
2. In the library, install Black Ops II and its Zombies component. Madeira
   downloads them from Steam into its Windows drive.
3. Open the game's page and note the install folder shown under
   **Executable**. You will use that folder instead of `C:\BO2` below.

Starting the Steam version itself (through Madeira Dock or **The game**) has
not been tested with this fork. The tested way to play is Plutonium, described
in step 3, using these downloaded files.

### Option B: copy them from a PC

1. On a Windows PC, install Black Ops II from Steam.
2. With the Files app or Finder, copy the game folder to
   **Madeira › wine › drive_c › BO2** on the iPhone.

### Saving space (Zombies only)

The full game is about 17 GB. For Zombies only, you can leave out the
Multiplayer files, which brings it to about 11 GB:

- `zone/all/mp_*` files and every file whose name ends in `_mp`;
- `zone/all/mp.ipak`, `patch_mp.ipak`, `mp_frostbite.ipak` and
  `mp_nuketown_2020.ipak`;
- the `redist` folder.

Keep `base.ipak`, `patch.ipak`, `patch_zm.ipak`, `so.ipak` and every
`dlczm*.ipak`. If a DLC map shows missing textures, put `dlc0.ipak` to
`dlc4.ipak` back.

## 3. Get Plutonium

1. On a Windows PC, download the launcher from [plutonium.pw](https://plutonium.pw),
   sign in and let it finish updating. Follow Plutonium's own rules and terms.
2. Copy the contents of `%LOCALAPPDATA%\Plutonium` (the folders `bin`, `games`,
   `storage` and the others) to **Madeira › wine › drive_c › Plutonium** on the
   iPhone.

Running the Plutonium launcher itself inside Madeira has not been tested.

## 4. Add the game to the library

1. In Madeira, tap **+** and choose
   `Plutonium\bin\plutonium-bootstrapper-win32.exe`.
2. Open the new entry and set:

   | Setting | Value |
   |---|---|
   | **Launch arguments** | `t6zm "C:\BO2" -lan +name "YourName"` |
   | **Launch › Start** | **In the Wine desktop** (required: the client refuses to start without it) |
   | **Launch › Working folder** | `C:\Plutonium` |

   If you installed the game with Steam (option A), replace `C:\BO2` with the
   install folder from step 2.

3. Under **Advanced › This game's config**, paste:

   ```
   env.MADEIRA_STACK_XCHG_PLAIN = 1
   env.MADEIRA_GDI_SHARED_SECTION = 1
   env.MADEIRA_WOW_RWX_PLAIN = 1
   env.FEX_SMCCHECKS = mman
   env.FEX_TSOENABLED = 0
   env.MADEIRA_FASTSYNC = 1
   env.MADEIRA_FASTSYNC_SEM = 1
   env.MADEIRA_FASTSYNC_CAP_US = 50000
   env.MADEIRA_FASTSYNC_SPIN_US = 200
   env.MADEIRA_NO_SAMPLER = 1
   env.MADEIRA_AUDIO_LEAD_MS = 150
   ```

## 5. Play

- Set **Settings › Display & Brightness › Auto-Lock** to **Never** while the
  game starts. iOS pauses Madeira when the screen locks, and the game does not
  survive that.
- The first start takes about a minute and a half before the menu appears.
- In the game's audio options, set the speaker configuration to **Stereo**. You
  can also set `seta snd_speakerConfiguration "Stereo"` in
  `Plutonium\storage\t6\players\plutonium_zm.cfg`. Mixing 5.1 audio costs CPU
  time for nothing on a phone.
- A Bluetooth or USB-C controller in Xbox mode works through XInput.

## Optional: controller calibration

If a stick drifts or a trigger presses itself, add a line like this one to the
game's config:

```
env.MADEIRA_PAD_CAL = ldz:0.25,rdz:0.12,ltz:0.60,rtz:0.20,deb:80,lpf:0.50
```

| Key | Meaning |
|---|---|
| `lx`, `ly`, `rx`, `ry` | Resting value of each stick axis, subtracted from every reading |
| `ldz`, `rdz` | Dead zone of the left and right stick (0 to 0.9); full travel is kept |
| `lt`, `rt` | Resting value of each trigger |
| `ltz`, `rtz` | Trigger threshold (0 to 0.9); below it the trigger reads as released |
| `deb` | Button debounce in milliseconds: a release shorter than this is ignored |
| `lpf` | Stick smoothing (0 to 0.95): higher filters more noise but adds lag |

## Known issues

- At the end of a match the game can show an error and must be restarted. The
  app itself keeps running.
- The phone gets warm during long sessions.
- Only the iPhone 15 Pro Max has been tested.

## Building from source

Clone with submodules and follow upstream's [build guide](BUILDING.md):

```bash
git clone --recurse-submodules -b bo2 https://github.com/Manudev24/Madeira.git
```

Build the **Debug** configuration. Upstream notes that Release builds have
crashed the guest.

## Credits

[Madeira](https://github.com/willfaust/Madeira) by Will Faust and its
contributors, [FEX-Emu](https://github.com/FEX-Emu/FEX),
[Wine](https://www.winehq.org/), [DXMT](https://github.com/3Shain/DXMT) and
[Plutonium](https://plutonium.pw). This fork was developed with the help of an
AI assistant (Claude). Its emulator changes are not submitted upstream,
because FEX-Emu does not accept AI-generated contributions.

Licensing is unchanged from upstream: GPL-3.0-or-later with the Madeira
Converter Exception. See [Licensing](../README.md#licensing).
