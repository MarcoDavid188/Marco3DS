<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit();
}

require_once("conexion.php");

if (isset($_GET['id'])) {

    $id_producto = (int) $_GET['id'];

    $sql = "DELETE FROM productos WHERE id = ?";

    if ($stmt = $conn->prepare($sql)) {

        $stmt->bind_param("i", $id_producto);

        if ($stmt->execute()) {

            $stmt->close();

            header("Location: inventario.php");
            exit();

        } else {
            die("Error al ejecutar DELETE: " . $stmt->error);
        }

    } else {
        die("Error en prepare(): " . $conn->error);
    }

} else {

    die("No se recibió ID");
}
?>