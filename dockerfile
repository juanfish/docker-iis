# Imagen base con IIS
FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019

# Habilitar extensiones ISAPI
RUN powershell -NoProfile -Command "dism /online /enable-feature /all /featurename:IIS-ISAPIFilter /NoRestart; dism /online /enable-feature /all /featurename:IIS-ISAPIExtensions /NoRestart"

# Crear directorio para la aplicación ISAPI
RUN mkdir C:\inetpub\isapiapp

# Copiar la DLL ISAPI al contenedor
COPY pview.dll C:\inetpub\isapiapp\

# Configurar IIS
RUN powershell -NoProfile -Command "Import-Module WebAdministration; \
    New-WebAppPool -Name 'PViewPool'; \
    Set-ItemProperty IIS:\AppPools\PViewPool -Name enable32BitAppOnWin64 -Value true; \
    New-WebApplication -Name 'PView' -Site 'Default Web Site' -PhysicalPath 'C:\inetpub\isapiapp' -ApplicationPool 'PViewPool'; \
    Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/security/isapiCgiRestriction' -name '.' -value @{path='C:\inetpub\isapiapp\pview.dll'; allowed='true'; description='PView ISAPI DLL'}; \
    Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/handlers' -name '.' -value @{name='PViewHandler'; path='pview.dll'; verb='*'; modules='IsapiModule'; scriptProcessor='C:\inetpub\isapiapp\pview.dll'; resourceType='Unspecified'; requireAccess='Execute'}"

# Exponer el puerto HTTP
EXPOSE 80
