
USE sistema_inventario;


CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL
);


CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria_id INT NOT NULL,
    stock INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,

    
INSERT INTO categorias (nombre_categoria)
VALUES
('Computadoras'),
('Accesorios'),
('Oficina');


INSERT INTO productos
(nombre_producto, categoria_id, stock, precio)
VALUES
('Laptop Dell Inspiron 15', 1, 15, 720.00),
('Mouse Inalambrico Logitech', 2, 25, 12.00);


SELECT p.id,
       p.nombre_producto,
       c.nombre_categoria,
       p.stock,
       p.precio
FROM productos p
INNER JOIN categorias c
ON p.categoria_id = c.id;

SELECT p.id,
       p.nombre_producto,
       c.nombre_categoria,
       p.stock,
       p.precio
FROM productos p
INNER JOIN categorias c
ON p.categoria_id = c.id
WHERE c.nombre_categoria = 'Accesorios';


SELECT * FROM productos;


SELECT * FROM categorias;




SELECT p.nombre_producto,
       c.nombre_categoria,
       p.precio
FROM productos p
INNER JOIN categorias c
ON p.categoria_id = c.id;
-- ====================================================================
-- CONSULTAS DE ESTADÍSTICAS Y MÉTRICAS PARA EL DASHBOARD (Guía 12)
-- ====================================================================

-- Tarjeta 1
SELECT COUNT(id) AS total_productos_catalogo
FROM productos;

-- Tarjeta 2
SELECT SUM(precio * stock) AS valor_monetario_inventario
FROM productos;

-- Tarjeta 3
SELECT MAX(precio) AS producto_mas_caro
FROM productos;

-- Tarjeta 4
SELECT c.nombre_categoria,
SUM(p.stock) AS existencias_totales
FROM productos p
INNER JOIN categorias c
ON p.categoria_id = c.id
GROUP BY c.nombre_categoria;
-- Tabla de proveedores
CREATE TABLE proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empresa VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    direccion TEXT
);

-- Proveedores de prueba
INSERT INTO proveedores 
(nombre_empresa, contacto, telefono, direccion) 
VALUES 
('Tech Data El Salvador', 'Juan Pérez', '2255-8899', 'San Salvador, Col. Escalón'),
('Distribuidora de Papel', 'María Gómez', '2666-4433', 'San Miguel, Centro');
CREATE TABLE compras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proveedor_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
CREATE TABLE detalle_compras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    compra_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_compra DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (compra_id) REFERENCES compras(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);