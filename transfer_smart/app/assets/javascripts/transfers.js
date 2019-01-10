$( document ).on ('turbolinks:load',function(){
	if ($('meta[name=psj').attr('controller') == 'personal_infos'){
		var x  = document.getElementById("step2");
		x.className = "active";
	}else if ($('meta[name=psj').attr('controller') == 'recipient_infos'){
		var x  = document.getElementById("step3");
		x.className = "active";
	}else{
		return;
	}
});