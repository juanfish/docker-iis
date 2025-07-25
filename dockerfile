FROM mcr.microsoft.com/windows/servercore/iis

# Instalar características necesarias de IIS
RUN powershell -NoProfile -Command \
    Install-WindowsFeature Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Metabase

# Crear carpeta donde estará la DLL
RUN powershell -NoProfile -Command \
    New-Item -Path 'C:\inetpub\isapiapp' -ItemType Directory

# Copiar la DLL
COPY pviewisapi.dll C:/inetpub/isapiapp/pviewisapi.dll

# Configurar permisos en la carpeta y DLL
RUN powershell -NoProfile -Command \
    icacls 'C:\inetpub\isapiapp' /grant 'IIS_IUSRS:(RX)' && \
    icacls 'C:\inetpub\isapiapp\pviewisapi.dll' /grant 'IIS_IUSRS:(RX)'

# Configuración de IIS
RUN C:\Windows\System32\inetsrv\appcmd add apppool /name:"PViewPool" /managedRuntimeVersion:"" /managedPipelineMode:"Classic" && \
    C:\Windows\System32\inetsrv\appcmd set apppool "PViewPool" /enable32BitAppOnWin64:true && \
    C:\Windows\System32\inetsrv\appcmd add app /site.name:"Default Web Site" /path:/isapiapp /physicalPath:"C:\inetpub\isapiapp" /applicationPool:"PViewPool" && \
    C:\Windows\System32\inetsrv\appcmd set config "Default Web Site/isapiapp" /section:handlers /+[name='PViewHandler',path='pviewisapi.dll',verb='*',modules='IsapiModule',scriptProcessor='C:\inetpub\isapiapp\pviewisapi.dll',resourceType='Unspecified',requireAccess='Execute'] && \
    C:\Windows\System32\inetsrv\appcmd set config /section:isapiCgiRestriction /+[path='C:\inetpub\isapiapp\pviewisapi.dll',description='PView ISAPI DLL',allowed='true'] && \
    C:\Windows\System32\inetsrv\appcmd set config "Default Web Site/isapiapp" -section:system.webServer/security/isapiCgiRestriction /notListedIsapisAllowed:"true" && \
    C:\Windows\System32\inetsrv\appcmd set config "Default Web Site/isapiapp" /section:system.webServer/security/authentication/anonymousAuthentication /enabled:"true" /userName:"IUSR" && \
    C:\Windows\System32\inetsrv\appcmd set config "Default Web Site/isapiapp" /section:system.webServer/directoryBrowse /enabled:"false" && \
    C:\Windows\System32\inetsrv\appcmd set config "Default Web Site/isapiapp" /section:system.webServer/security/access /sslFlags:"None" /accessFlags:"Execute"

# Configurar autenticación anónima para el pool
RUN powershell -NoProfile -Command \
    Import-Module WebAdministration; \
    Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/anonymousAuthentication" -Name userName -Value "" -PSPath "IIS:\\" -Location "Default Web Site/isapiapp"

EXPOSE 80