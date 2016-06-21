<?php

error_reporting(E_ALL);
ini_set('display_errors', true);

require __DIR__.'/../solarium/vendor/autoload.php';

if (file_exists(__DIR__.'/../config/config.php')) {
    require(__DIR__.'/../config/config.php');
} else {
    require(__DIR__.'/../config/config.dist.php');
}


function htmlHeader()
{
	header('Content-Type: text/html; charset=utf-8');
	echo '<html><head><title>Solarium examples</title></head><body>';
}

function htmlFooter()
{
	echo '</body></html>';
}
