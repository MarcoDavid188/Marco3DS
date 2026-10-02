-- INSTITUTO NACIONAL DE CIUDAD BARRIOS
-- Estudiante: Marco David Amaya Portillo | 3° Año A
-- Módulo BTVDS 3.8 | Docente: Prof. Allan René Romero Granados
-- Fecha: 30 de septiembre de 2026
-- Caso de práctica: tienda de productos de consumo.
-- Datos ficticios. Ejecutar una sola vez en una base sin estas tablas.
-- No se elimina ninguna base ni tabla existente.
-- Orden: categorias, clientes, empleados, productos, ventas, detalle_ventas.

SET NAMES utf8mb4 COLLATE utf8mb4_spanish_ci;
CREATE DATABASE IF NOT EXISTS sig_gerencial_incb
  CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE sig_gerencial_incb;

CREATE TABLE categorias (
  id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre_categoria VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE clientes (
  id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(60) NOT NULL,
  apellido VARCHAR(60) NOT NULL,
  telefono VARCHAR(15) NOT NULL,
  correo VARCHAR(100) NOT NULL UNIQUE,
  direccion VARCHAR(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE empleados (
  id_empleado INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(60) NOT NULL,
  apellido VARCHAR(60) NOT NULL,
  cargo VARCHAR(40) NOT NULL,
  fecha_contratacion DATE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE productos (
  id_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre_producto VARCHAR(100) NOT NULL,
  id_categoria INT UNSIGNED NOT NULL,
  stock INT UNSIGNED NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria)
    REFERENCES categorias(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE ventas (
  id_venta INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT UNSIGNED NOT NULL,
  id_empleado INT UNSIGNED NOT NULL,
  fecha DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente)
    REFERENCES clientes(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_venta_empleado FOREIGN KEY (id_empleado)
    REFERENCES empleados(id_empleado) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE detalle_ventas (
  id_detalle INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_venta INT UNSIGNED NOT NULL,
  id_producto INT UNSIGNED NOT NULL,
  cantidad INT UNSIGNED NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta)
    REFERENCES ventas(id_venta) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- RESTRICT protege los registros referenciados.
-- CASCADE elimina los detalles si se elimina su venta.
-- El precio del detalle conserva el precio aplicado en la fecha de venta.
-- DML: 20 filas por tabla, 120 en total. Una línea de detalle por venta.
START TRANSACTION;

INSERT INTO categorias (id_categoria, nombre_categoria) VALUES
  (1, 'Bebidas'),
  (2, 'Granos básicos'),
  (3, 'Lácteos'),
  (4, 'Panadería'),
  (5, 'Carnes'),
  (6, 'Embutidos'),
  (7, 'Frutas'),
  (8, 'Verduras'),
  (9, 'Limpieza'),
  (10, 'Higiene personal'),
  (11, 'Enlatados'),
  (12, 'Pastas'),
  (13, 'Aceites'),
  (14, 'Condimentos'),
  (15, 'Dulces'),
  (16, 'Galletas'),
  (17, 'Cereales'),
  (18, 'Congelados'),
  (19, 'Café y té'),
  (20, 'Mascotas');

INSERT INTO clientes (id_cliente, nombre, apellido, telefono, correo, direccion) VALUES
  (1, 'Ana', 'García', '7000-0001', 'cliente01@example.com', 'Ciudad Barrios, calle 1'),
  (2, 'Luis', 'López', '7000-0002', 'cliente02@example.com', 'Ciudad Barrios, calle 2'),
  (3, 'María', 'Hernández', '7000-0003', 'cliente03@example.com', 'Ciudad Barrios, calle 3'),
  (4, 'Carlos', 'Martínez', '7000-0004', 'cliente04@example.com', 'Ciudad Barrios, calle 4'),
  (5, 'Sofía', 'Pérez', '7000-0005', 'cliente05@example.com', 'Ciudad Barrios, calle 5'),
  (6, 'José', 'Ramírez', '7000-0006', 'cliente06@example.com', 'Ciudad Barrios, calle 6'),
  (7, 'Valeria', 'Torres', '7000-0007', 'cliente07@example.com', 'Ciudad Barrios, calle 7'),
  (8, 'Diego', 'Flores', '7000-0008', 'cliente08@example.com', 'Ciudad Barrios, calle 8'),
  (9, 'Gabriela', 'Rivera', '7000-0009', 'cliente09@example.com', 'Ciudad Barrios, calle 9'),
  (10, 'Miguel', 'Gómez', '7000-0010', 'cliente10@example.com', 'Ciudad Barrios, calle 10'),
  (11, 'Daniela', 'Díaz', '7000-0011', 'cliente11@example.com', 'Ciudad Barrios, calle 11'),
  (12, 'Andrés', 'Castro', '7000-0012', 'cliente12@example.com', 'Ciudad Barrios, calle 12'),
  (13, 'Lucía', 'Romero', '7000-0013', 'cliente13@example.com', 'Ciudad Barrios, calle 13'),
  (14, 'Fernando', 'Vásquez', '7000-0014', 'cliente14@example.com', 'Ciudad Barrios, calle 14'),
  (15, 'Camila', 'Morales', '7000-0015', 'cliente15@example.com', 'Ciudad Barrios, calle 15'),
  (16, 'Óscar', 'Mendoza', '7000-0016', 'cliente16@example.com', 'Ciudad Barrios, calle 16'),
  (17, 'Paola', 'Ortiz', '7000-0017', 'cliente17@example.com', 'Ciudad Barrios, calle 17'),
  (18, 'Ricardo', 'Cruz', '7000-0018', 'cliente18@example.com', 'Ciudad Barrios, calle 18'),
  (19, 'Elena', 'Reyes', '7000-0019', 'cliente19@example.com', 'Ciudad Barrios, calle 19'),
  (20, 'Jorge', 'Ramos', '7000-0020', 'cliente20@example.com', 'Ciudad Barrios, calle 20');

INSERT INTO empleados (id_empleado, nombre, apellido, cargo, fecha_contratacion) VALUES
  (1, 'Jorge', 'Ramírez', 'Vendedor', '2026-01-01'),
  (2, 'Elena', 'Torres', 'Vendedor', '2026-01-02'),
  (3, 'Ricardo', 'Flores', 'Vendedor', '2026-01-03'),
  (4, 'Paola', 'Rivera', 'Vendedor', '2026-01-04'),
  (5, 'Óscar', 'Gómez', 'Vendedor', '2026-01-05'),
  (6, 'Camila', 'Díaz', 'Vendedor', '2026-01-06'),
  (7, 'Fernando', 'Castro', 'Vendedor', '2026-01-07'),
  (8, 'Lucía', 'Romero', 'Vendedor', '2026-01-08'),
  (9, 'Andrés', 'Vásquez', 'Vendedor', '2026-01-09'),
  (10, 'Daniela', 'Morales', 'Vendedor', '2026-01-10'),
  (11, 'Miguel', 'Mendoza', 'Vendedor', '2026-01-11'),
  (12, 'Gabriela', 'Ortiz', 'Vendedor', '2026-01-12'),
  (13, 'Diego', 'Cruz', 'Vendedor', '2026-01-13'),
  (14, 'Valeria', 'Reyes', 'Vendedor', '2026-01-14'),
  (15, 'José', 'Ramos', 'Vendedor', '2026-01-15'),
  (16, 'Sofía', 'García', 'Vendedor', '2026-01-16'),
  (17, 'Carlos', 'López', 'Vendedor', '2026-01-17'),
  (18, 'María', 'Hernández', 'Vendedor', '2026-01-18'),
  (19, 'Luis', 'Martínez', 'Vendedor', '2026-01-19'),
  (20, 'Ana', 'Pérez', 'Vendedor', '2026-01-20');

INSERT INTO productos (id_producto, nombre_producto, id_categoria, stock, precio_unitario) VALUES
  (1, 'Agua mineral 1 litro', 1, 50, 0.75),
  (2, 'Arroz 1 libra', 2, 51, 0.85),
  (3, 'Leche 1 litro', 3, 52, 1.60),
  (4, 'Pan de caja', 4, 53, 2.25),
  (5, 'Pollo 1 libra', 5, 54, 2.10),
  (6, 'Jamón 250 gramos', 6, 55, 1.80),
  (7, 'Manzana unidad', 7, 56, 0.50),
  (8, 'Tomate 1 libra', 8, 57, 0.90),
  (9, 'Detergente 500 gramos', 9, 58, 1.25),
  (10, 'Jabón de baño', 10, 59, 0.65),
  (11, 'Atún en lata', 11, 60, 1.45),
  (12, 'Espagueti 200 gramos', 12, 61, 0.70),
  (13, 'Aceite vegetal 1 litro', 13, 62, 2.50),
  (14, 'Sal 1 libra', 14, 63, 0.35),
  (15, 'Chocolate barra', 15, 64, 0.80),
  (16, 'Galletas paquete', 16, 65, 0.60),
  (17, 'Avena 400 gramos', 17, 66, 1.75),
  (18, 'Vegetales congelados 500 gramos', 18, 67, 2.30),
  (19, 'Café molido 250 gramos', 19, 68, 3.25),
  (20, 'Alimento para perro 1 libra', 20, 69, 1.95);

INSERT INTO ventas (id_venta, id_cliente, id_empleado, fecha, total) VALUES
  (1, 1, 1, '2026-09-01', 0.75),
  (2, 2, 4, '2026-09-02', 1.70),
  (3, 3, 7, '2026-09-03', 4.80),
  (4, 4, 10, '2026-09-04', 9.00),
  (5, 5, 13, '2026-09-05', 10.50),
  (6, 6, 16, '2026-09-06', 1.80),
  (7, 7, 19, '2026-09-07', 1.00),
  (8, 8, 2, '2026-09-08', 2.70),
  (9, 9, 5, '2026-09-09', 5.00),
  (10, 10, 8, '2026-09-10', 3.25),
  (11, 11, 11, '2026-09-11', 1.45),
  (12, 12, 14, '2026-09-12', 1.40),
  (13, 13, 17, '2026-09-13', 7.50),
  (14, 14, 20, '2026-09-14', 1.40),
  (15, 15, 3, '2026-09-15', 4.00),
  (16, 16, 6, '2026-09-16', 0.60),
  (17, 17, 9, '2026-09-17', 3.50),
  (18, 18, 12, '2026-09-18', 6.90),
  (19, 19, 15, '2026-09-19', 13.00),
  (20, 20, 18, '2026-09-20', 9.75);

INSERT INTO detalle_ventas (id_detalle, id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES
  (1, 1, 1, 1, 0.75, 0.75),
  (2, 2, 2, 2, 0.85, 1.70),
  (3, 3, 3, 3, 1.60, 4.80),
  (4, 4, 4, 4, 2.25, 9.00),
  (5, 5, 5, 5, 2.10, 10.50),
  (6, 6, 6, 1, 1.80, 1.80),
  (7, 7, 7, 2, 0.50, 1.00),
  (8, 8, 8, 3, 0.90, 2.70),
  (9, 9, 9, 4, 1.25, 5.00),
  (10, 10, 10, 5, 0.65, 3.25),
  (11, 11, 11, 1, 1.45, 1.45),
  (12, 12, 12, 2, 0.70, 1.40),
  (13, 13, 13, 3, 2.50, 7.50),
  (14, 14, 14, 4, 0.35, 1.40),
  (15, 15, 15, 5, 0.80, 4.00),
  (16, 16, 16, 1, 0.60, 0.60),
  (17, 17, 17, 2, 1.75, 3.50),
  (18, 18, 18, 3, 2.30, 6.90),
  (19, 19, 19, 4, 3.25, 13.00),
  (20, 20, 20, 5, 1.95, 9.75);

COMMIT;

-- VERIFICACIÓN: cada tabla debe devolver 20 registros.
SELECT 'categorias' AS tabla, COUNT(*) AS registros FROM categorias
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL SELECT 'detalle_ventas', COUNT(*) FROM detalle_ventas;

-- Resultado esperado: 120.
SELECT (SELECT COUNT(*) FROM categorias) + (SELECT COUNT(*) FROM clientes)
     + (SELECT COUNT(*) FROM empleados) + (SELECT COUNT(*) FROM productos)
     + (SELECT COUNT(*) FROM ventas) + (SELECT COUNT(*) FROM detalle_ventas)
       AS total_registros;

-- Resultado esperado: ninguna fila (sin subtotales incorrectos).
SELECT id_detalle, cantidad, precio_unitario, subtotal
FROM detalle_ventas
WHERE subtotal <> cantidad * precio_unitario OR cantidad = 0;

-- Resultado esperado: ninguna fila (sin totales incorrectos ni ventas vacías).
SELECT v.id_venta, v.total, COALESCE(SUM(d.subtotal), 0) AS total_calculado
FROM ventas AS v
LEFT JOIN detalle_ventas AS d ON d.id_venta = v.id_venta
GROUP BY v.id_venta, v.total
HAVING COUNT(d.id_detalle) = 0 OR v.total <> COALESCE(SUM(d.subtotal), 0);

-- Resultado esperado: seis tablas InnoDB con utf8mb4_spanish_ci.
SELECT TABLE_NAME, ENGINE, TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sig_gerencial_incb' AND TABLE_TYPE = 'BASE TABLE';
