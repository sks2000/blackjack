# Calculate the value of the hand. Assume Ace value is 11 unless hand value is over 21 then reduce each Ace value by 10 until hand value is less than 21
def hand_value(hand)
      cardvalues = {"2"=>2,"3"=>3,"4"=>4,"5"=>5,"6"=>6,"7"=>7,"8"=>8,"9"=>9,"10"=>10,"J"=>10,"Q"=>10,"K"=>10,"A"=>11}
      value = 0
      num_aces = 0
      hand.each do |x|
          value += cardvalues[x[0]]
          num_aces += 1 if x[0] == "A"
      end
      num_aces.times{value -=10 if value>21}
      return value    
end

def print_hand(hand)
      hand.each{|x| puts x[0] + " of " + x[1]}
      puts "Hand value: " + hand_value(hand).to_s
      puts
end

def get_user_action()
      action = nil
      valid_input = false
      while !valid_input do
          puts "Would you like to Hit (H) or Stand (S)?"
          action = action = gets.chomp.upcase
          if action == "H" || action == "S"
              valid_input = true
          else
              puts "Please enter a valid action."
          end
      end
      return action
end

cardnumber = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]
suits = ["Spades", "Hearts","Diamonds","Clubs"]

# Create and shuffle deck
deck = Array.new
cardnumber.each do |c|
	suits.each do |s|
		deck.push([c,s])
	end
end
puts "Cards in deck: " + deck.length.to_s
deck.shuffle!

player_hand = Array.new
dealer_hand = Array.new

# Deal first two cards
player_hand.push(deck.pop)
dealer_hand.push(deck.pop)
player_hand.push(deck.pop)
dealer_hand.push(deck.pop)

puts "You were dealt:"
print_hand(player_hand)
puts "The dealer is showing a " + dealer_hand[0][0] + " of " + dealer_hand[0][1]
puts

# Ask player to hit or stand until until he chooses to stand or busts 
#puts "Would you like to Hit (H) or Stand (S)?"
#action = gets.chomp.upcase
action = get_user_action
bust = false
while (action == "H") && !bust do
      player_hand.push(deck.pop)
      print_hand(player_hand)
      if hand_value(player_hand) > 21
          puts "You busted!!!"
          bust = true
      else
          #puts "Would you like to Hold (H) or Stand (S)?"
          #action = gets.chomp.upcase
          action = get_user_action
      end   
end


# if player doesn't bust dealer will hit until dealer has 17 or higher. If dealer busts player wins otherwise compare scores to determine winner.
if !bust
      while hand_value(dealer_hand) < 17 do
          dealer_hand.push(deck.pop)
      end
      puts("The dealer was dealt:")
      print_hand(dealer_hand)
      if hand_value(dealer_hand)>21
          print "The dealer busted!! You win!"
      else
          if hand_value(dealer_hand) > hand_value(player_hand)
              puts "Dealer wins" 
          elsif hand_value(player_hand) > hand_value(dealer_hand)
              puts "You win!"
          else 
              puts "It's a push."          
          end

    end
end



