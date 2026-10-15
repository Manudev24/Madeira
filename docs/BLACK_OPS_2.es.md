# Call of Duty: Black Ops II (Zombies) en iPhone

*[Read in English](BLACK_OPS_2.md)*

Este fork de [Madeira](https://github.com/willfaust/Madeira) está ajustado para
un solo juego: **Call of Duty: Black Ops II Zombies**, jugado sin conexión con
el cliente T6 de [Plutonium](https://plutonium.pw).

> [!IMPORTANT]
> **Probado en un solo teléfono: iPhone 15 Pro Max (iOS 27.0).** En él llega al
> menú principal y juega partidas de Zombies a unos **60 FPS** con la
> configuración de abajo. No se ha probado en otros iPhone. En chips más
> antiguos o con menos memoria lo normal es que vaya más lento.

Este repositorio y sus releases no incluyen archivos del juego, archivos de
Plutonium ni ningún otro contenido con derechos de autor. Necesitas tu propia
copia legal de Black Ops II. Este proyecto no está afiliado a Activision,
Treyarch, Valve ni al equipo de Plutonium.

## Qué cambia este fork

Madeira original no puede arrancar el cliente de Black Ops II de Plutonium. El
cliente está protegido con Themida, que oculta partes del juego hasta que salta
un breakpoint de hardware. El emulador ignoraba esos breakpoints, así que las
rutinas protegidas no hacían nada. El juego se quedaba entonces en el primer
fastfile con la pantalla en negro
([FEX-Emu issue #5966](https://github.com/FEX-Emu/FEX/issues/5966)).

| Área | Cambio |
|---|---|
| FEX (emulador x86) | Implementa los breakpoints de ejecución por hardware de x86 (registros de depuración DR0-DR3 y DR7) para programas de 32 bits. Es lo que permite que Plutonium arranque y cargue. |
| Madeira | El vigilante de bucles colgados ya no cuenta las trampas propias del emulador. Antes mataba el hilo de carga del juego tras 50 breakpoints, y el juego se quedaba en el logo de carga. |
| Madeira | Las prioridades de hilo de Windows ahora llegan a iOS. Los hilos del mezclador de audio usan planificación de tiempo real, lo que arregla el audio entrecortado y con retardo. |
| Madeira | `MADEIRA_NO_SAMPLER=1` apaga el muestreador de hilos integrado, que detiene todos los hilos un momento cada 20 segundos. |
| Mandos | Calibración opcional por software para mandos gastados o con ruido: reposo, zonas muertas, umbral de gatillos, anti-rebote de botones y suavizado de sticks (`MADEIRA_PAD_CAL`). |
| Compilación | Arreglos en los scripts de compilación para las herramientas actuales, incluido Xcode 27. |

El código de todos los cambios es público. Los cambios del emulador, de Wine y
de DXMT están en la rama `bo2` de los forks de esta cuenta de
[FEX](https://github.com/Manudev24/FEX/tree/bo2), [wine](https://github.com/Manudev24/wine/tree/bo2) y
[dxmt](https://github.com/Manudev24/dxmt/tree/bo2), que este repositorio usa como submódulos.

## 1. Instalar la app

1. Descarga `Madeira-BO2-*.ipa` de la página de [Releases](https://github.com/Manudev24/Madeira/releases) de este fork.
2. Instálala con tu propio Apple ID usando SideStore, AltStore, Sideloadly,
   Plume o una herramienta similar. El IPA no está firmado; tu herramienta lo firma.
3. Activa el JIT y comprueba que en **Settings** aparecen marcas verdes en
   **JIT** y **Memory+**, igual que en Madeira original (consulta
   [JIT setup](JIT.md) y el [README](../README.md#installing) principal).

Esta versión usa el mismo identificador de app que Madeira original. Al
instalarla sustituye a Madeira original, pero conserva tus juegos y ajustes.

## 2. Conseguir los archivos del juego

Necesitas Black Ops II con su contenido de Zombies y los packs de mapas de
Zombies que tengas. Elige una de estas formas.

### Opción A: Steam dentro de Madeira

1. En Madeira, inicia sesión en Steam ([Steam sign-in](STEAM_SIGNIN.md)).
2. En la biblioteca, instala Black Ops II y su componente de Zombies. Madeira
   los descarga de Steam a su unidad de Windows.
3. Abre la página del juego y apunta la carpeta de instalación que aparece en
   **Executable**. La usarás en lugar de `C:\BO2` más abajo.

Arrancar la versión de Steam directamente (con Madeira Dock o **The game**) no
se ha probado con este fork. La forma probada de jugar es Plutonium, en el paso
3, usando estos archivos descargados.

### Opción B: copiarlos desde un PC

1. En un PC con Windows, instala Black Ops II desde Steam.
2. Con la app Archivos o el Finder, copia la carpeta del juego a
   **Madeira › wine › drive_c › BO2** en el iPhone.

### Ahorrar espacio (solo Zombies)

El juego completo ocupa unos 17 GB. Para jugar solo Zombies puedes quitar los
archivos de Multijugador y quedarte en unos 11 GB:

- los archivos `zone/all/mp_*` y todos los que terminan en `_mp`;
- `zone/all/mp.ipak`, `patch_mp.ipak`, `mp_frostbite.ipak` y
  `mp_nuketown_2020.ipak`;
- la carpeta `redist`.

Conserva `base.ipak`, `patch.ipak`, `patch_zm.ipak`, `so.ipak` y todos los
`dlczm*.ipak`. Si algún mapa de DLC muestra texturas que faltan, vuelve a
poner `dlc0.ipak` a `dlc4.ipak`.

## 3. Conseguir Plutonium

1. En un PC con Windows, descarga el launcher desde [plutonium.pw](https://plutonium.pw),
   inicia sesión y deja que termine de actualizarse. Respeta las normas y
   condiciones de Plutonium.
2. Copia el contenido de `%LOCALAPPDATA%\Plutonium` (las carpetas `bin`,
   `games`, `storage` y las demás) a **Madeira › wine › drive_c › Plutonium**
   en el iPhone.

No se ha probado a ejecutar el launcher de Plutonium dentro de Madeira.

## 4. Añadir el juego a la biblioteca

1. En Madeira, toca **+** y elige
   `Plutonium\bin\plutonium-bootstrapper-win32.exe`.
2. Abre la entrada nueva y configura:

   | Ajuste | Valor |
   |---|---|
   | **Launch arguments** | `t6zm "C:\BO2" -lan +name "TuNombre"` |
   | **Launch › Start** | **In the Wine desktop** (obligatorio: el cliente no arranca sin esto) |
   | **Launch › Working folder** | `C:\Plutonium` |

   Si instalaste el juego con Steam (opción A), cambia `C:\BO2` por la carpeta
   de instalación del paso 2.

3. En **Advanced › This game's config**, pega:

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

## 5. Jugar

- Pon **Ajustes › Pantalla y brillo › Bloqueo automático** en **Nunca**
  mientras arranca el juego. iOS pausa Madeira al bloquearse la pantalla y el
  juego no lo aguanta.
- El primer arranque tarda alrededor de un minuto y medio hasta el menú.
- En las opciones de audio del juego, pon la configuración de altavoces en
  **Stereo**. También puedes poner `seta snd_speakerConfiguration "Stereo"` en
  `Plutonium\storage\t6\players\plutonium_zm.cfg`. Mezclar audio 5.1 gasta CPU
  sin ningún beneficio en un teléfono.
- Un mando Bluetooth o USB-C en modo Xbox funciona mediante XInput.

## Opcional: calibrar el mando

Si un stick se mueve solo o un gatillo se pulsa solo, añade una línea como esta
a la configuración del juego:

```
env.MADEIRA_PAD_CAL = ldz:0.25,rdz:0.12,ltz:0.60,rtz:0.20,deb:80,lpf:0.50
```

| Clave | Significado |
|---|---|
| `lx`, `ly`, `rx`, `ry` | Valor en reposo de cada eje de stick, que se resta de cada lectura |
| `ldz`, `rdz` | Zona muerta del stick izquierdo y derecho (0 a 0.9); se conserva el recorrido completo |
| `lt`, `rt` | Valor en reposo de cada gatillo |
| `ltz`, `rtz` | Umbral del gatillo (0 a 0.9); por debajo cuenta como suelto |
| `deb` | Anti-rebote de botones en milisegundos: una suelta más corta se ignora |
| `lpf` | Suavizado de sticks (0 a 0.95): más alto filtra más ruido pero añade retardo |

## Problemas conocidos

- Al terminar una partida, el juego puede mostrar un error y hay que
  reiniciarlo. La app sigue funcionando.
- El teléfono se calienta en sesiones largas.
- Solo se ha probado en el iPhone 15 Pro Max.

## Compilar desde el código

Clona con los submódulos y sigue la [guía de compilación](BUILDING.md) original:

```bash
git clone --recurse-submodules -b bo2 https://github.com/Manudev24/Madeira.git
```

Compila la configuración **Debug**. El proyecto original indica que las
versiones Release han hecho fallar los juegos.

## Créditos

[Madeira](https://github.com/willfaust/Madeira) de Will Faust y sus
colaboradores, [FEX-Emu](https://github.com/FEX-Emu/FEX),
[Wine](https://www.winehq.org/), [DXMT](https://github.com/3Shain/DXMT) y
[Plutonium](https://plutonium.pw). Este fork se desarrolló con ayuda de un
asistente de IA (Claude). Sus cambios en el emulador no se envían al proyecto
original, porque FEX-Emu no acepta contribuciones generadas por IA.

La licencia es la misma que la del proyecto original: GPL-3.0-or-later con la
Madeira Converter Exception. Consulta [Licensing](../README.md#licensing).
