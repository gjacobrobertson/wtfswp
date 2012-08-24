// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .
//= require konami.pack
//= require rainbow

$(document).ready(function() {
	konami = new Konami()
	konami.code = function() {
		$('.fuck').rainbow({
		    colors: [
		        '#FF0000',
		        '#f26522',
		        '#fff200',
		        '#00a651',
		        '#28abe2',
		        '#2e3192',
		        '#6868ff'
		    ],
		    animate: true,
		    animateInterval: 100,
		    pad: false,
		    pauseLength: 100
		});
	}
	konami.load()	
});
