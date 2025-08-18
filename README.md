# xgs-pont-2 (OpenWrt Kernel 6.6.100)

## Quick Start

Clone the repository:
```bash
git clone https://github.com/brudalevante/xgs-pont-2-espejo.git
```
Set the correct permissions:
```bash
chmod 776 -R xgs-pont-2-espejo
```
Enter the project directory:
```bash
cd xgs-pont-2-espejo
```
**Before running the builder, please read all comments in the script!**

To start the build process:
```bash
./bpi-r4-openwrt-builder.sh
```

---

## About this project

This is my new public OpenWrt project, the result of months of effort and collaboration with the people and projects listed below.  
This repository compiles OpenWrt with Kernel 6.6.100 and the latest MTK and OpenWrt sources as of 18-08-2025.

---

## Main features of this build

- Kernel 6.6.100 modified OpenWrt (2 patches modified and 1 created to enable multigigabit (1G, 2.5G, 5G, 10G) SFP+ support, as of 18-08-2025)
- Advanced LED and port management
- Multigigabit (1G, 2.5G, 5G, 10G) SFP+ port support
- Custom system and network configs and personalized my_files/board.json
- Mesh with 6G support (“fakemesh”)
- `luci-app-upnp` and `luci-app-wifischedule` included by default
- **CPU load, temperature and hidden sensor monitoring**
- Many more improvements and tested patches

### What's solved and included?

No more duplicated ports.  
No more "disco" LEDs: Port LEDs only light up when a cable is connected.  
Patches and improvements applied directly to OpenWrt.  
Now LEDs and the system correctly detect and show status.  
Advanced LED menu: All LED triggers and actions can be configured in LuCI.  
CPU load and temperature: Widgets added in LuCI.  
Extra configuration:  
- Two folders under config/: system and network  
- Customized my_files/board.json  
Mesh ready with 6GHz support (“fakemesh”, see section below).  
See the repository for the complete feature set.

---

## How to build

```bash
git clone https://github.com/brudalevante/xgs-pont-2-espejo.git
chmod 776 -R xgs-pont-2-espejo
cd xgs-pont-2-espejo

# BEFORE RUNNING BUILDER, READ ALL COMMENTS IN THE SCRIPT!
./bpi-r4-openwrt-builder.sh
```

See the included script (`bpi-r4-openwrt-builder.sh`) for a step-by-step, reproducible build using your own repositories.  
Use only VERIFIED mainline OpenWrt commits.  
Not all MTK commits are fully functional or compatible with mainline OpenWrt; may require additional patching.  
Tested on VMware Fusion, Workstation and Hyper-V.

---

## WARNING: BETA VERSION

This repository and its builds are currently BETA.  
It works in my environment, but there may be bugs, missing features, or unexpected behaviors.  
Use at your own risk and feel free to report any issues or contribute improvements.

---

## CPU Load and Temperature Monitoring

CPU Load Widget: Real-time CPU usage shown in LuCI.  
Temperature Widget: Displays current temperature; advanced users can show hidden sensors for more hardware info.

---

## Introduction to mesh on 2G, 5G and 6G bands

fakemesh is a network topology with a controller (AC), one or more wired APs, and satellites (Agents). It combines wireless Mesh and AC+AP modes.  
Wired APs connect via Ethernet, satellites via WiFi as STA clients—enabling seamless coverage (including wired links).

Deployment: Connect each node to the right network, set its role, Mesh ID, and other parameters. fakemesh simplifies building hybrid networks, improving coverage and reliability.  
Integrated by default!

Device Access After Setup:
- Controller: http://controller.fakemesh/ or http://ac.fakemesh/
- AP: http://{mac}.ap.fakemesh/ or http://N.ap.fakemesh/ (where {mac} is the AP’s MAC and N is an auto-assigned number)

Troubleshooting:  
If an AP loses connection for 3+ minutes, it enters failure mode with a default SSID for reconfiguration:
- SSID: mesh-brudalevante
- PASSWORD: 12345678

