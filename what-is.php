<?php

include("header.php");

?>

<script type="text/javascript">
$(document).ready(function()
{
	$('nav li').removeClass('active');
	$("#what-is").parent().addClass('active');
});
</script>


<h1 class="newfont">Zer da?</h1>

<div class="row">
  <div class="col-md-2"></div>
  
  <div class="col-md-8 text-center">
  
	<p>Gradu Amaierako Proiektu bat da, zeinetan testu historikoak biltzen dituzten Wikisource eta Iturriak webguneez baliatuz,
	mota ezberdinetako bilaketak egin ahal izatea eskainiko digun.</p>
	
	<p>
	Testu historikoetako hitzak ez-estandarrak izan ohi direnez, aurretik garatutako normalizazio-sistema
	baten bitartez, hitz horri loturiko hitz estandarra lortzen da eta baita estandar horren lema ere.
	</p>
	
	<p>
	Normalizazio-sistema hori Phonetisaurus tresnan oinarritzen da eta, informazioa berreskuratzeko
	Lucenen oinarritutako pache Solr erabiltzen da.
	</p>

	</div>
	<div class="col-md-2"></div>
	

<?php

include("footer.php");

?>