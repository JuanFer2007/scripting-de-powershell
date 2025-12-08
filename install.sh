###################################
# Prerequisites

# Update the list of packages
sudo apt-get update #  actualiza la "lista de catálogo" de todos los programas disponibles en tu sistema.
# Es como refrescar la página antes de buscar algo nuevo.

# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common # Aquí instalamos 3 herramientas que necesitaremos después:
# - wget: es como un "descargador" de archivos desde internet
# - apt-transport-https: permite descargar cosas de forma segura (encriptada)
# - software-properties-common: herramientas para manejar "tiendas" de programa

# Get the version of Ubuntu
source /etc/os-release # Este comando lee un archivo del sistema que dice qué versión de Ubuntu tienes
# (por ejemplo: Ubuntu 20.04, 22.04, etc.). Lo necesitamos para el siguiente paso.

# Download the Microsoft repository keys
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb # Descargamos un archivo especial de Microsoft. Este archivo es como una "llave"
# que le dice a tu computadora: "Hey, confía en los programas que vienen de Microsoft"
# El $VERSION_ID se reemplaza automáticamente con tu versión de Ubuntu.

# Register the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb 

# Delete the Microsoft repository keys file
rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com
sudo apt-get update

###################################
# Install PowerShell
sudo apt-get install -y powershell

# Start PowerShell
pwsh