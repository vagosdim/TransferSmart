// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .



var response;
var form_fields;
var receiving_ammount;
var sending_ammount;
$( document ).ready(function() {
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

