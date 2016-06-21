<?php

require(__DIR__.'/includes/init.php');

//UPDATE TEXTS

// create a client instance
$client = new Solarium\Client($config_docs);

// get an update query instance
$update = $client->createUpdate();

$xmlDoc = new DOMDocument();
if($xmlDoc->load('texts.xml')){
	$array = array();
	$docs = $xmlDoc->getElementsByTagName("doc"); 
	foreach ($docs as $d){
		
		$doc1 = $update->createDocument();
		
		$fields = $d->getElementsByTagName('field');
		$doc1->id = $fields->item(0)->nodeValue;
		$doc1->title = $fields->item(1)->nodeValue;
		$doc1->text = $fields->item(2)->nodeValue;
		$doc1->link = $fields->item(3)->nodeValue;
		$doc1->apilink = $fields->item(4)->nodeValue;
		$doc1->apiimg = $fields->item(5)->nodeValue;
		
		$array[] = $doc1;
	}
	
	// add the documents and a commit command to the update query
	$update->addDocuments($array);
	$update->addCommit();
	
	// this executes the query and returns the result
	$result = $client->update($update);
	
	echo '<h3>Testuak ongi eguneratu dira!</h3>';
} else {
	echo "EZ"; 
}


//UPDATE INDEXES

// create a client instance
$client = new Solarium\Client($config_indexes);

// get an update query instance
$update = $client->createUpdate();

$xmlDoc = new DOMDocument();
if($xmlDoc->load('indexes.xml')){
	$array = array();
	$docs = $xmlDoc->getElementsByTagName("doc"); 
	foreach ($docs as $d){
		
		$doc1 = $update->createDocument();
		
		$fields = $d->getElementsByTagName('field');
		$doc1->original = $fields->item(0)->nodeValue;
		$doc1->standard = $fields->item(1)->nodeValue;
		$doc1->lemma = $fields->item(2)->nodeValue;
		
		$array[] = $doc1;
	}
	
	// add the documents and a commit command to the update query
	$update->addDocuments($array);
	$update->addCommit();
	
	// this executes the query and returns the result
	$result = $client->update($update);
	
	echo '<h3>Indizeak ongi eguneratu dira!</h3>';
} else {
	echo "Errorea indizeak eguneratzean!";
}

?>