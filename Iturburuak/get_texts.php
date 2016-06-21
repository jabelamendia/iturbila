<?php
include("../includes/error_messages.php");
$ok = true;
$xmlDoc = new DOMDocument();  

//create a results doc
$results_doc = new DOMDocument();
$results_doc -> formatOutput = true;
$results_doc -> encoding = 'utf-8';

//create <add> element
$add_elem = $results_doc -> createElement("add");

echo "<h2>Eguneratu diren testuak:</h2>";
if($xmlDoc->load('../config/texts_links.xml')){
	$texts = $xmlDoc->getElementsByTagName("text"); 

	foreach ($texts as $t){
		$full_title = $t->getElementsByTagName('title')->item(0)->nodeValue;
		$link = $t->getElementsByTagName('link')->item(0)->nodeValue;

		if($full_title!="" && $link!=""){
			if(strpos($link, "wikisource.org") == true) {
				echo "<br>   Titulua='".$full_title."'";
				$api_url = 'https://wikisource.org/w/api.php';
				$url = 'https://wikisource.org/wiki';
			} else {
				if(strpos($link, "iturriak.eus") == true) {
					echo "<br>   Titulua='".$full_title."'";
					$api_url = 'http://www.iturriak.eus/api.php';
					$url = 'http://www.iturriak.eus/index.php';
				} else {
					$ok = false;
				}
			}
			if($ok) {
				if(strpos($link, "http:") === false && strpos($link, "https:") === false){
					$title = split(":", $link)[1];
				} else {
					$title = split(":", $link)[2];
				}
				$get_api = $api_url."?format=xml&action=query&titles=File:$title&prop=imageinfo&iiprop=size";
				//echo $get_api;
				
				$api_result = simplexml_load_file($get_api); 
				$numPages = $api_result->query->pages->page->imageinfo->ii['pagecount'];
				echo "   ;   Kopurua: ".$numPages;

				$j = 0;
				while($j < $numPages) {
					$get_api = $api_url."?format=xml&action=query&titles=";
					$first = true;
					for($i = $j; $i <= min(array($j+49,$numPages)); $i++){
						$get_api .= "Page:$title/$i";
						$first = false;
						if (!$first) $get_api .= "|";
					}
					$get_api = substr($get_api, 0, -1);
					$get_api .= "&prop=revisions&rvprop=content&rawcontinue";
					
					$api_result = simplexml_load_file($get_api);
					
					$pages = $api_result->query->pages;

					foreach ($pages->page as $p){
						$text = $p->revisions->rev;
						
						//Quit HTML tags
						$text = strip_tags($text);
						$text = html_entity_decode($text);
						
						//Quit Wiki marks
						$wiki_marks = array("{","}",'"', "'", "rh|", "|", "\n", "\t", "\r", "center", "larger", "xx-", "x-", "rule",
						"style=","margin-top:", "margin-bottom:", ";", "=", "right", "smaller", "Dotted", "TOC", "listing");
						$text = str_replace($wiki_marks, ' ', $text);
						
						//Quit numbers
						$text = preg_replace('/[0-9]+(px)?/', '', $text);
						
						//Quit djvu words
						$word = "djvu";
						$text = preg_replace('/\W' . $word . '[^\s]+/', '', $text);  
						$text = str_replace("page", '', $text);

						//Quit white spaces
						$text = preg_replace('/\s+/', ' ', $text); 
						$text = preg_replace('/style\s+/', ' ', $text);
						
						if($text != "") {							
							//<doc> elementua sortu
							$doc_elem = $results_doc -> createElement("doc");	
							$add_elem -> appendChild($doc_elem);
							
							//ID (title/page)
							$id = str_replace(" ", "_", $p['title']);
							$field_elem = $results_doc -> createElement("field");	
							$doc_elem -> appendChild($field_elem);
		
							$id_attr = $results_doc->createAttribute('name');
							$id_attr -> value = "id";
							$field_elem -> appendChild($id_attr);
		
							$field_elem -> appendChild(
								$results_doc -> createTextNode($id));
							$doc_elem -> appendChild($field_elem);
							
							//Title
							$field_elem = $results_doc -> createElement("field");	
							$doc_elem -> appendChild($field_elem);
		
							$tit_attr = $results_doc->createAttribute('name');
							$tit_attr -> value = "title";
							$field_elem -> appendChild($tit_attr);
		
							$field_elem -> appendChild(
								$results_doc -> createTextNode($full_title));
							$doc_elem -> appendChild($field_elem);
		
							//Text
							$field_elem = $results_doc -> createElement("field");	
							$doc_elem -> appendChild($field_elem);
		
							$text_attr = $results_doc->createAttribute('name');
							$text_attr -> value = "text";
							$field_elem -> appendChild($text_attr);
		
							$field_elem -> appendChild(
								$results_doc -> createTextNode($text));
							$doc_elem -> appendChild($field_elem);
		
							//Link
							$link = $url."/".$id;
							$field_elem = $results_doc -> createElement("field");	
							$doc_elem -> appendChild($field_elem);
		
							$link_attr = $results_doc->createAttribute('name');
							$link_attr -> value = "link";
							$field_elem -> appendChild($link_attr);
		
							$field_elem -> appendChild(
								$results_doc -> createTextNode($link));
							$doc_elem -> appendChild($field_elem);
							
							//Api link
							$api_link = $api_url."?format=xml&action=query&titles=".$id."&prop=revisions&rvprop=content&rawcontinue";
							$field_elem = $results_doc -> createElement("field");	
							$doc_elem -> appendChild($field_elem);
		
							$api_link_attr = $results_doc->createAttribute('name');
							$api_link_attr -> value = "apilink";
							$field_elem -> appendChild($api_link_attr);
		
							$field_elem -> appendChild(
								$results_doc -> createTextNode($api_link));
							$doc_elem -> appendChild($field_elem);

							//Image link
							$current_page = split("/", $id)[1];
							$new = "page".$current_page;
							
							$api_img = $api_url."?format=xml&action=query&titles=File:".$title."&prop=imageinfo&iiurlparam=".$new."-1024px&iiprop=url";
							
							$field_elem = $results_doc -> createElement("field");	
							$doc_elem -> appendChild($field_elem);
		
							$img_attr = $results_doc->createAttribute('name');
							$img_attr -> value = "apiimg";
							$field_elem -> appendChild($img_attr);
		
							$field_elem -> appendChild(
								$results_doc -> createTextNode($api_img));
							$doc_elem -> appendChild($field_elem);
							
						}
					}
					
					$j += 50;
				}		
			}
		}
	}
	$results_doc->appendChild($add_elem);
	$results_doc->saveXML();
  				$results_doc->save("texts.xml");
	echo "<br><br>";
} else {
	$ok = false;
}
if(!$ok) {
	echo "<h2>$error</h2>";				
}