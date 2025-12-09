#CREANDO SISTEMA DE LOGUEO
# Un sistema de "logueo" (logging) es como un DIARIO donde tu programa escribe
# todo lo que va haciendo: errores, advertencias, información importante, etc.

# Creamos una función llamada "New-FolderCreation" (Nueva-Creación-De-Carpeta)
# Su trabajo es: crear una carpeta si no existe
function New-FolderCreation {
     # [CmdletBinding()] hace que esta función sea "profesional" y siga reglas avanzadas
    [CmdletBinding()]   
    # Definimos los parámetros (datos que necesita la función)
    param(  
        # Este parámetro es OBLIGATORIO (Mandatory = $true)
        # [string] significa que DEBE ser texto
        # $foldername guardará el NOMBRE de la carpeta que queremos crear
        [Parameter(Mandatory = $true)]
        [string]$foldername
    )

    # Create absolute path for the folder relative to current location
    # Join-Path UNE dos rutas de carpetas de forma correcta
    # (Get-Location).Path obtiene la UBICACIÓN ACTUAL donde estás en PowerShell
    # -ChildPath $foldername es el nombre de la carpeta que queremos crear
    # Ejemplo: si estás en C:\Users\Juan y $foldername="logs", 
    # entonces $logpath será C:\Users\Juan\logs
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername
    # Test-Path verifica si una carpeta/archivo EXISTE
    # -not lo invierte: "si NO existe"
    # Traducción: "Si la carpeta NO existe..."
    if (-not (Test-Path -Path $logpath)) {
        # New-Item CREA algo nuevo (archivo o carpeta)
        # -ItemType Directory significa "crea una CARPETA (directorio)"
        # -Force significa "créala aunque haya problemas menores"
        # | Out-Null significa "no muestres nada en pantalla"
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null
    }
    # return DEVUELVE el resultado (en este caso, la ruta completa de la carpeta)
    # Así otras partes del código pueden saber dónde está la carpeta
    return $logpath
}
# Esta es la función PRINCIPAL del sistema de logging
# Puede hacer DOS cosas: (1) CREAR archivos de log, (2) ESCRIBIR mensajes en los logs
function Write-Log {
    [CmdletBinding()]
    # Esta función tiene DOS "modos" diferentes de funcionar (Parameter Sets)
    # Modo 1: 'Create' para CREAR archivos de log
    # Modo 2: 'Message' para ESCRIBIR mensajes en un log existente
    param(
        # Create parameter set
        # Este parámetro pertenece al modo 'Create'
        # [Alias('Names')] significa que también puedes llamarlo "Names" en lugar de "Name"
        # [object] significa que puede ser CUALQUIER tipo de dato (texto, lista, etc.)
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [Alias('Names')]
        [object]$Name,                    # puede ser un solo texto o una lista de textos
# La EXTENSIÓN del archivo (por ejemplo: "log", "txt")
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$Ext,
# El nombre de la CARPETA donde guardar los logs
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$folder,
 # [switch] es como una casilla de verificación: activado o desactivado
        # -Create es una "bandera" que indica "quiero CREAR un archivo"
        # Position = 0 significa que puede ser el primer parámetro sin nombre
        [Parameter(ParameterSetName = 'Create', Position = 0)]
        [switch]$Create,

      # El MENSAJE que queremos escribir en el log
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$message,
# La RUTA del archivo donde escribir el mensaje
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$path,
# La GRAVEDAD del mensaje (qué tan importante/serio es)
        # [ValidateSet(...)] significa "solo puede ser uno de estos valores"
        # Si no especificas, por defecto será 'Information'
        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information',
# Bandera que indica "quiero ESCRIBIR un mensaje"
        [Parameter(ParameterSetName = 'Message', Position = 0)]
        [switch]$MSG
    )
  # switch es como un "selector" que decide qué código ejecutar
    # $PsCmdlet.ParameterSetName te dice qué MODO se está usando ('Create' o 'Message')
    switch ($PsCmdlet.ParameterSetName) {
        "Create" {
              # Creamos una lista vacía para guardar las rutas de los archivos creados
            $created = @()

            # Normalizamos $Name a una LISTA (array)
            # Esto es porque $Name puede ser un solo texto O una lista de textos
            # Queremos tratarlo siempre como lista para simplificar el código
            $namesArray = @()
            if ($null -ne $Name) {
                  # Si $Name NO es nulo (tiene algo)...
                if ($Name -is [System.Array]) { $namesArray = $Name }
                # Si $Name YA ES una lista, úsala directamente
                else { $namesArray = @($Name) }
            }

             # Formateamos la FECHA actual en formato seguro para nombres de archivo
            # "yyyy-MM-dd" produce algo como "2024-12-08"
            $date1 = (Get-Date -Format "yyyy-MM-dd")
            # Formateamos la HORA actual
            # "HH-mm-ss" produce algo como "14-30-45" (2:30:45 PM)
            $time  = (Get-Date -Format "HH-mm-ss")
            # Formateamos la HORA actual
            # "HH-mm-ss" produce algo como "14-30-45" (2:30:45 PM)
            $time  = (Get-Date -Format "HH-mm-ss")
            # Aseguramos que la carpeta existe y obtenemos su ruta completa
            # Llamamos a nuestra función New-FolderCreation que creamos arriba
            $folderPath = New-FolderCreation -foldername $folder
            # foreach es un BUCLE que repite código para cada elemento de una lista
            # Traducción: "Para cada nombre ($n) en la lista ($namesArray)..."
            foreach ($n in $namesArray) {
                 # Convertimos el nombre a texto (por si acaso era otro tipo de dato)
                # [string] fuerza la conversión a texto
                $baseName = [string]$n

                # Construimos el NOMBRE COMPLETO del archivo
                # Formato: NombreBase_FECHA_HORA.extension
                # Ejemplo: "MiLog_2024-12-08_14-30-45.log"
                $fileName = "${baseName}_${date1}_${time}.$Ext"

                # Join-Path une la ruta de la carpeta con el nombre del archivo
                # Ejemplo: "C:\Users\Juan\logs\MiLog_2024-12-08_14-30-45.log"
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName

                # try-catch es para MANEJAR ERRORES
                # try = "intenta hacer esto"
                # catch = "si falla, haz esto otro"
                try {
                    # New-Item CREA el archivo
                    # -ItemType File = tipo archivo (no carpeta)
                    # -Force = créalo aunque exista (lo sobrescribe)
                    # -ErrorAction Stop = si hay error, salta al catch
                    # | Out-Null = no muestres nada en pantalla
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null

                    # (Líneas comentadas que podrías activar)
                    # Escribirían una línea de encabezado en el archivo:
                    # "Log created: 08/12/2024 14:30:45"
                    # "Log created: $(Get-Date)" | Out-File -FilePath $fullPath -Encoding UTF8 -Append

                    # Agregamos la ruta del archivo creado a nuestra lista de éxitos
                    # += significa "agregar a la lista"

                    $created += $fullPath
                }
                catch {
                     # Si algo salió mal, mostramos una ADVERTENCIA
                    # $_ contiene información sobre el error que ocurrió
                    Write-Warning "Failed to create file '$fullPath' - $_"
                }
            }
             # Devolvemos la LISTA de todos los archivos que creamos exitosamente
            return $created
        }

        "Message" {
            # Split-Path -Parent obtiene la carpeta que CONTIENE el archivo
            # Ejemplo: si $path = "C:\logs\archivo.log", entonces $parent = "C:\logs"
            $parent = Split-Path -Path $path -Parent
            # Si hay una carpeta padre Y esa carpeta NO existe.
            if ($parent -and -not (Test-Path -Path $parent)) {
                # Créala (para que podamos guardar el archivo ahí)

                New-Item -Path $parent -ItemType Directory -Force | Out-Null
            }

            $date = Get-Date  # Obtenemos la fecha y hora ACTUAL completa
            # Construimos el mensaje COMPLETO con formato especial
            # Formato: |FECHA| |MENSAJE| |GRAVEDAD|
            # Ejemplo: "|08/12/2024 14:30:45| |Proceso iniciado| |Information|"
            $concatmessage = "|$date| |$message| |$Severity|"
            # Mostramos el mensaje en PANTALLA con COLORES según su gravedad

            switch ($Severity) {
                # Si es información: color VERDE
                "Information" { Write-Host $concatmessage -ForegroundColor Green }
                 # Si es advertencia: color AMARILLO
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow }
                # Si es error: color ROJO
                "Error"       { Write-Host $concatmessage -ForegroundColor Red }
            }

           # Add-Content AGREGA texto al final de un archivo
            # -Force crea el archivo si no existe
            # Es como abrir un cuaderno y escribir al final
            Add-Content -Path $path -Value $concatmessage -Force

            return $path  # Devolvemos la ruta del archivo donde escribimos
        }

        default {
            # throw lanza un ERROR que detiene el programa
            # Esto NO debería pasar nunca si usamos la función correctamente
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)"
        }
    }
}

# ---------- Example usage ---------
# Llamamos a Write-Log en MODO CREATE para crear un archivo de log
# -Name: el nombre base del archivo será "Name-Log"
# -folder: se creará en la carpeta "logs"
# -Ext: la extensión será ".log"
# -Create: activamos el modo de creación
# El resultado se guarda en $logPaths (será una lista con las rutas de archivos creados)
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create
# Mostramos en pantalla las rutas de los archivos creados
# Esto te permite ver dónde se guardó tu archivo de log
$logPaths