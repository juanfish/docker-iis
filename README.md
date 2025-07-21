# IIS ISAPI Docker Container for `pview.dll`

Este repositorio contiene una configuración Docker para alojar una DLL ISAPI (`pview.dll`) desarrollada en Delphi 7, utilizando Microsoft IIS dentro de un contenedor basado en Windows Server Core.

## 📦 Contenido

- `Dockerfile`: Define la imagen Docker que instala IIS, habilita extensiones ISAPI, copia la DLL `pview.dll` y configura el sitio web.
- `pview.dll`: Tu componente ISAPI compilado en Delphi 7 (debe colocarse en el mismo directorio antes de construir la imagen).

## 🚀 ¿Qué hace este contenedor?

- Habilita las extensiones ISAPI en IIS.
- Copia la DLL `pview.dll` al directorio `C:\inetpub\isapiapp`.
- Crea un Application Pool llamado `PViewPool` con soporte de 32 bits habilitado.
- Crea una aplicación web en IIS (`/PView`) que ejecuta la DLL.
- Expone el puerto 80 para acceder al servicio desde el navegador o cliente HTTP.

## ⚙️ Instrucciones de uso

### 1. Clona este repositorio y coloca `pview.dll` en el mismo directorio:

```bash
git clone https://tu-repositorio.git
cd tu-repositorio
# Asegúrate de que pview.dll esté en este directorio
