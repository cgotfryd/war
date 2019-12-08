#build deck - array of hashes with suit and card value
def deck

	#declare suits and values
	suits = ['H','S','C','D']
	cards = [2,3,4,5,6,7,8,9,10,11,12,13,14]
	deck = Array.new()

	#loop through suits and card values, creating hash for each, push to deck
	for suit in suits
		for card in cards
			deck.push({"suit" => suit, "value" => card})
		end
	end

	return deck
end

#deal deck - given number of players and desired hand size, use 0 to distribute entire deck
def deal(playerCount,dealTo)
	deck = deck().shuffle
	game = {"deck" => deck,"players"=>{}}
	players = game["players"]
	distributeTo = dealTo * playerCount
	if distributeTo == 0
		distributeTo = 52
	end

	#create player hash in game for each player
	for i in 1..playerCount
		players["p"+i.to_s] = {"hand" => [],"score" => 0}
	end
	
	for i in 0...distributeTo	
		#get player no. to call from hash
		targetPlayer = i % playerCount + 1
		
		#push top card of deck to player hand
		players["p"+targetPlayer.to_s]["hand"].push(deck[i])
	end

	#remove dealt cards from deck
	game["deck"].shift(distributeTo)

	return game

end