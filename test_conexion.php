<?php

require_once 'conexion.php';

try {

    $query = "SELECT p.nombre_producto, p.precio, p.stock FROM productos p";

    $result = $conn->query($query);

    echo "<h1>Conexión Exitosa</h1>";

    echo "<ul>";

    while ($prod = $result->fetch_assoc()) {

        echo "<li>
        " . $prod['nombre_producto'] . "
        - $" . $prod['precio'] . "
        - Stock: " . $prod['stock'] . "
        </li>";

    }

    echo "</ul>";

    $result->free();

} catch (mysqli_sql_exception $e) {

    echo "Error: " . $e->getMessage();

}

?>