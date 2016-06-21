<?php
require('init.php');

$ok = 1;
$total = 0;
$results_indexes = true;
$results_docs = true;
$its_original = false;
$originals = array();

if($word_type == "original") {
	$its_original = true;
	$originals[] = $q;
} else {
	//emaitza: originals[] arraya, bilaketaren jatorrizko hitzak dituena
	require("get_originals.php");
}
if($results_indexes || $its_original) {
	$first = true;
	$query_originals = "";
	foreach ($originals as $o){
		if(!$first) $query_originals .= " ";
		$first = false;
		$query_originals .= "text:\"" . $o . "\"";
	}
	
	$serialized = serialize($originals);

	//echo "<b>Egingo den bilaketa: </b>". $query_originals."<br>";
	
	// create a client instance
	$client = new Solarium\Client($config_docs);

	// get a select query instance
	$query = $client->createSelect();
	$query->setQuery($query_originals);
	
	
	$hl = $query->getHighlighting();
	$hl->setFields('text');
	$hl->setSimplePrefix('<span class="highlight">');
	$hl->setSimplePostfix('</span>');
	
	// get grouping component and set a field to group by
	$groupComponent = $query->getGrouping();
	$groupComponent->addField('title');
	
	// maximum number of items per group
	$groupComponent->setLimit(100);
	
	// get a group count
	$groupComponent->setNumberOfGroups(true);

	// this executes the query and returns the result
	try{
		$resultset = $client->select($query);
	} catch(Exception $e){
	    echo $error;
	    $ok = 0;
	}

	if($ok){
		$groups = $resultset->getGrouping();

		$highlighting = $resultset->getHighlighting();
		
		$k = 0; //collapse id's
		$j = 0; //modal id's
		foreach($groups AS $groupKey => $fieldGroup) {
			if($fieldGroup->getMatches() > 0) {
				$matches = $fieldGroup->getMatches();
				
				//echo 'Guztira: ';
				if($matches == 1) {
					echo 'Emaitza '.$matches.', ';
				} else {
					echo $matches.' emaitza, ';
				}
				
				$numberOfGroups = $fieldGroup->getNumberOfGroups();
				
				if($numberOfGroups == 1) {
					echo 'testu '.$numberOfGroups.'ean<br><br>';
				} else {
					echo $numberOfGroups.' testutan<br><br>';
				}
			
				echo "<div class='panel-group' id='accordion'>";
				foreach($fieldGroup AS $valueGroup) {
					
					$title = $valueGroup->getValue();
					$title_wtspace = str_replace(" ", "-", $title);
					$numFound = $valueGroup->getNumFound();
			
					echo "<div class='panel panel-default'>";
					echo "<div class='panel-heading'>
								<h3 class='panel-title'>
									<a data-toggle='collapse' data-target='#".$title_wtspace."' href='javascript:void(0);'>	
									".$title . ' [' . $numFound . '] ' . "</a>
								</h3>
							</div><!-- end panel-heading -->";	
					echo "<div id='".$title_wtspace."' class='panel-collapse collapse in'>
								<div class='panel-body'>";
					
					if($numFound % $max_number_results_to_show == 0) {
						$nPages = intval($numFound / $max_number_results_to_show);
					} else {
						$nPages = intval($numFound / $max_number_results_to_show) + 1;
					}
					//echo "nPages: ". $nPages;
							
					$grp_nFound = 0;
					$first_time = true;
					foreach($valueGroup AS $document) {
			         
						// the documents are also iterable, to get all fields
						foreach($document AS $field => $value)
						{
							switch($field) {
								case "id":
									$id = $value;
									break;
								case "title":
									$title = $value;
									break;
								case "text":
									$text = $value;
									break;
								case "link":
									$link = $value;
									break;
								case "apilink":
									$apilink = $value;
									break;
								case "apiimg":
									$apiimg = $value;
									break;    		
							}
						}
						
						if($grp_nFound % $max_number_results_to_show == 0) {
							if(!$first_time) echo "</div>";
							
							$page = ($grp_nFound / $max_number_results_to_show) + 1;
							echo "<div data-titlenum='$title_wtspace$page' data-num='$page' hidden>";

							$first_time = false;
						}
						
						$highlightedDoc = $highlighting->getResult($document->id);
		
						if ($highlightedDoc) {
							foreach ($highlightedDoc as $field => $highlight) {
								echo "
									<p class='text-center'>
										<a onclick='return false;' href='' data-toggle='modal' data-originals='".$serialized."' data-target='#modal".$j."' data-api='".$apilink."' data-img='".$apiimg."'>...". substr($highlight[0],1) ."...</a><br>
									</p>";
									
								//$api_result = simplexml_load_file($apilink."&rvparse");
								//$text_formated = $api_result->query->pages->page->revisions->rev;
							
								//$highlighted = $text_formated;
								$highlighted = $text;
								foreach ($originals as $o){
									$keys = explode(" ",$o); 
									$key = array_unique($keys);
									$num = count($key);
									for($i=0; $i < $num; $i++){
										$separator = "(\b)";					
										$highlighted = preg_replace("/(".$separator.$key[$i].$separator.")/i","<mark>\\1</mark>",$highlighted);									
									}									
								}
								
								if(strpos($link,'iturriak') === false)
									$source_name="Wikisource";
								else 
									$source_name="Iturriak";
								
								echo '
									<!-- Modal -->
									<div id="modal'.$j.'" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog">
									  <div class="modal-dialog modal-lg">
									    <div class="modal-content">
									
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal">&times;</button>
													<h4 class="modal-title">'.$title.'</h4>
												</div> <!-- end modal-header -->
												
												<div class="modal-body">
													<div class="row">
														<div class="col-md-6 result-text">'.$highlighted.'</div>
														<div class="col-md-6 result-img">
															<img class="img-responsive" alt="" src="/imgs/loading.gif" />
														</div>
													</div>
												</div> <!-- end modal-body -->
												
												<div class="modal-footer">Iturria: 
													<a href='.$link.' target="_blank">'.$source_name.'</a>
												</div> <!-- end modal-footer -->
												
											</div> <!-- end modal-content -->
										</div> <!-- end modal-dialog -->
									</div> <!-- end modal -->';
										
							}
						}
						$j++;
						$grp_nFound++;
					}
					echo "</div> <!-- end hidden pages -->";
					
					echo '
						<nav class="text-center paginator">
							<ul class="pagination pagination-sm" data-max="'.$nPages.'">
								<li data-num="1" data-title="'.$title_wtspace.'" class="prev disabled page">
									<a href="javascript:void(0);" aria-label="Previous">
									<span aria-hidden="true">&laquo;</span>
									</a>
								</li>';
								
					for($i = 1; $i <= $nPages; $i++) {
						echo '<li data-num="'.$i.'" data-title="'.$title_wtspace.'" class="page';
						if($i == 1) echo " active";
						echo '"><a href="javascript:void(0);">'.$i.'</a></li>';
					}
					
					if ($nPages == 1) $num = 1; else $num = 2;
					echo '	<li data-num="'.$num.'" data-title="'.$title_wtspace.'" class="next';
									if ($nPages == 1) echo " disabled";
					echo '		page">
									<a href="javascript:void(0);" aria-label="Next">
									<span aria-hidden="true">&raquo;</span>
									</a>
								</li>';
								
					if($grp_nFound > $max_number_results_to_show){		
						echo '
						<li class="more-results" data-title="'.$title_wtspace.'">
							<a href="javascript:void(0);">
								<span class="glyphicon glyphicon-plus" aria-hidden="true"></span> <b>Ikusi guztiak</b>
							</a>
						</li>';
					}
					
					echo '
							</ul>
						</nav>';

					echo "		</div> <!-- end panel-body -->
								</div> <!-- end panel-collapse -->
							</div> <!-- end panel-default -->";
					$k++;
				}
				echo "</div> <!-- end panel-group -->";
			} else {
				$results_docs = false;
			}
		}
	}
}

if($results_indexes==false || $results_docs==false) {
	echo "<h1>$not_results</h1>";
}

?>
