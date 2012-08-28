# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

rainbow = false

enableRainbow = () ->
	if $('.fuck span').length == 0
		$('.fuck').rainbow
			colors: [
		  	'#FF0000',
		    '#f26522',
		    '#fff200',
		    '#00a651',
		    '#28abe2',
		    '#2e3192',
		    '#6868ff'
		  ]
			animate: true
			animateInterval: 100
			pad: false
			pauseLength: 100
	else
		$('.fuck').resumeRainbow()
	rainbow = true
	return

disableRainbow = () ->
	$('.fuck').pauseRainbow()
	setTimeout (() -> $('.fuck span').removeAttr('style')), 200
	rainbow = false
	return
	
toggleRainbow = () ->
	if rainbow
		disableRainbow()
	else
		enableRainbow()
	return

$ ->
	konami = new Konami()
	konami.code = toggleRainbow
	konami.load()