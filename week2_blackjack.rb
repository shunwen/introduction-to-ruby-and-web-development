require 'pry'

class Blackjack
  attr_accessor :players, :dealer, :dealer_shoe

  def initialize players, num_of_decks = 1
    @dealer = Player.new 'Dealer'
    @cheater = Player.new 'Cheater'
    @players = players
    @dealer_shoe = DealerShoe.new num_of_decks
  end

  def play
    dealer.cards.clear
    2.times { dealer.cards << dealer_shoe.deal_card }
    show dealer

    players.each do |p|
      p.cards.clear
      2.times { p.cards << dealer_shoe.deal_card }
      show p
    end

    puts "", "Game Starts!"
    players.each { |p| player_turn p }
    dealer_turn
    final_judge
    puts "", "The winner is..."
    players.each { |p| puts "#{p.name}: #{p.status.upcase}" }
  end

  def show gamer
    puts "#{gamer.show_cards} => #{calculate_points gamer} points"
  end
  private :show

  def final_judge
    if dealer.status == 'none'
      dealer_points = calculate_points dealer
      players.select {|p| p.status == 'none'}.each do |p|
        points = calculate_points p
        p.status = case
        when points > dealer_points then 'win'
        when points == dealer_points then 'tie'
        when points < dealer_points then 'lose'
        end
      end
    else
      players.select {|p| p.status == 'none'}.each do |p|
        p.status = case dealer.status
        when 'busted' then 'win'
        when 'blackjack' then 'lose'
        end
      end
    end
  end
  private :final_judge

  def player_turn player
    show player
    judge player

    while player.status == 'none'
      print "#{player.name}, hit or stay? [hit] "
      break if gets.chomp == 'stay'

      player.cards << dealer_shoe.deal_card
      show player
      judge player
    end
  end
  private :player_turn

  def dealer_turn
    show dealer
    judge dealer

    while dealer.status == 'none'
      @cheater.cards = dealer.cards.dup
      @cheater.cards << dealer_shoe.peek
      cheater_points = calculate_points @cheater
      points = calculate_points dealer

      if points < 17 or cheater_points <= 21
        dealer.cards << dealer_shoe.deal_card
        show dealer
        judge dealer
      else
        break
      end
    end
  end
  private :dealer_turn

  def judge gamer
    points = calculate_points gamer
    gamer.status = case points
    when 1..20 then 'none'
    when 21 then 'blackjack'
    else 'busted'
    end
  end
  private :judge

  def blackjack_points
    {'ACE' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
      '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10}
  end
  private :blackjack_points

  def calculate_points gamer
    values = gamer.cards.map { |card| card.value }
    points = values.inject(0) { |sum, value| sum + blackjack_points[value] }
    values.count('ACE').times { points > 11 ? break : points += 10 }
    points
  end
  private :calculate_points
end

class DealerShoe
  attr_accessor :cards

  def initialize num_of_decks = 1
    @cards = []
    (1..num_of_decks).to_a.product(Card.suits, Card.values).each do |c|
      @cards << Card.new(c[1], c[2], c[0])
    end
    @cards.shuffle!
  end

  def deal_card
    cards.pop
  end

  def peek
    cards.last
  end
end

class Card
  def self.values
    %w[ACE 2 3 4 5 6 7 8 9 10 J Q K]
  end

  def self.suits
    %w[club diamond heart spade]
  end

  attr_reader :value, :suit, :deck

  def initialize suit, value, deck=nil
    @value = value
    @suit = suit
    @deck = deck
  end

  def show
    icon = suit_icon suit
    "[#{icon} #{value}]"
  end

  def suit_icon suit # [♣ ♦ ♥ ♠]
    {club: "\u2663", diamond: "\u2666", heart: "\u2665", spade: "\u2660"}[suit.to_sym]
  end
  private :suit_icon
end

class Player
  attr_reader :name
  attr_accessor :status, :cards

  def initialize name
    @name = name
    @status = 'playing'
    @cards = []
  end

  def show_cards
    hand = cards.map {|c| c.show}.join(', ')
    "#{name} has #{hand}"
  end

  def get_name
    print "What's your name: [#{name}]"
    input = gets.chomp
    self.name = input unless input.empty?
    puts "Hello, #{name}"
  end
end

print "Blackjack! How many players? [1] "
num_of_players = gets.chomp.to_i
num_of_players = 1 if num_of_players <= 0
print "How many decks for this game? [1] "
num_of_decks = gets.chomp.to_i
num_of_decks = 1 if num_of_decks <= 0

players = []
num_of_players.times.map do |i|
  player = Player.new("Player-#{i}")
  player.get_name
  players << player
end

game = Blackjack.new players, num_of_decks
loop do
  game.play
  print "Play again? [Yn] "
  break if gets.chomp.downcase == 'n'
end
