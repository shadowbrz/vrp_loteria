
$(document).ready(function(){

 window.addEventListener( 'message', function( event ) {
        var item = event.data;

        if ( item.showPlayerMenu == true ) {
	$('body').css('background-color','transparent');

$('.container-fluid').css('display','block');
} else if ( item.showPlayerMenu == false ) { // Hide the menu

$('.container-fluid').css('display','none');
$('body').css('background-color','transparent important!');
	$("body").css("background-image","none");

        }
    } );

	$("#ticket1").click(function(){
	  $.post('http://vrp_loteria/buyTickets', JSON.stringify({"amount": 1}));
	});
	
	$("#ticket2").click(function(){
	  $.post('http://vrp_loteria/buyTickets', JSON.stringify({"amount": 2}));
	});
	
	$("#ticket3").click(function(){
	  $.post('http://vrp_loteria/buyTickets', JSON.stringify({"amount": 3}));
	});
	
	$("#ticket4").click(function(){
	  $.post('http://vrp_loteria/buyTickets', JSON.stringify({"amount": 4}));
	});
	
	$("#ticket5").click(function(){
	  $.post('http://vrp_loteria/buyTickets', JSON.stringify({"amount": 5}));
	});


    $("#closebtn").click(function(){
        $.post('http://vrp_loteria/closeButton', JSON.stringify({}));2

    });


})
