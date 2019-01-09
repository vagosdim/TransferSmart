var response;
var form_fields;
var receiving_ammount;
var sending_ammount;

$( document ).on ('turbolinks:load',function(){
	if ($('meta[name=psj').attr('controller') != 'exchange_infos'){
		return;
	}
	console.log( "ready!" );
    form_fields = document.getElementsByClassName("form-control");
    receiving_ammount = form_fields["exchange_info[receiving_ammount]"];
    sending_ammount = form_fields["exchange_info[sending_ammount]"];


    receiving_ammount.onmousedown = function(){
    	console.log("READY");
	  	var node_list_from = document.getElementsByName("exchange_info[currency_from]");
		var currency_from = node_list_from[0];

		var node_list_to = document.getElementsByName("exchange_info[currency_to]");
		var currency_to = node_list_to[0];

		$.get('https://openexchangerates.org/api/latest.json?symbols=EUR,GBP&app_id=2c02b1d3c85e4c7d88fbe5dd983d0965', function(data){
        console.log(data);
        response = data;

        var from = response["rates"]["EUR"];
        var to = response["rates"]["GBP"];

        receiving_ammount.value =  (to/from)*sending_ammount.value;
        
     });
  };
});