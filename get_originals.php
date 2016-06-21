<?php
// create a client instance
$client = new Solarium\Client($config_indexes);	

// get a select query instance
$query = $client->createSelect();
$query->setQuery($word_type.":".$q);

// set start and rows param using fluent interface
$query->setStart(0)->setRows(200);

// this executes the query and returns the result
try{
	$resultset = $client->select($query);
} catch(Exception $e){
    echo 'Errore bat gertatu da. Saiatu berriro mesedez.';
    $ok = 0;
}
if($ok) {
	if($resultset->getNumFound()>0) {
		$results = true;
		//$originals = array();
		// show documents using the resultset iterator
		foreach ($resultset as $document) {
			foreach ($document as $field => $value) {
				if($field=="original") {
					$originals[] = $value;
				}
			}	
		}
		
	} else {
		//No results
		$results_indexes = false;
	}
}