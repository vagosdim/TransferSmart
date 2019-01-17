var response;
var form_fields;
var receiving_ammount;
var sending_ammount;

//CAUTION
/*DO NOT DELETE THE COMMENTS!!!!!!

USing Alternative api for testing only!!!!!!

No tests with EUR only with GBP and US!!!

Need to change USD to US for the original API!!!!
*/

$( document ).on ('turbolinks:load',function(){
	if ($('meta[name=psj').attr('controller') != 'exchange_infos'){
		return;
	}
    receiving_ammount = document.getElementById("exchange_info_receiving_ammount");
    sending_ammount = document.getElementById("exchange_info_sending_ammount");

    sending_ammount.onchange = function(){
    	console.log("Getting Api Open-Exchange-Rates");
		var currency_from = document.getElementById("exchange_info_currency_from");
		var currency_to = document.getElementById("exchange_info_currency_to");
        var url = 'https://openexchangerates.org/api/latest.json?';//'https://api.exchangeratesapi.io/latest?';//'
        var api_key = '2c02b1d3c85e4c7d88fbe5dd983d0965';
        var from, to;
        
        if(currency_from.value == 'US'){
            console.log(url+'symbols='+currency_to.value+'&app_id='+api_key);
            $.get(url+'symbols='+currency_to.value+'&app_id='+api_key, function(data){
                response = data;
                to = response["rates"][currency_to.value];
                receiving_ammount.value =  (to*sending_ammount.value).toFixed(6);
            });
            return;
        }

        if(currency_to.value == 'US'){
            console.log(url+'symbols='+currency_from.value+'&app_id='+api_key);
            $.get(url+'symbols='+currency_from.value+'&app_id='+api_key, function(data){
                response = data;
                from = (1.0 / response["rates"][currency_from.value]);

                receiving_ammount.value =  (from*sending_ammount.value).toFixed(6);
            });
            return;
        }

		$.get(url+'symbols='+currency_from.value+','+currency_to.value+'&app_id='+api_key, function(data){
        //$.get(url+'symbols='+currency_from.value+','+currency_to.value, function(data){
            response = data;
            console.log(data);
            from = response["rates"][currency_from.value];
            to = response["rates"][currency_to.value];
            receiving_ammount.value =  ((to/from)*sending_ammount.value).toFixed(6);
            var exchange_rate = document.getElementById("exchange_info_exchange_rate");
            exchange_rate.value = (to/from).toFixed(6);
        });
    };
});