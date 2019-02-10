var response = "";
var historical_response = "";
$( document ).on ('turbolinks:load',function(){
	if ($('meta[name=psj').attr('controller') != 'users'){
		return;
	}
	$("#base-currency").val("USD");
	var old_currency = $("#base-currency").val();
	$("#base-currency").change(function(){
		var base_currency = $("#base-currency").val();
		var date = new Date();
		var yesterday;
		date.setDate(date.getDate()-1);
		yesterday = date.getFullYear() + '-' + ("0" + (date.getMonth()+1)).slice(-2) + '-' + ("0" + (date.getDate()-1)).slice(-2);
		var api_key = '2c02b1d3c85e4c7d88fbe5dd983d0965';
		$.get('https://openexchangerates.org/api/historical/'+ yesterday +'.json?'+'app_id='+api_key, function(historical_data){
			historical_response = historical_data["rates"];
		});
		
		$.get('https://openexchangerates.org/api/latest.json', {app_id: api_key}, function(data) {
    		response = data["rates"];
			var table = document.getElementById('currencies');
			var rowLength = table.rows.length;
			var first_row =  table.rows[0];
			first_row.cells[0].childNodes[0].data = base_currency;
	  		first_row.cells[1].childNodes[0].data = "1.00 " + base_currency;
	  		first_row.cells[2].childNodes[0].data = "inv. 1.00 " + base_currency;
 			for(var i=1; i<rowLength; i+=1){
		  		var row = table.rows[i];
		 		var target_currency = row.cells[0].firstChild.data;
		 		var value = (response[target_currency] / response[base_currency]);
		 		var historical_value = (historical_response[target_currency] / historical_response[base_currency]);
		  		row.cells[1].childNodes[0].data = value.toFixed(6);
		  		row.cells[2].childNodes[0].data = (1./value).toFixed(6);
		  		row.cells[3].childNodes[0].data = $("#base-currency").val() + "/" + target_currency+"\t\t";
		  		var percent_change = ((value - historical_value) / 100.0).toFixed(6);
		  		var sign = "";
		  		if(percent_change > 0){ sign = "+"; }
		  		row.cells[3].childNodes[1].firstChild.data = "\n\n\n" + sign + "\n " + percent_change +"\n ";		  			
			}
		});
	});
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