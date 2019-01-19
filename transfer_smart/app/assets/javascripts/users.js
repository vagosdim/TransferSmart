$( document ).on ('turbolinks:load',function(){
	if ($('meta[name=psj').attr('controller') != 'users'){
		return;
	}
	percent_changes = $(".percent_change");
	$(".percent_change").each(function(element){
		
		if($(this).text().includes('-')){
			$(this).css('color', 'red');
		}else{
			$(this).css('color', 'green');
			str = $(this).text();
			str = "+" + str;
		}
	});
});