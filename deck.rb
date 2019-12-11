#build deck - array of hashes with suit and card value
def deck

	#declare suits and values
	suits = ['Hearts','Spades','Clubs','Diamonds']
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
	deck = deck().shuffle!
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
	game["deck"].shuffle!

	return game

end

#play - takes the players hand as an array of hashes and a number of cards to play
def play(hand,playTo)
	
	playedCards = Array.new
	
	#push the correct number of cards to the cards played
	for i in 0...playTo
		playedCards.push(hand[i])
	end

	#remove played cards from hand
	hand.shift(playTo)

	#returns hand for player and played cards for the game
	return {"handBack" => hand, "playedCards" => playedCards}

end

#referee - determines score for each round, takes 2 arrays of cards
def referee(cardsA,cardsB)

	scoreA = 0
	scoreB = 0

	#loop to allow for checking all played cards
	for i in 0...cardsA.length
		
		#handle a tie
		if cardsA[i]["value"].to_i == cardsB[i]["value"].to_i
			#no points for tie
		
		#point to player A
		elsif cardsA[i]["value"].to_i > cardsB[i]["value"].to_i
			scoreA += 1
		
		#point to player B
		else
			scoreB += 1
		end
	end

	#return scores as simple array
	return [scoreA, scoreB]
end

def announcer(playedA,playedB,scores)
	cardAstr = ""
	cardBstr = ""

	for i in 0...playedA.length
		cardA = playedA[i]
		cardB = playedB[i]

		if cardA["value"] == 11
			cardAstr += "Jack of #{cardA["suit"]}"
		elsif cardA["value"] == 12
			cardAstr += "Queen of #{cardA["suit"]}"
		elsif cardA["value"] == 13
			cardAstr += "King of #{cardA["suit"]}"
		elsif cardA["value"] == 14
			cardAstr += "Ace of #{cardA["suit"]}"
		else
			cardAstr += "#{cardA["value"]} of #{cardA["suit"]}"
		end

		if cardB["value"] == 11
			cardBstr += "Jack of #{cardB["suit"]}"
		elsif cardB["value"] == 12
			cardBstr += "Queen of #{cardB["suit"]}"
		elsif cardB["value"] == 13
			cardBstr += "King of #{cardB["suit"]}"
		elsif cardB["value"] == 14
			cardBstr += "Ace of #{cardB["suit"]}"
		else
			cardBstr += "#{cardB["value"]} of #{cardB["suit"]}"
		end

		puts "Player 1 played: #{cardAstr}"
		puts "Player 2 played: #{cardBstr}"
	end

	if scores[0] != scores[1]
		puts "Round goes to Player "+(scores[0]>scores[1]? "1" : "2")
	else
		puts "Round ties. No points"
	end
end


#set up game
game = deal(2,0)

#give variables to players for easier access
p1 = game["players"]["p1"]
p2 = game["players"]["p2"]

for i in 1..p1["hand"].length

	puts "Round #{i}"
	
	#execute the round play function
	playP1 = play(p1["hand"],1)
	playP2 = play(p2["hand"],1)

	#update player hands
	p1["hand"] = playP1["handBack"]
	p2["hand"] = playP2["handBack"]

	#check result of the round
	roundResult = referee(playP1["playedCards"],playP2["playedCards"])

	#update player scores
	p1["score"] += roundResult[0]
	p2["score"] += roundResult[1]

	announcer(playP1["playedCards"],playP2["playedCards"],roundResult)

	puts "\n"

end

puts "Final results:"
puts "Player 1 with a total of #{p1["score"]}"
puts "Player 2 with a total of #{p2["score"]}"

if p1["score"] != p2["score"]
	puts "Game goes to Player #{p1["score"]>p2["score"]? 1:2}"
else
	puts "Player 1 and Player 2 tied"
end