Basic Components:
- Controller (AC): Main router and wireless manager.
- Satellite (Agent): AP connecting by Wi-Fi.
- Wired AP: AP connecting by Ethernet.

Key Config Parameters:
- Mesh ID: Must match on all nodes.
- Key: Shared encryption key (leave blank for open).
- Band: 2G, 5G, or 6G; all nodes must match.
- Role: Controller, Satellite, Wired AP.
- Sync Config: Centralized config from controller.
- Access IP address: Management IP for controller.
- Fronthaul Disabled: Prevents this node from acting as uplink for others.
- Band Steer Helper: Choose DAWN or usteer.
- Wireless Management: Manage all wireless (SSIDs, encryption, bandwidth, etc.) from the controller interface.

Controller in “Bypass” Mode:  
If the controller is not the gateway or DHCP server, set LAN IP, gateway, and DNS manually. Default is DHCP client. If using static IP, ensure it’s on the same subnet as the gateway for config sync.

---

## Acknowledgments

Special thanks to woziwrt (without your work and patches, this project would not have reached this level).  https://github.com/woziwrt/bpi-r4-openwrt-builder/tree/main
Thank you RafalB82 for the xgs-pon patch for the 8311-was-110, which allows routers to work perfectly with 10G symmetric fiber (up to 8Gbps real).  
Thanks to GitHub Copilot for making 6G mesh possible; after months of work, mesh networking is now available on 2G, 5G, and 6G bands!  
All work done within OpenWrt to ensure that port LEDs are only lit when a network cable is connected (and to avoid duplicated ports) is also available for anyone who wants to improve it.  
Thanks for all the work so far—there is still much to do, and many ideas to come!

---

# Español

## Sobre este proyecto

Ese es mi nuevo proyecto público con OpenWrt, fruto de meses de esfuerzo y colaboración con las personas y proyectos que menciono más abajo.  
El repositorio compila OpenWrt con kernel 6.6.100 y los últimos drivers y fuentes de MTK y OpenWrt a fecha 18-08-2025.

---

## Características de esta build

- Kernel 6.6.100 modificado Openwrt( modificados 2 parches y creado uno para que soporte multigigabit (1G, 2,5G, 5G, 10G) en los puertos SFP+ , a fecha 18-08-2025) 
- Gestión avanzada de LEDs y puertos
- Soporte multigigabit (1G, 2,5G, 5G, 10G) en los puertos SFP+ 
- Configs system y network y my_files/board.json personalizadas
- Mesh con soporte para 6G (“fakemesh”)
- `luci-app-upnp` y `luci-app-wifischedule` incluidos por defecto
- **Monitorización de carga CPU, temperatura y sensores ocultos**
- Muchas más mejoras y parches probados

### ¿Qué incluye y soluciona?

Adiós a los puertos duplicados.  
Adiós a las luces “de discoteca”: Los LEDs solo se encienden si hay cable conectado.  
Parches y mejoras aplicados directamente sobre OpenWrt.  
Ahora los LEDs y el sistema detectan y muestran correctamente el estado.  
Menú de LEDs avanzado: Todos los triggers y acciones de LEDs se pueden configurar en LuCI.  
Carga de CPU y temperatura: Widgets añadidos en LuCI.  
Configuración extra:  
- Dos carpetas bajo config/: system y network  
- Incluido y personalizado my_files/board.json  
Mesh preparado con soporte 6GHz (“fakemesh”, ver sección abajo)  
Ver el repositorio para comprobar todo lo que lleva.

---

## Cómo compilar

```bash
git clone https://github.com/brudalevante/xgs-pont-2-espejo.git
chmod 776 -R xgs-pont-2-espejo
cd xgs-pont-2-espejo

# ¡ANTES DE EJECUTAR EL BUILDER, LEE TODOS LOS COMENTARIOS DEL SCRIPT!
./bpi-r4-openwrt-builder.sh
```

