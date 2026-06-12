<?php

session_start();

if(
!isset($_SESSION["user_id"])
){

header(
"Location:index.php"
);

exit();

}

?>

<!DOCTYPE html>

<html>

<head>

<title>Dashboard</title>

</head>

<body>

<h1>

¡Acceso Autorizado!

</h1>

<p>

Bienvenido

<strong>

<?php

echo
$_SESSION["nombre"];

?>

</strong>

</p>

<p>

Rol:

<?php

echo
$_SESSION["rol"];

?>

</p>

<a href="logout.php">

Cerrar Sesión

</a>

</body>

</html>