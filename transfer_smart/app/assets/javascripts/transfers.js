$( document ).on ('turbolinks:load',function(){
	if ($('meta[name=psj').attr('controller') == 'personal_infos'){
		var step  = document.getElementById("step2");
		step.className = "active";
	}else if ($('meta[name=psj').attr('controller') == 'recipient_infos'){
		var step  = document.getElementById("step2");
		step.className = "active";
		step  = document.getElementById("step3");
		step.className = "active";
	}else if ($('meta[name=psj').attr('controller') == 'transfers'){
		var step  = document.getElementById("step2");
		step.className = "active";
		step  = document.getElementById("step3");
		step.className = "active";
		step  = document.getElementById("step4");
		step.className = "active";
	}else{
		return;
	}
});