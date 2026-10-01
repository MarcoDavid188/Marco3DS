<?php
session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit();
}

require_once 'conexion.php';

$compra_id = intval($_GET['id'] ?? 0);

if ($compra_id <= 0) {
    header("Location: historial_compras.php");
    exit();
}

// Consultar los datos generales de la compra.
$sql_cabecera = "SELECT
                    c.id,
                    c.fecha,
                    c.total,
                    p.nombre_empresa,
                    u.nombre_completo
                FROM compras c
                INNER JOIN proveedores p ON c.proveedor_id = p.id
                INNER JOIN usuarios u ON c.usuario_id = u.id
                WHERE c.id = ?";

$stmt_cab = $conn->prepare($sql_cabecera);
$stmt_cab->bind_param("i", $compra_id);
$stmt_cab->execute();

$res_cabecera = $stmt_cab->get_result();

if ($res_cabecera->num_rows === 0) {
    $stmt_cab->close();
    header("Location: historial_compras.php");
    exit();
}

$compra = $res_cabecera->fetch_assoc();
$stmt_cab->close();

// Consultar los productos de esta compra.
$sql_detalle = "SELECT
                    p.nombre_producto,
                    d.cantidad,
                    d.precio_compra,
                    (d.cantidad * d.precio_compra) AS subtotal
                FROM detalle_compras d
                INNER JOIN productos p ON d.producto_id = p.id
                WHERE d.compra_id = ?";

$stmt_det = $conn->prepare($sql_detalle);
$stmt_det->bind_param("i", $compra_id);
$stmt_det->execute();

$res_detalle = $stmt_det->get_result();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Compra</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            padding: 20px;
        }

        .contenedor {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
        }

        .btn-volver {
            display: inline-block;
            background: #64748b;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
        }

        .datos-compra {
            background: #e2e8f0;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #1e293b;
            color: white;
        }

        .total {
            text-align: right;
            font-size: 22px;
            font-weight: bold;
            color: #059669;
            margin-top: 20px;
        }
    </style>
</head>

<body>
<div class="contenedor">

    <a href="historial_compras.php" class="btn-volver">
        ← Volver al Historial
    </a>

    <h2>Detalle de Compra N.º <?php echo $compra['id']; ?></h2>

    <div class="datos-compra">
        <p>
            <strong>Proveedor:</strong>
            <?php echo htmlspecialchars($compra['nombre_empresa'], ENT_QUOTES, 'UTF-8'); ?>
        </p>

        <p>
            <strong>Fecha:</strong>
            <?php echo htmlspecialchars($compra['fecha'], ENT_QUOTES, 'UTF-8'); ?>
        </p>

        <p>
            <strong>Registrado por:</strong>
            <?php echo htmlspecialchars($compra['nombre_completo'], ENT_QUOTES, 'UTF-8'); ?>
        </p>
    </div>

    <h3>Productos ingresados</h3>

    <table>
        <thead>
            <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Costo Unitario</th>
                <th>Subtotal</th>
            </tr>
        </thead>

        <tbody>
            <?php if ($res_detalle->num_rows > 0): ?>
                <?php while ($item = $res_detalle->fetch_assoc()): ?>
                    <tr>
                        <td>
                            <?php echo htmlspecialchars($item['nombre_producto'], ENT_QUOTES, 'UTF-8'); ?>
                        </td>
                        <td><?php echo $item['cantidad']; ?></td>
                        <td>
                            $<?php echo number_format($item['precio_compra'], 2); ?>
                        </td>
                        <td>
                            $<?php echo number_format($item['subtotal'], 2); ?>
                        </td>
                    </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr>
                    <td colspan="4">
                        No se encontraron productos para esta compra.
                    </td>
                </tr>
            <?php endif; ?>
        </tbody>
    </table>

    <div class="total">
        Total Liquidado: $<?php echo number_format($compra['total'], 2); ?>
    </div>

</div>
</body>
</html>

<?php
$stmt_det->close();
?>
