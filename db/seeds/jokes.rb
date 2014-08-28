contents = File.read('db/seeds/jokes.txt').split("\n\n").compact

contents.each do |joke|
	joke = joke.split("\n")
	body = joke[0]
	punchline = joke[1] if joke[1]
	punchline ? Joke.create(body: body, punchline: punchline) : Joke.create(body: body)
	p Joke.last
end
