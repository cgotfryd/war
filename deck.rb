suits = ['H','S','C','D']
cards = [2,3,4,5,6,7,8,9,10,11,12,13,14]
deck = Array.new()

for suit in suits
	for card in cards
		deck.push(suit+card.to_s)
	end
end

deck = deck.shuffle

puts deck