<?php
	$email = $_POST['email'];
	$password = $_POST['password'];

	require("../config/config.php");
	
	if($admin_user==$email && $admin_pwd_sha1==sha1($password))
		$login_ok=true;
	else
		$login_ok=false;