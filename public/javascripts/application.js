// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


// Side Navigation Menu Slide


$(document).ready(function() {
	$("#nav > li > a.collapsed + ul").slideToggle("medium");
	$("#nav > li > a").click(function() {
		$(this).toggleClass('expanded').toggleClass('collapsed').parent().find('> ul').slideToggle('medium');
	});
});