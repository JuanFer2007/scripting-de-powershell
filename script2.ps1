#INTERFAZ GRAFICA DE USUARIO

Add-Type -AssemblyName System.Windows.Forms# "Add-Type" es como instalar/activar herramientas adicionales en PowerShell
# "-AssemblyName" significa "el nombre del paquete de herramientas"
# "System.Windows.Forms" es una librería que contiene todo lo necesario para crear ventanas,
# botones, cajas de texto, etc. Es como un kit de construcción para interfaces gráficas.
Add-Type -AssemblyName System.Drawing # "System.Drawing" es otra librería que maneja todo lo relacionado con gráficos:
# tamaños, colores, posiciones en la pantalla, etc.

# Create form
$form = New-Object System.Windows.Forms.Form # "New-Object" significa "crear un objeto nuevo" (en este caso, una ventana/formulario)
# "$form" es una variable que guardará nuestra ventana
# Es como decir: "Voy a construir una ventana y la llamaré $form"
$form.Text = "Input Form" # La propiedad ".Text" define el TÍTULO que aparece en la barra superior de la ventana
$form.Size = New-Object System.Drawing.Size(500,250) # ".Size" define el TAMAÑO de la ventana
# New-Object System.Drawing.Size(ancho, alto) crea un tamaño de 500 píxeles de ancho x 250 de alto
# Es como decir: "Esta ventana medirá 500x250 píxeles"
$form.StartPosition = "CenterScreen" # ".StartPosition" define DÓNDE aparecerá la ventana cuando se abra
# "CenterScreen" significa que aparecerá en el CENTRO de tu pantalla

############# Define labels
$textLabel1 = New-Object System.Windows.Forms.Label # Crear la primera etiqueta (un texto que dice "Input 1:")
$textLabel1.Text = "Input 1:" # El texto que mostrará esta etiqueta
$textLabel1.Left = 20 # ".Left" define la posición HORIZONTAL (desde la izquierda)
# 20 píxeles desde el borde izquierdo de la ventana
$textLabel1.Top = 20  # ".Top" define la posición VERTICAL (desde arriba)
# 20 píxeles desde el borde superior de la ventana
$textLabel1.Width = 120  # ".Width" es el ANCHO de la etiqueta
# 120 píxeles de ancho
# Igual que la primera etiqueta pero en diferente posicion 
$textLabel2 = New-Object System.Windows.Forms.Label
$textLabel2.Text = "Input 2:"
$textLabel2.Left = 20                                    # Más abajo que la primera (60 en lugar de 20)
$textLabel2.Top = 60
$textLabel2.Width = 120

#Tercer Etiqueta
$textLabel3 = New-Object System.Windows.Forms.Label
$textLabel3.Text = "Input 3:"
$textLabel3.Left = 20                                    # Aún más abajo (100 píxeles desde arriba)
$textLabel3.Top = 100
$textLabel3.Width = 120

############# Textbox 1
# Crear la primera caja de texto
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Left = 150 # Posición horizontal: 150 píxeles desde la izquierda
# (esto la coloca A LA DERECHA de la etiqueta "Input 1:")
$textBox1.Top = 20  # Posición vertical: 20 píxeles (misma altura que la etiqueta 1)
$textBox1.Width = 200  # Ancho de la caja: 200 píxeles

############# Textbox 2
# Segunda caja de texto (misma idea, diferente posición vertical)
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Left = 150
$textBox2.Top = 60        # Alineada con la etiqueta 2
$textBox2.Width = 200

############# Textbox 3
# Tercera caja de texto
$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Left = 150
$textBox3.Top = 100      # Alineada con la etiqueta 3
$textBox3.Width = 200

############# Default values
# Creamos una variable con un texto vacío "" (nada)
# Esto es lo que aparecerá en las cajas cuando se abra la ventana
$defaultValue = ""
# Asignamos el valor vacío a cada caja de texto
# ".Text" es la propiedad que contiene lo que está escrito en la caja
$textBox1.Text = $defaultValue
$textBox2.Text = $defaultValue
$textBox3.Text = $defaultValue

############# OK Button
# Crear un botón
$button = New-Object System.Windows.Forms.Button
# Posición horizontal del botón: 360 píxeles desde la izquierda
$button.Left = 360
# Posición vertical: 140 píxeles desde arriba
$button.Top = 140
# Ancho del botón: 100 píxeles
$button.Width = 100
# El texto que aparecerá DENTRO del botón
$button.Text = "OK"

############# Button click event
# ".Add_Click" significa "cuando alguien haga clic en este botón, ejecuta este código"
# Todo lo que está entre { } se ejecutará cuando presionen el botón
$button.Add_Click({
   # "$form.Tag" es como una "mochila secreta" del formulario donde podemos guardar datos
    # "@{}" crea un "hashtable" (como un diccionario con pares clave-valor)
    # Estamos guardando los 3 textos que escribió el usuario
    $form.Tag = @{
        Box1 = $textBox1.Text  # Guardamos lo que dice la caja 1
        Box2 = $textBox2.Text  # Guardamos lo que dice la caja 2
        Box3 = $textBox3.Text  # Guardamos lo que dice la caja 3
    }
    $form.Close() # "$form.Close()" CIERRA la ventana (como hacer clic en la X)
})

############# Add controls
$form.Controls.Add($button) # Agregar el botón
$form.Controls.Add($textLabel1)  # Agregar la etiqueta 1
$form.Controls.Add($textLabel2) # Agregar la etiqueta 2
$form.Controls.Add($textLabel3) # Agregar la etiqueta 3
$form.Controls.Add($textBox1)  # Agregar la caja de texto 1
$form.Controls.Add($textBox2)  # Agregar la caja de texto 2
$form.Controls.Add($textBox3)  # Agregar la caja de texto 3

############# Show dialog
# ".ShowDialog()" MUESTRA la ventana en pantalla y ESPERA hasta que se cierre
# Es como decir: "Abre la ventana y no continues con el código hasta que el usuario la cierre"
# "| Out-Null" significa "ignora el valor de retorno" (no lo necesitamos)
$form.ShowDialog() | Out-Null

############# Return values
# "return" significa "esta función/script devuelve estos valores"
# Estamos devolviendo los 3 textos que el usuario escribió en las cajas
# Los sacamos de la "mochila" ($form.Tag) donde los guardamos antes
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3