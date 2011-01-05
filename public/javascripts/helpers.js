$(document).ready(function() {
	var csrf = $('#csrf-token').val();
	var current_site = 1;	
		$('a').click(function(){
			$('#error').html("")
			$('#notice').html("")
			if( $(this).attr('id').search(/site/i) == 0)
			{
				var site_id = $(this).attr('id').split("_")[1];
				current_site = site_id;
				$.post("/bookmarks/list", {authenticity_token: csrf, site: site_id}, function(data){
					data = data.replace(/BOOK/, "");
					$('#mainDisplay').slideUp('slow', function () {
					$('#mainDisplay').html(data);
					});
					$('#mainDisplay').slideDown('slow');
				 });
			}
			if($(this).attr('id').search(/new_bookmark/i) == 0)
			{
				$.get("/bookmarks/index?new=1", {authenticity_token: csrf}, function(data){
					$('#mainDisplay').slideUp('slow', function () {
					$('#mainDisplay').html(data);
					});
					$('#mainDisplay').slideDown('slow');
				 });
			}
			return false;
		});
		
		$('#bookmark_query').keyup(function(){
			$('#error').html("")
			$('#notice').html("")
			var query = ""
			query = $("#bookmark_query").val()
			if(query == "")
			{
				$.post("/bookmarks/list", {authenticity_token: csrf, site: current_site}, function(data){
					data = data.replace(/BOOK/, "");
					$('#mainDisplay').slideUp('slow', function () {
					$('#mainDisplay').html(data);
					});
					$('#mainDisplay').slideDown('slow');
				 });
			}
			else
			{
				$.post("/bookmarks/search", {authenticity_token: csrf, query: query}, function(data){
					data = data.replace(/BOOK/, "");
					$('#mainDisplay').html(data);

				 });
			}
		
		});


});