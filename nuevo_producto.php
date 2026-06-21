<?php
session_start();

if (!isset($_SESSION['user_id'])) {
header("Location: index.php");
exit();
}

require_once 'conexion.php';
?>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Registrar Producto</title>

<style>

body{
font-family:Arial;
background:#f8fafc;
padding:20px;
}

.container{
max-width:500px;
margin:auto;
background:white;
padding:30px;
border-radius:8px;
}

.form-group{
margin-bottom:15px;
}

label{
display:block;
margin-bottom:5px;
font-weight:bold;
}

input,select{
width:100%;
padding:10px;
}

button{
width:100%;
padding:10px;
background:#10b981;
color:white;
border:none;
}

</style>

</head>

<body>

<div class="container">

<a href="inventario.php">
← Volver
</a>

<h2>Registrar Nuevo Producto</h2>

<form action="guardar_producto.php" method="POST">

<div class="form-group">

<label>Nombre:</label>

<input
type="text"
name="nombre"
required>

</div>

<div class="form-group">

<label>Categoría:</label>

<select name="categoria" required>

<option value="">
Seleccione
</option>

<?php

$sql="SELECT id,nombre_categoria
FROM categorias
ORDER BY nombre_categoria";

$resultado=$conn->query($sql);

while($cat=$resultado->fetch_assoc()){

echo "<option value='".$cat['id']."'>".$cat['nombre_categoria']."</option>";

}

?>

</select>

</div>

<div class="form-group">

<label>Stock:</label>

<input
type="number"
name="stock"
required>

</div>

<div class="form-group">

<label>Precio:</label>

<input
type="number"
step="0.01"
name="precio"
required>

</div>

<button type="submit">

Guardar Producto

</button>

</form>

</div>

</body>

</html>