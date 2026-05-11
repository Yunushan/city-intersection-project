# Example raw Windows service registration using NSSM. Edit paths per service.
$nssm = "C:\tools\nssm\nssm.exe"
$serviceName = "urban-platform-app-27"
$appPath = "C:\urban-platform\app-27\app-27.exe"
& $nssm install $serviceName $appPath
& $nssm set $serviceName AppDirectory "C:\urban-platform\app-27"
& $nssm set $serviceName Start SERVICE_AUTO_START
& $nssm start $serviceName
