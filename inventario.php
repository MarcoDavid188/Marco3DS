
<?php

session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit();
}

require_once("conexion.php");

// Obtener el término de búsqueda
$busqueda = isset($_GET['buscar']) ? $_GET['buscar'] : '';

if ($busqueda != '') {

    // Buscar por nombre de producto o categoría
    $sql = "SELECT
            p.id,
            p.nombre_producto,
            c.nombre_categoria,
            p.stock,
            p.precio
            FROM productos p
            INNER JOIN categorias c
            ON p.categoria_id = c.id
            WHERE p.nombre_producto LIKE ?
            OR c.nombre_categoria LIKE ?
            ORDER BY p.id ASC";

    // Preparar la consulta
    $stmt = $conn->prepare($sql);

    // Agregar los comodines %
    $param_busqueda = "%" . $busqueda . "%";

    // Vincular los parámetros
    $stmt->bind_param("ss", $param_busqueda, $param_busqueda);

    // Ejecutar consulta
    $stmt->execute();

    // Obtener resultados
    $resultado = $stmt->get_result();

    $stmt->close();

} else {

    // Si no hay búsqueda, mostrar todos los productos
    $sql = "SELECT
            p.id,
            p.nombre_producto,
            c.nombre_categoria,
            p.stock,
            p.precio
            FROM productos p
            INNER JOIN categorias c
            ON p.categoria_id = c.id
            ORDER BY p.id ASC";

    $resultado = $conn->query($sql);
}


?>
<!DOCTYPE html>

<html lang="es">

<head>

<meta charset="UTF-8">

<meta
name="viewport"
content="width=device-width, initial-scale=1.0">

<title>

Inventario

</title>

<style>

body{

font-family:Arial;

background:#f8fafc;

padding:20px;

}

.container{

max-width:1000px;

margin:auto;

background:white;

padding:20px;

border-radius:10px;

}

.header{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:20px;

}

.btn{

background:#ef4444;

color:white;

padding:10px;

text-decoration:none;

border-radius:5px;

}

table{

width:100%;

border-collapse:collapse;

}

th,td{

padding:12px;

border-bottom:1px solid #ddd;

}

th{

background:#f1f5f9;

}

.stock-bajo{

color:red;

font-weight:bold;

}


.btn-eliminar{

background:#ef4444;

color:white;

padding:6px 12px;

text-decoration:none;

border-radius:5px;

font-size:13px;

font-weight:bold;

}

.btn-eliminar:hover{

background:#b91c1c;

}

</style>

</head>

<body>

<div class="container">

<div class="header">

<h2>

Catálogo de Inventario

</h2>

<a href="nuevo_producto.php"
style="
background:#3b82f6;
color:white;
padding:10px;
text-decoration:none;
border-radius:5px;">

+ Nuevo Producto

</a>
<div>

Usuario:

<strong>

<?php
echo $_SESSION["nombre"];
?>

</strong>

<a
href="logout.php"
class="btn">

Cerrar Sesión

</a>

</div>

</div>

<form method="GET">

    <input
        type="text"
        name="buscar"
        placeholder="Buscar producto o categoría..."
    >

    <button type="submit">
        🔎 Buscar
    </button>

    <a href="inventario.php">
        Limpiar
    </a>

</form>
<table>

<thead>

<tr>

<th>Código</th>

<th>Producto</th>

<th>Categoría</th>

<th>Stock</th>

<th>Precio</th>

<th>Acciones</th>

</tr>

</thead>

<tbody>

<?php

if($resultado->num_rows>0){

while(
$fila=
$resultado->fetch_assoc()
){

$claseStock=

(
$fila["stock"]<10
)

?

"stock-bajo"

:

"";

?>

<tr>

<td>

<?php echo $fila["id"]; ?>

</td>

<td>

<?php echo $fila["nombre_producto"]; ?>

</td>

<td>

<?php echo $fila["nombre_categoria"]; ?>

</td>

<td class="<?php echo $claseStock; ?>">

<?php echo $fila["stock"]; ?>

unds.

</td>

<td>

$

<?php

echo number_format(
$fila["precio"],
2
);

?>

</td>
<td>

<a href="eliminar_producto.php?id=<?php echo $fila['id']; ?>"

class="btn-eliminar"

onclick="return confirm('¿Estás seguro de eliminar el producto: <?php echo $fila['nombre_producto']; ?>?');">

🗑️ Eliminar

</a>

</td>
</tr>

<?php

}

}else{

?>

<tr>

<td colspan="6">

No hay productos registrados.

</td>

</tr>

<?php

}

?>

</tbody>

</table>

</div>

</body>

</html>
```
