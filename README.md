# xgs-pont-2 (OpenWrt Kernel 6.6.100)

## Quick Start
Clone the repository:
```sh
git clone https://github.com/brudalevante/xgs-pont-2.git
```
Set the correct permissions:
```sh
chmod 776 -R xgs-pont-2
```
Enter the project directory:
```sh
cd xgs-pont-2
```
Before running the builder, please read all comments in the script!

To start the build process:
```sh
./bpi-r4-openwrt-builder.sh
```






# xgs-pont-2 — OpenWrt custom build for BPI-R4 (woziwrt, MTK, fakemesh 6G)

> **IMPORTANT:** BEFORE RUNNING BUILDER, READ ALL COMMENTS IN THE SCRIPT!

## English

### About this project

This is my **second** public OpenWrt work, a result of months of effort and collaboration with the people and projects listed below.  
This repository compiles OpenWrt with kernel **6.6.100** and the latest MTK and OpenWrt sources as of **15-08-2025**.

#### New features in this release

- Added **luci-app-upnp** for Universal Plug and Play support.
- Added **luci-app-wifischedule** to easily set WiFi schedules at home (for parental control or energy saving).
- All previous improvements and patches maintained.

### What’s solved and included?

- **No more duplicated ports.**
- **No more “disco” LEDs:** Port LEDs only light up when a cable is connected.
- **Custom patches and enhancements applied directly to OpenWrt.**
- **Support for all common SFP+ speeds (1Gb, 2.5Gb, 5Gb, 10Gb):**
  - A custom patch was created within OpenWrt to extend the netdev LED trigger and full SFP+ port support for 1Gb, 2.5Gb, 5Gb, and 10Gb speeds.
  - (WAN/LAN ports only support 1Gb)
  - Now, LEDs and software can correctly detect and indicate the link status at all these speeds.
- **Extra configuration:**
  - Two folders under `config/`: `system` and `network`
  - Customized `my_files/board.json`
