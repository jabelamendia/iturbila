<?php

require(__DIR__."/header.php");

$page = isset($_GET['page']) ? $_GET['page'] : 1;
$q = isset($_GET['q']) ? htmlspecialchars($_GET['q']) : false;
$word_type = isset($_GET['wordtype']) ? htmlspecialchars($_GET['wordtype']) : false;
?>
	<form name="search-form" id="search-form" class="form-inline text-center" accept-charset="utf-8" method="get" action="/searchword.php">
		<div class="form-group">
			<label for="q">Bilaketa:</label>
			<input id="q" name="q" class="form-control" type="text" value="<?php echo htmlspecialchars($q, ENT_QUOTES, 'utf-8'); ?>"/>
			</div>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="form-group">
			<label for="wordtype">Mota:</label>
			<select id="wordtype" name="wordtype form-control" class="form-control">
			  <option value="original" <?php if($word_type=="original" || $word_type==false) echo 'selected="selected"'?> >Jatorrizkoa</option>
			  <option value="standard" <?php if($word_type=="standard") echo 'selected="selected"'; ?> >Estandarra</option>
			  <option value="lemma" <?php if($word_type=="lemma") echo 'selected="selected"'; ?> >Lema</option>
			</select>
		</div>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="form-group">
			<button type="submit" class="btn">
				<span class="glyphicon glyphicon-search"></span> <strong>Bilatu</strong>
			</button>
   	</div>
	</form>

	<br>
<?php

if($q && $word_type) {
	include(__DIR__."/includes/error_messages.php");
	include(__DIR__."/includes/do_search.php");
}

require(__DIR__."/footer.php");
?>
