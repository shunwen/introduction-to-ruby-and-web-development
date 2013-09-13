require 'pry'

class Blackjack
  attr_accessor :players, :dealer, :dealer_shoe

  def initialize num_of_players=1, num_of_decks=1
    @dealer = Player.new 'Dealer'
    @players = []
    num_of_players.times { @players << Player.new }
    @dealer_shoe = DealerShoe.new num_of_decks
  end

  def play
    2.times { dealer.cards << dealer_shoe.deal_card }
    players.each do |p|
      2.times { p.cards << dealer_shoe.deal_card }
    end

    players_turn
    dealer_turn
  end

  def players_turn
    players.each { |p| player_turn p }
  end
  private :players_turn

  def player_turn player
    result = judge_player player

  end
  private :player_turn

  def dealer_turn

  end
  private :dealer_turn

  def judge
    judge_players
    judge_dealer
  end

  def judge_dealer

  end

  def judge_players
    players.each { |p| judge_player p }
  end
  private :judge_players

  def judge_player player
    points = calculate_points player.cards
    player.status = case points
    when 1..20 then 'none'
    when 21 then 'blackjack'
    else 'busted'
    end
  end
  private :judge_player

  def points
    {'ACE' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
      '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10}
  end
  private :points

  def calculate_points cards
    values = cards.map { |card| card.value }
    points = values.inject(0) { |sum, value| sum + points[value] }
    values.count('ACE').times { points > 11 ? break : points += 10 }
    points
  end
  private :calculate_points
end

class DealerShoe
  attr_accessor :cards

  def initialize num_of_decks=1
    (1..num_of_decks).to_a.product(Card.suits, Card.values).each do |c|
      @cards << Card.new c[1], c[2], c[0]
    end
  end

  def deal_card
    cards.pop
  end
end

class Card
  class << self
    def values
      %w[ACE 2 3 4 5 6 7 8 9 10 J Q K]
    end

    def suits
      %w[club diamond heart spade]
    end

    def suit_icon suit
      # [♣ ♦ ♥ ♠]
      {club: "\u2663", diamond: "\u2666", heart: "\u2665", spade: "\u2660"}[suit.to_sym]
    end
  end

  attr_reader :value, :suit, :deck

  def initialize suit, value, deck=nil
    @value = value
    @suit = suit
    @deck = deck
  end
end

class Player
  include Blackjack

  attr_reader :name, :status, :cards

  def initialize name='Stranger'
    @name = name
    @status = 'playing'
    @cards = []
  end

  def show_cards
    hand = cards.map {|c| c.show}.join(', ')
    puts "#{name} has #{hand}"
  end

  def get_name
    print "What's your name: [#{name}]"
    input = gets.chomp
    name = input unless input.empty?
    puts "Hello, #{name}"
  end

  def act
  end
end

print "Blackjack! How many players? [1] "
num_of_players = gets.chomp.to_i
num_of_players = 1 if num_of_players <= 0
print "How many decks for this game? [1] "
num_of_decks = gets.chomp.to_i
num_of_decks = 1 if num_of_decks <= 0

game = Blackjack.new num_of_players, num_of_decks
game.play

puts "Winners: #{game.winners}"
puts "Losers: #{game.losers}"
puts "Tied players: #{game.tied_players}"