- **Mesh-ready with 6 GHz support** (see mesh section below)
- **You can check [my repository](https://github.com/brudalevante/xgs-pont-2.git) or the included images to see all the work and features.**

#### This build features:

- Kernel **6.6.100** (all patches up to date, as of 15-08-2025)
- Advanced LED and port management
- Multi-gigabit (1G, 2.5G, 5G, 10G) SFP+ port support (with netdev LED trigger patch)
- Custom system and network configs
- Mesh with 6G support (“fakemesh”)
- Board-specific adjustments via `board.json`
- **luci-app-upnp** and **luci-app-wifischedule** included by default
- Many more improvements and tested patches

---

## How to build

```sh
git clone https://github.com/brudalevante/xgs-pont-2.git
chmod 776 -R xgs-pont-2
cd xgs-pont-2

# BEFORE RUNNING BUILDER, READ ALL COMMENTS IN THE SCRIPT!
./bpi-r4-openwrt-builder.sh
```

- See the included script (`bpi-r4-openwrt-builder.sh`) for a step-by-step, reproducible build using your own repositories.
- **Use only VERIFIED mainline OpenWrt commits.**
- Not all MTK commits are fully functional or compatible with mainline OpenWrt; may require additional patching.
- Tested on VMware Fusion, Workstation and Hyper-V.

---

## WARNING: BETA VERSION

This repository and its builds are currently **BETA**.  
It works in my environment, but there may be bugs, missing features, or unexpected behaviors.  
Use at your own risk and feel free to report any issues or contribute improvements.

---

## Acknowledgments

Special thanks to **woziwrt** (without your work and patches, this project would not have reached this level).  
Thank you **RafalB82** for the xgs-pon patch for the 8311-was-110, which allows routers to work perfectly with 10G symmetric fiber (up to 8Gbps real).  
Thanks to **GitHub Copilot** for making 6G mesh possible; after months of work, mesh networking is now available on 2G, 5G, and 6G bands!  
All work done within OpenWrt to ensure that port LEDs are only lit when a network cable is connected (and to avoid duplicated ports) is also available for anyone who wants to improve it.

Thanks for all the work so far—there is still much to do, and many ideas to come!

---

## fakemesh introduction

**fakemesh** is a network topology with a controller (AC), one or more wired APs, and satellites (Agent). It combines wireless Mesh and AC+AP modes.  
Wired APs connect via Ethernet, satellites via WiFi as STA clients—enabling seamless coverage (including wired links).

- **Deployment:** Connect each node to the right network, set its role, Mesh ID, and other parameters. fakemesh simplifies building hybrid networks, improving coverage and reliability.
- **Integrated by default!**

**Device Access After Setup:**
- Controller: http://controller.fakemesh/ or http://ac.fakemesh/
- AP: http://{mac}.ap.fakemesh/ or http://N.ap.fakemesh/ (where {mac} is the AP’s MAC and N is an auto-assigned number)

**Troubleshooting:**  
If an AP loses connection for 3+ minutes, it enters failure mode with a default SSID for reconfiguration:
- SSID: mesh-brudalevante
- PASSWORD: 12345678

**Basic Components:**
- Controller (AC): Main router and wireless manager.
- Satellite (Agent): AP connecting by Wi-Fi.
- Wired AP: AP connecting by Ethernet.

**Key Config Parameters:**
- Mesh ID: Must match on all nodes.
- Key: Shared encryption key (leave blank for open).
- Band: 2G, 5G, or 6G; all nodes must match.
- Role: Controller, Satellite, Wired AP.
- Sync Config: Centralized config from controller.
- Access IP address: Management IP for controller.
- Fronthaul Disabled: Prevents this node from acting as uplink for others.
- Band Steer Helper: Choose DAWN or usteer.
- Wireless Management: Manage all wireless (SSIDs, encryption, bandwidth, etc.) from the controller interface.

**Controller in “Bypass” Mode:**  
If the controller is not the gateway or DHCP server, set LAN IP, gateway, and DNS manually. Default is DHCP client. If using static IP, ensure it’s on the same subnet as the gateway for config sync.

---

## Español

### Sobre este proyecto

Este es mi **segundo** trabajo público con OpenWrt, fruto de meses de esfuerzo y colaboración con las personas y proyectos que menciono más abajo.  
El repositorio compila OpenWrt con kernel **6.6.100** y los últimos drivers y fuentes de MTK y OpenWrt a fecha **15-08-2025**.

#### Novedades en esta versión

- Añadido **luci-app-upnp** para soporte UPnP.
- Añadido **luci-app-wifischedule** para programar el horario del WiFi en casa (control parental, ahorro, etc).
- Se mantienen todas las mejoras y parches anteriores.

### ¿Qué incluye y soluciona?

- **Adiós a los puertos duplicados.**
- **Adiós a las luces “de discoteca”:** Los LEDs solo se encienden si hay cable conectado.
- **Parches y mejoras aplicados directamente sobre OpenWrt.**
- **Soporte para todas las velocidades habituales en SFP+ (1Gb, 2,5Gb, 5Gb, 10Gb):**
  - Se ha creado un parche dentro de OpenWrt que extiende el trigger de LEDs y el soporte completo para los puertos SFP+ a 1Gb, 2,5Gb, 5Gb y 10Gb.
  - (Los puertos WAN y LAN solo soportan 1Gb)
  - Ahora los LEDs y el sistema detectan y muestran correctamente el estado de enlace a todas estas velocidades.
- **Configuración extra:**
  - Dos carpetas bajo `config/`: `system` y `network`
  - Incluido y personalizado `my_files/board.json`
- **Mesh preparado con soporte 6GHz** (ver sección mesh abajo)
- **Puedes ver el repositorio o las imágenes para comprobar todo lo que lleva**:  
  [https://github.com/brudalevante/xgs-pont-2.git](https://github.com/brudalevante/xgs-pont-2.git)

#### Características de esta build

- Kernel **6.6.100** (con todos los parches al día, a fecha 15-08-2025)
- Gestión avanzada de LEDs y puertos
- Soporte multigigabit (1G, 2,5G, 5G, 10G) en los puertos SFP+ (con parche en trigger de LEDs netdev)
- Configs system y network personalizadas
- Mesh con soporte para 6G (“fakemesh”)
- Ajustes específicos via `board.json`
- **luci-app-upnp** y **luci-app-wifischedule** incluidos por defecto
- Muchas más mejoras y parches probados

---

## Cómo compilar

```sh
git clone https://github.com/brudalevante/xgs-pont-2.git
chmod 776 -R xgs-pont-2
cd xgs-pont-2

# ¡ANTES DE EJECUTAR EL BUILDER, LEE TODOS LOS COMENTARIOS DEL SCRIPT!
./bpi-r4-openwrt-builder.sh
```

- Consulta el script incluido (`bpi-r4-openwrt-builder.sh`) para una compilación paso a paso y reproducible usando tus propios repositorios.
- **Usa solo commits VERIFICADOS de OpenWrt principal.**
- No todos los commits MTK son funcionales o compatibles con OpenWrt principal; pueden requerir parches extra.
- Probado en VMware Fusion, Workstation y Hyper-V.

---

## AVISO: VERSIÓN BETA

Este repositorio y sus builds están en fase **BETA**.  
Funciona en mi entorno, pero puede contener errores, carecer de funciones o comportarse de forma inesperada.  
Úsalo bajo tu responsabilidad y no dudes en reportar problemas o proponer mejoras.

---

## Agradecimientos

Gracias especialmente a **woziwrt**, sin cuyo trabajo y parches este proyecto no habría llegado tan lejos.  
Gracias a **RafalB82** por el parche xgs-pon para el 8311-was-110, con el que los routers funcionan perfecto con fibra directa 10G simétricas (¡hasta 8G reales!).  
Gracias a **GitHub Copilot** por ayudar a hacer posible el mesh en 6G; tras meses de trabajo, la malla funcional está en bandas 2G, 5G y 6G.  
Todo el trabajo realizado dentro de OpenWrt para que los LEDs de los puertos solo se enciendan cuando se conecta un cable de red (y para evitar puertos duplicados) está disponible para quien quiera mejorarlo.

¡Gracias por todo el trabajo realizado hasta ahora—aún queda mucho por hacer y muchas ideas por delante!

---

## Introducción a fakemesh

**fakemesh** es una topología de red formada por un controlador (AC), uno o más AP cableados y satélites (Agent).  
Combina Mesh inalámbrico y modo AC+AP.  
Los AP cableados se conectan al controlador por Ethernet, los satélites por Wi-Fi como clientes STA—formando una red de cobertura continua (también con enlaces cableados).

- **Despliegue sencillo:** Conecta cada nodo a la red adecuada y configura su rol, Mesh ID y otros parámetros. fakemesh facilita crear una red híbrida, mejorando cobertura y fiabilidad.
- **¡Integrado por defecto!**

**Acceso tras configurar:**
- Controlador: http://controller.fakemesh/ o http://ac.fakemesh/
- AP: http://{mac}.ap.fakemesh/ o http://N.ap.fakemesh/ (donde {mac} es la MAC del AP y N un número autoasignado)

**Resolución de problemas:**  
Si un AP pierde conexión más de 3 minutos, entra en modo fallo con SSID por defecto para reconfiguración:
- SSID: mesh-brudalevante
- CONTRASEÑA: 12345678

**Componentes básicos:**
- Controlador (AC): router principal y gestor inalámbrico.
- Satélite (Agent): AP conectado por Wi-Fi.
- AP cableado: AP conectado por Ethernet.

**Parámetros clave:**
- Mesh ID: igual en todos los nodos.
- Clave: contraseña compartida (dejar en blanco para abierta).
- Banda: 2G, 5G o 6G; todos los nodos deben coincidir.
- Rol: controlador, satélite, AP cableado.
- Sync Config: configuración centralizada desde el controlador.
- Dirección IP de acceso: IP de gestión del controlador.
- Desactivar Fronthaul: impide que otros usen este nodo como uplink.
- Band Steer Helper: elige DAWN o usteer.
- Gestión inalámbrica: Gestiona toda la red (SSIDs, cifrado, ancho de banda, etc.) desde la interfaz del controlador.

**Controlador en modo “Bypass”:**  
Si el controlador no es gateway ni servidor DHCP, configura IP LAN, gateway y DNS manualmente. Por defecto es cliente DHCP. Si usas IP fija, asegúrate de que esté en la misma subred que el gateway para sincronizar la configuración.

---

¡Gracias a todos los que han hecho posible este proyecto!  
Gracias por todo el trabajo realizado hasta ahora—aún queda mucho por hacer y muchas ideas por delante.
