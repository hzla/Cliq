


Game = 
	init: ->
		$('.content-container').css('background', 'white')
		$('input').keypress @evaluate
		$('.number-input').keyup @numbersOnly
		$('.op-input').keyup @opsOnly
		@ops = ["+", "-", "*", "/", "^", "%"]
		$('.start').click @countDown
		$('.item-img').click @addImg
		$('.other-start').click @otherCD
		$('.buy').click @calc
		$('.give-up').click @giveUp

	giveUp: ->
		$('.timer').text(':1')

	calc: ->
		total = 0
		shit = ""
		bought = $('.add-img:visible:not(.contained)')
		have = $('.add-img:visible')
		bought.each ->
			val = parseInt $(@).attr('id')
			total += val
		have.each ->
			val = $(@).attr('alt')
			shit += val + ","
		amount = 0
		console.log total
		if $('.strange').length > 0
			amount = parseInt($('.coins').find('.amount').text()) - total
			type = "strange"
			$('.coins').find('.amount').text amount
		else
			amount = parseInt($('.Money').find('.amount').text()) - total
			console.log amount
			type = "normal"
			$('.Money').find('.amount').text amount
		
		$.get("/buy?amount=#{amount}&type=#{type}&shit=#{shit}")
		document.location.reload()



	addImg: ->
		console.log "somethign"
		id = $(@).attr('id').slice(0, -5)
		newId = ".#{id}-png"
		console.log newId
		$('.avatar-png').toggle() if newId == ".better-png"
		$(newId).toggle()

	otherCD: ->
		if !Game.countingDown
			$('.start-overlay').hide()
			Game.int = setInterval ->
				newVal = parseInt($('.timer').text().slice(-2)) - 1
				newVal = parseInt($('.timer').text().slice(-1)) - 1 if $('.timer').text().length == 2
				if newVal == 0
					$.get('/lost')
					location.reload()
					clearInterval(Game.int)
					
				$('.timer').text ":" + newVal
			, 1000


	countDown: ->
		$.get('/start')
		$('.start-overlay').hide()
		Game.countingDown = true

		Game.int = setInterval ->
			newVal = parseInt($('.timer').text().slice(-2)) - 1
			newVal = parseInt($('.timer').text().slice(-1)) - 1 if $('.timer').text().length == 2
			if newVal == 0
				$.get('/lost')
				location.reload()
				clearInterval(Game.int)
				
			$('.timer').text ":" + newVal
		, 1000

	fact: (n) ->
		return 0 if n < 0
		return 1 if n == 0 or n == 1
		return n * Game.fact(n - 1)

	opsOnly: ->
		numbers = $('.number').map ->
			$(@).text()
		if $.inArray(@.value.slice(-1), numbers) != -1
			$(@).next().val @.value.slice(-1)
			@.value = @.value.slice(0,-1)
			$(@).next().next().trigger('focus')
			return
		@.value = '' if $.inArray(@.value, Game.ops) == -1
		
	numbersOnly: ->
		usedNumbers = $('.number-input').map ->
			$(@).val()
		usedNumbers = $.makeArray usedNumbers
		numbers = $('.number').map ->
			$(@).text()
		numArray = $.makeArray numbers
		numArray.push "("
		numArray.push ")"
		numArray.push "!" 
		if $.inArray(@.value.slice(-1), Game.ops) != -1
			$(@).next().val @.value.slice(-1)
			@.value = @.value.slice(0,-1)
			$(@).next().next().trigger('focus')
		value = @.value
		index = usedNumbers.indexOf @.value
		usedNumbers = usedNumbers.filter (x) -> x isnt value.toString()
		@.value = '' if ($.inArray(@.value, numArray) == -1 && @.value.slice(0,1) != "(" && @.value.slice(-1) != ")" && @.value.slice(-1) != "!" && @.value.slice(-2,-1) != "!") || usedNumbers.length < 3 

	evaluate: ->
		setTimeout ->
			numbers = $('.number-input').map ->
				$(@).val()
			numbers = $.makeArray(numbers).filter (x) -> x isnt ""
			ops = $('.op-input').map ->
				$(@).val()
			ops = $.makeArray(ops).filter (x) -> x isnt ""
			console.log ops
			console.log numbers
			console.log ops.length == 3 && numbers.length == 4
			if ops.length == 3 && numbers.length == 4
				console.log "something"
				wholeArray = [numbers[0], ops[0],numbers[1], ops[1],numbers[2], ops[2],numbers[3]]
				wholeArray = wholeArray.join(" ").replace(/(\d)\s\^\s(\d)/, "(Math.pow($1, $2))")
				wholeArray = wholeArray.replace /(\(Math.pow\(\d,\s\d\)\))\s\^\s(\d)/, "(Math.pow($1, $2))"
				console.log wholeArray
				regex = /(\d)!/g
				wholeArray = wholeArray.replace regex, (match, number) ->					
					Game.fact(parseInt(number))
				answer = eval(wholeArray)
				$('.answer').text eval(wholeArray)
				$('.winner').show()
				if answer == 24
					clearInterval(Game.int)
					$('.you-win').show()
					$.get('/won')

		, 10


ready = ->
	Game.init()
$(document).ready ready
$(document).on 'page:load', ready