Consulta el script incluido (`bpi-r4-openwrt-builder.sh`) para una compilación paso a paso y reproducible usando tus propios repositorios.  
Usa solo commits VERIFICADOS de OpenWrt principal.  
No todos los commits MTK son funcionales o compatibles con OpenWrt principal; pueden requerir parches extra.  
Probado en VMware Fusion, Workstation y Hyper-V.

---

## AVISO: VERSIÓN BETA

Este repositorio y sus builds están en fase BETA.  
Funciona en mi entorno, pero puede contener errores, carecer de funciones o comportarse de forma inesperada.  
Úsalo bajo tu responsabilidad y no dudes en reportar problemas o proponer mejoras.

---

## Monitorización CPU y temperatura

Widget de carga de CPU: Uso de CPU en tiempo real en LuCI.  
Widget de temperatura: Muestra la temperatura actual; usuarios avanzados pueden mostrar sensores hardware ocultos para más info.

---

## Introducción a mesh en las bandas 2G, 5G y 6G

fakemesh es una topología de red formada por un controlador (AC), uno o más AP cableados y satélites (Agent).  
Combina Mesh inalámbrico y modo AC+AP.  
Los AP cableados se conectan al controlador por Ethernet, los satélites por Wi-Fi como clientes STA—formando una red de cobertura continua (también con enlaces cableados).

Despliegue sencillo: Conecta cada nodo a la red adecuada y configura su rol, Mesh ID y otros parámetros. fakemesh facilita crear una red híbrida, mejorando cobertura y fiabilidad.  
¡Integrado por defecto!

Acceso tras configurar:
- Controlador: http://controller.fakemesh/ o http://ac.fakemesh/
- AP: http://{mac}.ap.fakemesh/ o http://N.ap.fakemesh/ (donde {mac} es la MAC del AP y N un número autoasignado)

Resolución de problemas:  
Si un AP pierde conexión más de 3 minutos, entra en modo fallo con SSID por defecto para reconfiguración:
- SSID: mesh-brudalevante
- CONTRASEÑA: 12345678

Componentes básicos:
- Controlador (AC): router principal y gestor inalámbrico.
- Satélite (Agent): AP conectado por Wi-Fi.
- AP cableado: AP conectado por Ethernet.

Parámetros clave:
- Mesh ID: igual en todos los nodos.
- Clave: contraseña compartida (dejar en blanco para abierta).
- Banda: 2G, 5G o 6G; todos los nodos deben coincidir.
- Rol: controlador, satélite, AP cableado.
- Sync Config: configuración centralizada desde el controlador.
- Dirección IP de acceso: IP de gestión del controlador.
- Desactivar Fronthaul: impide que otros usen este nodo como uplink.
- Band Steer Helper: elige DAWN o usteer.
- Gestión inalámbrica: Gestiona toda la red (SSIDs, cifrado, ancho de banda, etc.) desde la interfaz del controlador.

Controlador en modo “Bypass”:  
Si el controlador no es gateway ni servidor DHCP, configura IP LAN, gateway y DNS manualmente. Por defecto es cliente DHCP. Si usas IP fija, asegúrate de que esté en la misma subred que el gateway para sincronizar la configuración.

---

## Agradecimientos

Gracias especialmente a woziwrt, sin cuyo trabajo y parches este proyecto no habría llegado tan lejos.  https://github.com/woziwrt/bpi-r4-openwrt-builder/tree/main
Gracias a RafalB82 por el parche xgs-pon para el 8311-was-110, con el que los routers funcionan perfecto con fibra directa 10G simétricas (¡hasta 8G reales!).  
Gracias a GitHub Copilot por ayudar a hacer posible el mesh en 6G; tras meses de trabajo, la malla funcional está en bandas 2G, 5G y 6G.  
Todo el trabajo realizado dentro de OpenWrt para que los LEDs de los puertos solo se enciendan cuando se conecta un cable de red (y para evitar puertos duplicados) está disponible para quien quiera mejorarlo.  
¡Gracias por todo el trabajo realizado hasta ahora—aún queda mucho por hacer y muchas ideas por delante!
