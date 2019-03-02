var response;
var form_fields;
var receiving_amount;
var sending_amount;

$( document ).on ('turbolinks:load',function(){
	if ($('meta[name=psj').attr('controller') != 'exchange_infos'){
		return;
	}

    receiving_amount = document.getElementById("exchange_info_receiving_amount");
    sending_amount = document.getElementById("exchange_info_sending_amount");

    sending_amount.onchange = function(){
		var currency_from = document.getElementById("exchange_info_currency_from");
		var currency_to = document.getElementById("exchange_info_currency_to");
        var url = 'https://openexchangerates.org/api/latest.json?';
        var api_key = '2c02b1d3c85e4c7d88fbe5dd983d0965';
        var from, to;
        
        if(currency_from.value == 'US'){
            $.get(url+'symbols='+currency_to.value+'&app_id='+api_key, function(data){
                response = data;
                to = response["rates"][currency_to.value];
                receiving_amount.value =  (to*sending_amount.value).toFixed(6);
            });
            return;
        }

        if(currency_to.value == 'US'){
            console.log(url+'symbols='+currency_from.value+'&app_id='+api_key);
            $.get(url+'symbols='+currency_from.value+'&app_id='+api_key, function(data){
                response = data;
                from = (1.0 / response["rates"][currency_from.value]);

                receiving_amount.value =  (from*sending_amount.value).toFixed(6);
            });
            return;
        }
        var symbols = 'symbols='+currency_from.value+','+currency_to.value;
        var route = url+ symbols +'&app_id='+api_key;
		$.get(route, function(data){
            response = data;
            from = response["rates"][currency_from.value];
            to = response["rates"][currency_to.value];
            receiving_amount.value =  ((to/from)*sending_amount.value).toFixed(6);
            $("#exchange_info_exchange_rate").val((to/from).toFixed(6)); 
        });
    };
});