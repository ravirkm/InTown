// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){ 
  var active_color = '#FFF'; // Colour of user provided text
	var inactive_color = '#999'; // Colour of default text
	$("input#default-value").css("color", inactive_color);
	var default_values = new Array();
	$("input#default-value").focus(function() {
	  if (!default_values[this.id]) {
		  default_values[this.id] = this.value;
		}
	  if (this.value == default_values[this.id]) {
		  this.value = '';
		  this.style.color = active_color;
		}
	  $(this).blur(function() {
		  if (this.value == '') {
		    this.style.color = inactive_color;
		    this.value = default_values[this.id];
		  }
	  });
  });
	$('#password-clear').show();
	$('#password-clear').css("color", inactive_color);
  $('#password-password').hide();
  $('#password-clear').focus(function() {
    $('#password-clear').hide();
    $('#password-password').show();
    $('#password-password').focus();
  });
  $('#password-password').blur(function() {
    if($('#password-password').val() == '') {
      $('#password-clear').show();
      $('#password-clear').css("color", inactive_color);
      $('#password-password').hide();
    }
  });
      
  $('#event_date').datepicker({ dateFormat: 'yy-mm-dd' });
      
  }
)
