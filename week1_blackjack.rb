# encoding: UTF-8
require 'pry'

POINTS = {'ACE' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10}
SUITS = ['C', 'D', 'H', 'S'] #["♣", "♦", "♥", "♠"]

$player_hand = []
$dealer_shoe = []

def get_player_name name='Professor X'
  puts "Are you #{name} ? If not, please enter your name: "
  input = gets.chomp.capitalize
  name = input unless input.empty?
  puts "Hello, #{name}."
  name
end

def calculate_points cards
  cards = cards.map { |c| c.last }
  points = cards.inject(0) { |sum, card| sum + POINTS[card] }
  cards.count('ACE').times { points > 11 ? break : points += 10 }
  points
end

def show_cards cards, name='Dealer'
  puts "#{name}'s hand: #{cards.map {|card| card[1..2]}}, #{calculate_points cards} points."
end

def get_dealer_shoe
  puts "How many decks of cards in this game? "
  num_of_decks = gets.chomp.to_i
  num_of_decks = 1 if num_of_decks.zero?

  # A card is [deck, suit, point]
  (1..num_of_decks).to_a.product(SUITS, POINTS.keys).shuffle!
end

def init_hands hands=[]
  hands.each {|h| h.clear}
end

def deal_card hand, dealer_shoe
  hand << dealer_shoe.pop
  # puts "Cards left: #{dealer_shoe.length}"
end

def judge_player points
  case points
  when 1..20 then 'none'
  when 21..21 then 'won'
  else 'busted'
  end
end

def act_player name
  show_cards $player_hand, name

  action = nil
  status = judge_player calculate_points $player_hand

  while status == 'none'
    until ['hit', 'stay'].include? action
      print "Hit or stay? "
      action = gets.chomp.downcase
    end

    if action == 'stay'
      break
    else
      deal_card $player_hand, $dealer_shoe
      show_cards $player_hand, name
      status = judge_player calculate_points $player_hand
      action = nil
    end
  end

  status == 'none' ? "dealer's turn" : status
end

def judge_dealer dealer_points, player_points
  if dealer_points > 21
    player_result = 'won'
  elsif dealer_points == 21 or dealer_points >= player_points
    player_result = 'lost'
  else
    player_result = 'none'
  end

  player_result
end

def act_dealer hand
  show_cards hand

  player_points = calculate_points $player_hand
  dealer_points = calculate_points hand
  player_result = judge_dealer dealer_points, player_points

  while dealer_points < 17 or dealer_points < player_points or player_result == 'none'
    deal_card hand, $dealer_shoe
    show_cards hand
    dealer_points = calculate_points hand
    player_result = judge_dealer dealer_points, player_points
  end

  player_result
end

def player_won msg=""
  puts "You win! #{msg.capitalize}"
end

def player_lost msg=""
  puts "You lose! #{msg.capitalize}"
end

def new_game? name
  action = nil
  until ['', 'y', 'n'].include? action
    print "#{name}, play again? [Yn]"
    action = gets.chomp.downcase
  end

  action == 'n' ? false : true
end
# -- Blackjack

player_name = get_player_name
dealer_hand = []

loop do
  $dealer_shoe = get_dealer_shoe
  init_hands [$player_hand, dealer_hand]
  2.times { deal_card $player_hand, $dealer_shoe }
  2.times { deal_card dealer_hand, $dealer_shoe }

  result = act_player player_name
  result = act_dealer dealer_hand if result == "dealer's turn"

  case result
  when 'won' then player_won
  when 'busted' then player_lost result
  when 'lost' then player_lost result
  end

  break unless new_game? player_name
end

puts "Goodbye!"
