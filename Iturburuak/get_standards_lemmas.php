<?php
	include('../header.php');
?>
<script type="text/javascript">
$(document).ready(function()
{
	$('nav li').removeClass('active');
	$("#update").parent().addClass('active');
});
</script>

<?php
	if(!isset($_POST['email']) || !isset($_POST['password'])) {
?>

	<form class="form-signin" method="post">
		<h3 class="form-signin-heading">Sartu erabiltzailea eta pasahitza</h3>

		<label for="inputEmail" class="sr-only">Email address</label>
		<input type="email" name="email" id="inputEmail" class="form-control" placeholder="E-posta" required autofocus>
		
		<label for="inputPassword" class="sr-only">Password</label>
		<input type="password" name="password" id="inputPassword" class="form-control" placeholder="Pasahitza" required>
		
		<button class="btn btn-lg btn-primary btn-block" type="submit">Eguneratu indizeak</button>
	</form>

<?php
	} else {
		include("login.php");
		
		if($login_ok){

			//Testu guztiak biltzen dituen texts.xml fitxategia sortu
			include("get_texts.php");

			$file_name = "only_texts";
		
			//delete old tokenized file
			unlink('texts.xml.tok');
		
			$file = fopen($file_name, "x+");
		
			$xmlDoc = new DOMDocument();
			
			$xmlDoc -> formatOutput = true;
			$xmlDoc -> encoding = 'utf-8';
		
			if($xmlDoc->load('texts.xml')){
				$docs = $xmlDoc->getElementsByTagName("doc"); 
				foreach ($docs as $d){
					$text = $d->getElementsByTagName('field')->item(2)->nodeValue . "\n";
					$text = strtolower(str_replace("ÇÇ", "ç", $text));			
					fputs($file, $text);
				}
			}
			fclose($file);
			
			//tokenize words
			$command = 'perl standard/scriptak/tokenizatu.pl ' . $file_name . ' > ' . $file_name . '.tok';
			//echo $command . "<br>";
			system($command);
			
			//quit repeated words
			$command = 'cat '.$file_name.'.tok | sort | uniq > '.$file_name.'.tmp1';
			//echo $command . "<br>";
			system($command);
			
			//geratzen bada tokenean letra ez den karaktereren bat, baztertu
			$command = "grep -v  [^âêîôûáéíóúàèìòùäëïöüÂÊÎÔÛÁÉÍÓÚÀÈÌÒÙÄËÏÖÜa-zA-ZñÑçÇ'-'] ".$file_name.".tmp1 > ".$file_name.".tmp2";
			system($command);	
			
			//luzerari begira, bi letra gutxienez ez dituztenak, baztertu
			$command = 'grep .. '.$file_name.'.tmp2 > '.$file_name.'.tok.filtered';
			system($command);	
	
			//hitz berriak soilik aztertu
			$command = 'diff indexed_words '.$file_name.'.tok.filtered | grep ">" | cut -d" " -f2 > to-index';
			system($command);
			
			//orain arte indexatutako hitzak zein diren eguneratu
			$command = 'cp '.$file_name.'.tok.filtered indexed_words';
			system($command);
			
			
			//$fitxategiko hitz ez-estandarren hitz estandarrak lortu
			$command = 'sh standard/deia.sh to-index';
			system($command);

			//lemak lortu
			$command = 'cat to-index.phon3 | cut -f 2 | perl stemmer/luzeena.pl > lemmas.txt';
			system($command);
					
			//Lotu jatorrizko hitza, estandarra eta lema
			$command = 'paste -d "\t" to-index.phon3 lemmas.txt > to-index-all';
			system($command);
			
			//create xml document that has indexes
			$xmlIndexes = new DOMDocument();
			$xmlIndexes -> formatOutput = true;
			$xmlIndexes -> encoding = 'utf-8';
			
			//create <add> element
			$add_elem = $xmlIndexes -> createElement("add");
			
			$file = fopen("to-index-all", "r") or exit("Unable to open file!");
		
			while(!feof($file)) {
				
				$line = trim(fgets($file));
				$original = split("\t", $line)[0];
				$standard = split("\t", $line)[1];
				$lemma = split("\t", $line)[2];
				
				if(strpos($original, "www") === false && $original != "" && strlen($original) > 1) {
					//create <doc> element
					$doc_elem = $xmlIndexes -> createElement("doc");	
					$add_elem -> appendChild($doc_elem);
					
					//original		
					$field_elem = $xmlIndexes -> createElement("field");	
					$doc_elem -> appendChild($field_elem);
					
					$orig_attr = $xmlIndexes->createAttribute('name');
					$orig_attr -> value = "original";
					$field_elem -> appendChild($orig_attr);
					
					$field_elem -> appendChild(
						$xmlIndexes -> createTextNode($original));
					$doc_elem -> appendChild($field_elem);	
					
					//standard
					$field_elem = $xmlIndexes -> createElement("field");	
					$doc_elem -> appendChild($field_elem);
					
					$std_attr = $xmlIndexes->createAttribute('name');
					$std_attr -> value = "standard";
					$field_elem -> appendChild($std_attr);
					
					$field_elem -> appendChild(
						$xmlIndexes -> createTextNode($standard));
					$doc_elem -> appendChild($field_elem);	
					
					//lemma
					$field_elem = $xmlIndexes -> createElement("field");	
					$doc_elem -> appendChild($field_elem);
					
					$lemma_attr = $xmlIndexes->createAttribute('name');
					$lemma_attr -> value = "lemma";
					$field_elem -> appendChild($lemma_attr);
					
					$field_elem -> appendChild(
						$xmlIndexes -> createTextNode($lemma));
					$doc_elem -> appendChild($field_elem);	
				}
			}
			
			fclose($file);
		
			$xmlIndexes->appendChild($add_elem);
			$xmlIndexes->saveXML();
			$xmlIndexes->save("indexes.xml");
			
			$command = 'rm to-index* '.$file_name.'*';
			system($command);

			require("../update_texts_indexes.php");
		
		} else {
			echo "<h2>Erabiltzailea edota pasahitz okerrak</h2>";
			echo '<a href="get_standards_lemmas">Saiatu berriro</a>';
		}
	}

	include('../footer.php');
?>
