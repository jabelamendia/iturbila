$(document).ready(function()
{
	//htmlspecialchars
	function htmlspecialchars(str) {
		return str.replace('&', '&amp;').replace('%', '&#037;').replace('"', '&quot;').replace("'", '&#039;').replace('<', '&lt;').replace('>', '&gt;');
	}
	
	//Change link format
	$("#search-form").submit(function( event ) {
		var q = $('#q').val();
		var wordtype = $('#wordtype').val();

		if (q && wordtype){
			location.href = '/s/'+wordtype+'/'+htmlspecialchars(q) ;
		}
		event.preventDefault();
	});
		
	//Show all results
	$(".more-results").on( "click", function() {
		var title = $(this).attr('data-title');
		$("div[data-titlenum^='"+title+"']").show();
		$(this).parent().parent().parent().find('.paginator').hide();
		$(this).hide();
	});
	
	//Show first page result
	$("div[data-num='1']").show();
	
	//Show modals
	$("div[id^='modal']").on('show.bs.modal', function (event) {
		var link = $(event.relatedTarget);
		  
		var api = link.data('api');
		var img = link.data('img');
		var originals = link.data('originals');

		var modal = $(this);
		$.post("/includes/get_text_img.php",
		{
			api: api+"&rvparse",
			img: img,
			originals: originals	
		},
		function(data, status){
			var text = $(data).find('text');

			if (text.text() != "") {
				modal.find('.result-text').hide();
				modal.find('.result-text').html(text);
				modal.find('.result-text').slideDown("slow");
			}
			
			var imglink = $(data).find('imglink').text();
			if (imglink != "") {
				img = '<img class="img-responsive" alt="" src="'+imglink+'" />';
				modal.find('.result-img').hide();
				modal.find('.result-img').html(img);
				modal.find('.result-img').slideDown("slow");
			}
		});
	})
	
	//Paginator
	$(".page").on( "click", function() {
		var max = $(this).parent().attr('data-max');

		var title = $(this).attr('data-title');
		var num = $(this).attr('data-num');
		
		//var all = $("div[class^='"+title+"']");
		var all = $("div[data-titlenum^='"+title+"']");
		all.hide();
		
		//var pa = $("div[class='"+title+"']");
		var pa = $("div[data-titlenum='"+title+num+"']");
		pa.show();
		
		if (num==1) {
			$(this).parent().find('.prev').addClass('disabled');
			$(this).parent().find('.prev').attr("data-num", num);
		} else {
			$(this).parent().find('.prev').removeClass('disabled');
			$(this).parent().find('.prev').attr("data-num", parseInt(num)-1);
		}
		
		if (num==max) {
			$(this).parent().find('.next').addClass('disabled');
			$(this).parent().find('.next').attr("data-num", max);
		} else {
			$(this).parent().find('.next').removeClass('disabled');
			$(this).parent().find('.next').attr("data-num", parseInt(num)+1);
		}
		
		$(this).parent().find('.active').removeClass('active');
		
		$(this).parent().find("li[data-num='"+num+"']").addClass('active');
	});
});