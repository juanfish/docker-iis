# IIS ISAPI Docker Container for `pviewISAPI.dll`

> 🔹 **Requisitos previos**: Antes de comenzar, asegúrate de tener configurado tu entorno Docker para contenedores Windows siguiendo la [guía oficial de Microsoft](https://learn.microsoft.com/es-es/virtualization/windowscontainers/quick-start/set-up-environment?tabs=dockerce). Necesitarás:
> - Windows 10/11 Pro/Enterprise o Windows Server 2016+
> - Docker Engine instalado y configurado para contenedores Windows
> - Habilitar la característica "Contenedores" en Windows

Este repositorio contiene una configuración Docker para alojar una DLL ISAPI (`pviewISAPI.dll`) desarrollada en Delphi 7, utilizando Microsoft IIS dentro de un contenedor basado en Windows Server Core.

## 📦 Contenido

- `Dockerfile`: Define la imagen Docker que instala IIS, habilita extensiones ISAPI, copia la DLL `pviewISAPI.dll` y configura el sitio web.
- `pviewISAPI.dll`: Tu componente ISAPI compilado en Delphi 7 (debe colocarse en el mismo directorio antes de construir la imagen).

## 🚀 ¿Qué hace este contenedor?

- Habilita las extensiones ISAPI en IIS.
- Copia la DLL `pviewISAPI.dll` al directorio `C:\inetpub\isapiapp`.
- Crea un Application Pool llamado `pviewISAPIPool` con soporte de 32 bits habilitado.
- Crea una aplicación web en IIS (`/pviewISAPI`) que ejecuta la DLL.
- Expone el puerto 80 para acceder al servicio desde el navegador o cliente HTTP.

## ⚙️ Instrucciones de uso

### 1. Clona este repositorio y coloca `pviewISAPI.dll` en el mismo directorio:

```bash
git clone https://tu-repositorio.git
cd tu-repositorio
# Asegúrate de que pviewISAPI.dll esté en este directorio