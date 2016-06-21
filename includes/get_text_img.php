<?php

echo "<?xml version='1.0' encoding='utf-8' ?>";

$get_api = $_POST['api'];
$get_img = $_POST['img'];
$originals = unserialize($_POST['originals']);

$api_result = simplexml_load_file($get_api); 
$text_formatted = $api_result->query->pages->page->revisions->rev;

$highlighted = $text_formatted;
foreach ($originals as $o){
	$keys = explode(" ",$o); 
	$key = array_unique($keys);
	$num = count($key);
	for($i=0; $i < $num; $i++){
		$separator = "(\b)";					
		$highlighted = preg_replace("/(".$separator.$key[$i].$separator.")/i","<mark>\\1</mark>",$highlighted);									
	}								
}
								
								
echo "<result>";
echo "<text>".$highlighted."</text>";

$api_result = simplexml_load_file($get_img); 
$img = $api_result->query->pages->page->imageinfo->ii['thumburl'];
if($img !="") {
	echo "<imglink>".$img."</imglink>";
} else {
	echo "<imglink>/imgs/not_image.png</imglink>"; 
}


echo "</result>";
?>