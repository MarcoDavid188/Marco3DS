-- INSTITUTO NACIONAL DE CIUDAD BARRIOS (INCB)
-- Estudiante: Marco David Amaya Portillo | 3° Año A
-- Docente: Prof. Allan René Romero Granados | Módulo BTVDS 3.8
-- Fecha: 02 de octubre de 2026
-- Base: estructura de sig_gerencial_2026.sql.
-- Consultas 1-4: matriz de la guía. Consulta 5: micro-reto de tutoría.
-- Consultas 6-8: propuestas complementarias de promedios y subconsultas;
-- los documentos recibidos no enumeran las preguntas oficiales 5-8.
-- No modifica los datos. Todas las columnas no agregadas se agrupan.
-- No se calcula ganancia: faltan costos históricos o una columna ganancia.
-- precio_unitario es precio de venta y NO debe usarse como costo.

USE sig_gerencial_incb;

-- 1. ¿Cuánto dinero total ha ingresado por ventas?
-- Cada detalle se suma una vez; resultado con los datos originales: 90.00.
SELECT ROUND(COALESCE(SUM(dv.subtotal), 0), 2) AS total_ingresos
FROM detalle_ventas AS dv
INNER JOIN productos AS p ON dv.id_producto = p.id_producto;

-- 2. ¿Cuáles son las ventas por categoría?
-- Cadena de tres tablas: detalle -> producto -> categoría.
SELECT c.id_categoria, c.nombre_categoria,
       COUNT(dv.id_detalle) AS lineas_vendidas,
       SUM(dv.cantidad) AS unidades_vendidas,
       ROUND(SUM(dv.subtotal), 2) AS total_ventas
FROM detalle_ventas AS dv
INNER JOIN productos AS p ON dv.id_producto = p.id_producto
INNER JOIN categorias AS c ON p.id_categoria = c.id_categoria
GROUP BY c.id_categoria, c.nombre_categoria
ORDER BY total_ventas DESC, c.id_categoria ASC;

-- 3. ¿Quién es el vendedor con más ventas?
-- Ranking por número de ventas; el importe desempata.
-- Se suman las cabeceras sin enlazar detalles, evitando repetir v.total.
SELECT e.id_empleado, CONCAT(e.nombre, ' ', e.apellido) AS vendedor,
       COUNT(v.id_venta) AS cantidad_ventas,
       ROUND(SUM(v.total), 2) AS total_vendido
FROM empleados AS e
INNER JOIN ventas AS v ON v.id_empleado = e.id_empleado
GROUP BY e.id_empleado, e.nombre, e.apellido
ORDER BY cantidad_ventas DESC, total_vendido DESC, e.id_empleado ASC;

-- 4. ¿Qué categorías superaron los $1,000?
-- HAVING filtra después de sumar. Con los datos originales devuelve cero
-- filas: ninguna categoría alcanza la meta. No se altera la meta ni la data.
SELECT c.id_categoria, c.nombre_categoria,
       ROUND(SUM(dv.subtotal), 2) AS total_ventas
FROM detalle_ventas AS dv
INNER JOIN productos AS p ON dv.id_producto = p.id_producto
INNER JOIN categorias AS c ON p.id_categoria = c.id_categoria
GROUP BY c.id_categoria, c.nombre_categoria
HAVING SUM(dv.subtotal) > 1000
ORDER BY total_ventas DESC, c.id_categoria ASC;

-- 5. Micro-reto: ¿qué cliente ha gastado más?
-- Conteo de compras y monto acumulado; LIMIT 1 selecciona el primer lugar.
SELECT c.id_cliente, CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       COUNT(v.id_venta) AS compras_realizadas,
       ROUND(SUM(v.total), 2) AS monto_acumulado
FROM clientes AS c
INNER JOIN ventas AS v ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido
ORDER BY monto_acumulado DESC, c.id_cliente ASC
LIMIT 1;

-- 6. Propuesta: ¿cuál es el promedio, máximo y mínimo de las ventas?
-- Las estadísticas se calculan por venta, no por línea de detalle.
SELECT COUNT(v.id_venta) AS cantidad_ventas,
       ROUND(AVG(v.total), 2) AS promedio_venta,
       ROUND(MAX(v.total), 2) AS venta_maxima,
       ROUND(MIN(v.total), 2) AS venta_minima
FROM ventas AS v;

-- 7. Propuesta: ¿qué productos recaudaron más que el promedio por producto?
-- La subconsulta calcula primero el total de cada producto vendido y luego
-- su promedio. HAVING compara totales con totales, evitando mezclar niveles.
SELECT p.id_producto, p.nombre_producto, c.nombre_categoria,
       SUM(dv.cantidad) AS unidades_vendidas,
       ROUND(SUM(dv.subtotal), 2) AS total_recaudado
FROM detalle_ventas AS dv
INNER JOIN productos AS p ON dv.id_producto = p.id_producto
INNER JOIN categorias AS c ON p.id_categoria = c.id_categoria
GROUP BY p.id_producto, p.nombre_producto, c.nombre_categoria
HAVING SUM(dv.subtotal) > (
    SELECT AVG(t.total_producto)
    FROM (
        SELECT d.id_producto, SUM(d.subtotal) AS total_producto
        FROM detalle_ventas AS d
        GROUP BY d.id_producto
    ) AS t
)
ORDER BY total_recaudado DESC, p.id_producto ASC;

-- 8. Propuesta: ¿qué vendedores tienen un importe promedio por venta
-- superior al promedio general? Incluye filtro inicial de ventas de 2026.
-- WHERE selecciona ventas; HAVING selecciona vendedores tras agrupar.
SELECT e.id_empleado, CONCAT(e.nombre, ' ', e.apellido) AS vendedor,
       COUNT(v.id_venta) AS cantidad_ventas,
       ROUND(AVG(v.total), 2) AS promedio_por_venta,
       ROUND(SUM(v.total), 2) AS total_vendido
FROM empleados AS e
INNER JOIN ventas AS v ON v.id_empleado = e.id_empleado
WHERE v.fecha >= '2026-01-01' AND v.fecha < '2027-01-01'
GROUP BY e.id_empleado, e.nombre, e.apellido
HAVING AVG(v.total) > (
    SELECT AVG(v2.total)
    FROM ventas AS v2
    WHERE v2.fecha >= '2026-01-01' AND v2.fecha < '2027-01-01'
)
ORDER BY promedio_por_venta DESC, e.id_empleado ASC;
