require 'rubygems'
require 'pry'

class Card
	attr_accessor :suit, :face_value

	def initialize(suit, face_value)
		@suit = suit
		@face_value = face_value
	end

	def display_card
		puts "#{face_value} of #{suit}"
	end

end

class Hand
	attr_accessor :cards, :hand_value

	def initialize
		@cards = []
		@hand_value = 0
	end

	# Calcualte the point value of the hand and assing to @hand_value
	def calc_value
    	cardvalues = {"2"=>2,"3"=>3,"4"=>4,"5"=>5,"6"=>6,"7"=>7,"8"=>8,"9"=>9,"10"=>10,"J"=>10,"Q"=>10,"K"=>10,"A"=>11}
      	
      	arr = cards.map{|card| card.face_value}
      	value = 0
      	arr.each{|x| value += cardvalues[x]}
      	arr.select{|x| x == "A"}.count.times{value -= 10 if value>21}

      	@hand_value = value    
	end

	# Add card to the hand and update refresh hand value
	def add_card(card)
		cards << card
		calc_value
	end
end

class Deck
	attr_accessor :cards

	# Create deck and shuffle cards
	def initialize
		@cards =[]
		%w[Spades Hearts Diamonds Clubs].each do |suit|
			%w[2 3 4 5 6 7 8 9 10 J Q K A].each do |face_value|
				@cards << Card.new(suit, face_value)
			end
		end
		shuffle!
	end

	# Shuffle deck
	def shuffle!
		cards.shuffle!
	end

	# Deal card from the deck
	def deal_card
		cards.pop
	end
end

class Player
	attr_accessor :hand, :name

	def initialize
		@name = "Player"
		@hand = Hand.new
	end

	# Add a card to the player's hand
	def draw_card(card)
		hand.add_card(card)
	end

	# Gets valid input - "H" (Hit) or "S"(Stand) from user
	def get_user_action()
     	action = nil
     	valid_input = false
    	while !valid_input do
         	puts "Would you like to Hit (H) or Stand (S)?"
          	action = gets.chomp.upcase
          	if action == "H" || action == "S"
            	  valid_input = true
          	else
            	  puts "Please enter a valid action."
          	end
      	end
      	return action
	end

	# Player can choose to hit or stay if value of hand < 21
	def play(deck)
		action = get_user_action if hand.hand_value < 21
		while (hand.hand_value) < 21 && (action == "H") do
			draw_card(deck.deal_card)
			show_hand
			action = get_user_action if hand.hand_value < 21
		end
	end

	def show_hand
		puts "#{name} was dealt:"
		hand.cards.each{|c| c.display_card}
		print "Hand value: #{hand.hand_value.to_s}\n\n"
	end
end

class Dealer < Player
	def initialize
		@name = "Dealer"
		@hand = Hand.new
	end

	# Dealer always hits until hand value >= 17
	def play(deck)
		while hand.hand_value < 17 do
			draw_card(deck.deal_card)
		end
	end

	# Display the card Dealer is showing
	def show_facecard
		puts "The #{name} is showing:" 
		hand.cards[1].display_card
	end
end

class BlackjackGame

	def initialize
		@deck = Deck.new
		@player = Player.new
		@dealer = Dealer.new		
	end

	def welcome_message
		puts "Welcome to the Blackjack Game.\n\n"
	end

	def deal_cards
		@player.draw_card(@deck.deal_card)
		@dealer.draw_card(@deck.deal_card)
		@player.draw_card(@deck.deal_card)
		@dealer.draw_card(@deck.deal_card)
	end

	# Dealer checks for blackjack
	# If both dealer and player have blackjack, it's a push
	# If only player has blackjack, player automatically wins
	# If only dealer has blackjack, dealer immediately shows hand and wins
	def blackjack_check
		if @player.hand.hand_value == 21 && @dealer.hand.hand_value == 21
		 	@dealer.show_hand
		 	puts "Both #{@player.name} and #{@dealer.name} have Blackjack. It's a push"
		 	return true
		 elsif @player.hand.hand_value == 21 && @dealer.hand.hand_value < 21
		 	@dealer.show_hand
		 	puts "#{@player.name} has a Blackjack. #{@player.name} wins!" 
		 	return true
		 elsif @player.hand.hand_value < 21 && @dealer.hand.hand_value == 21
		 	@dealer.show_hand
		 	puts "#{@dealer.name} has a Blackjack. #{@dealer.name} wins."
		 	return true
		 else
		 	return false
		 end
	end

	# Compare player and dealer hands to determine who wins
	def compare_hands
		case @player.hand.hand_value <=> @dealer.hand.hand_value
			when 1 then puts "#{@player.name} wins!"
			when -1 then puts "#{@dealer.name} wins."
			when 0 then puts "It's a push."
		end
	end

	def start
		welcome_message
		deal_cards
		@player.show_hand
		if blackjack_check
			exit
		end
		@dealer.show_facecard
		@player.play(@deck)
		if @player.hand.hand_value > 21
			puts "#{@player.name} has busted. #{@dealer.name} wins."
			exit
		end
		@dealer.play(@deck)
		@dealer.show_hand
		if @dealer.hand.hand_value > 21
			puts "#{@dealer.name} has busted. #{@player.name} wins."
			exit
		end
		compare_hands
	end	
end

BlackjackGame.new.start

