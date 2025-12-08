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

$textLabel3 = New-Object System.Windows.Forms.Label
$textLabel3.Text = "Input 3:"
$textLabel3.Left = 20
$textLabel3.Top = 100
$textLabel3.Width = 120

############# Textbox 1
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Left = 150
$textBox1.Top = 20
$textBox1.Width = 200

############# Textbox 2
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Left = 150
$textBox2.Top = 60
$textBox2.Width = 200

############# Textbox 3
$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Left = 150
$textBox3.Top = 100
$textBox3.Width = 200

############# Default values
$defaultValue = ""
$textBox1.Text = $defaultValue
$textBox2.Text = $defaultValue
$textBox3.Text = $defaultValue

############# OK Button
$button = New-Object System.Windows.Forms.Button
$button.Left = 360
$button.Top = 140
$button.Width = 100
$button.Text = "OK"

############# Button click event
$button.Add_Click({
    $form.Tag = @{
        Box1 = $textBox1.Text
        Box2 = $textBox2.Text
        Box3 = $textBox3.Text
    }
    $form.Close()
})

############# Add controls
$form.Controls.Add($button)
$form.Controls.Add($textLabel1)
$form.Controls.Add($textLabel2)
$form.Controls.Add($textLabel3)
$form.Controls.Add($textBox1)
$form.Controls.Add($textBox2)
$form.Controls.Add($textBox3)

############# Show dialog
$form.ShowDialog() | Out-Null

############# Return values
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3