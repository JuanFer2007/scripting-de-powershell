# CREAR BARRA DE PROGRESO:
# Este comando le dice a PowerShell: "Voy a crear una función" (una función es como una receta reutilizable).
# El nombre de nuestra función es "Start-ProgressBar" (Iniciar-BarraDeProgreso).
function Start-ProgressBar {
    [CmdletBinding()]     #CmdletBinding()] es como decirle a PowerShell: "Esta función es profesional y sigue las reglas avanzadas"
    # Esto permite que la función tenga características especiales como mensajes de depuración.
    [CmdletBinding()]
    # "param" significa "parámetros" - son los DATOS que le pasamos a la función cuando la usamos
    # Es como los ingredientes que necesitas darle a una receta
    param (
        [Parameter(Mandatory = $true)] # [Parameter(Mandatory = $true)] significa: "Este dato es OBLIGATORIO, no puedes omitirlo"
        # $Title es una VARIABLE que guardará el título de nuestra barra de progreso
        # El símbolo $ indica que es una variable (como una caja que guarda información)
        $Title,
        
        [Parameter(Mandatory = $true)] # Otro parámetro obligatorio
        # [int] significa que este dato DEBE ser un número entero (1, 2, 3... no 1.5 o "hola")
       
        [int]$Timer  # $Timer guardará cuántos segundos durará la barra de progreso
    )
    
    for ($i = 1; $i -le $Timer; $i++) { # Aquí empieza un BUCLE FOR (ciclo repetitivo)
    # Traducción: "Para $i (un contador) que empieza en 1, mientras sea menor o igual a $Timer, suma 1 cada vez"
    # Ejemplo: si $Timer es 30, esto se repetirá 30 veces (1, 2, 3... hasta 30)
        Start-Sleep -Seconds 1 # Este comando PAUSA el programa por 1 segundo
        # Es como decirle a PowerShell: "Espera 1 segundo antes de continuar"
        $percentComplete = ($i / $Timer) * 100 # Aquí calculamos el PORCENTAJE completado
        # ($i / $Timer) divide el número actual entre el total
        # * 100 lo convierte a porcentaje
        # Ejemplo: si $i=15 y $Timer=30, entonces (15/30)*100 = 50%
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete  # Este comando DIBUJA la barra de progreso en la pantalla
        # -Activity: El título que se muestra arriba
        # -Status: El mensaje que dice cuántos segundos han pasado
        # -PercentComplete: El porcentaje que rellena la barra visual
    }
} 

# Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30 # Aquí EJECUTAMOS (llamamos) la función que creamos arriba
# Le pasamos dos valores:
# - Title: "Test timeout" (el texto que aparecerá en la barra)
# - Timer: 30 (la barra durará 30 segundos)