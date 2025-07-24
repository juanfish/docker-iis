FROM mcr.microsoft.com/windows/servercore/iis

# Instalar características ISAPI necesarias
RUN powershell -Command \
    Install-WindowsFeature Web-ISAPI-Ext, Web-ISAPI-Filter; \
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\InetStp' -Name Enable32BitAppOnWin64 -Value 1

# Crear directorios necesarios
RUN powershell -Command \
    New-Item -Path 'C:\inetpub\isapiapp' -ItemType Directory

# Copiar tu DLL (asegúrate de tener pviewisapi.dll en el mismo directorio que el Dockerfile)
COPY pviewisapi.dll C:/inetpub/isapiapp/pviewisapi.dll

# Configurar aplicación ISAPI (versión corregida)
RUN powershell -Command \
    Import-Module WebAdministration; \
    New-WebAppPool -Name 'PViewPool'; \
    Set-ItemProperty 'IIS:\AppPools\PViewPool' -Name enable32BitAppOnWin64 -Value $true; \
    New-Item 'IIS:\Sites\Default Web Site\isapiapp' -physicalPath 'C:\inetpub\isapiapp' -type Application; \
    Set-ItemProperty 'IIS:\Sites\Default Web Site\isapiapp' -Name applicationPool -Value 'PViewPool'; \
    Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/security/isapiCgiRestriction' -name '.' -value @{path='C:\inetpub\isapiapp\pviewisapi.dll'; allowed='true'; description='PView ISAPI DLL'}; \
    Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/handlers' -name '.' -value @{name='PViewHandler'; path='pviewisapi.dll'; verb='*'; modules='IsapiModule'; scriptProcessor='C:\inetpub\isapiapp\pviewisapi.dll'; resourceType='Unspecified'; requireAccess='Execute'}

EXPOSE 80