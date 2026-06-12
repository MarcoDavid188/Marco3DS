<!DOCTYPE html>
<html lang="es">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Acceso al Sistema</title>

<style>

body{
font-family:Arial;
background:#f4f6f9;
display:flex;
justify-content:center;
align-items:center;
height:100vh;
}

.login-card{
background:white;
padding:30px;
border-radius:10px;
width:350px;
}

input{
width:100%;
padding:10px;
margin-bottom:15px;
}

button{
width:100%;
padding:10px;
background:#1e3a8a;
color:white;
border:none;
}

.error{
color:red;
}

</style>

</head>

<body>

<div class="login-card">

<h2>Control de Inventario</h2>

<?php if(isset($_GET["error"])): ?>

<div class="error">
Usuario o contraseña incorrectos
</div>

<?php endif; ?>

<form action="procesar_login.php" method="POST">

<input
type="text"
name="usuario"
placeholder="Usuario"
required>

<input
type="password"
name="password"
placeholder="Contraseña"
required>

<button type="submit">

Iniciar Sesión

</button>

</form>

</div>

</body>

</html>