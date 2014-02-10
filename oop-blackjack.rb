class Card
  attr_accessor :value, :suit

  def initialize(v, s)
    @value = v
    @suit = s
  end

  def what_card
    "#{value} of #{suit}"
  end

end

class Deck
  attr_accessor :deck

  def initialize
    @deck = []
    card_values = ["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"]
    card_suits = ["Hearts","Diamonds","Spades","Clubs"]

    card_values.each do |card|
      card_suits.each do |suit|
        @deck << Card.new(card,suit)
      end
    end
    
    @deck.shuffle!
  end

  def deal_one
    deck.pop
  end
end

class Player
  attr_accessor :name,:cards
  
  def initialize(n)
    @name = n
    @cards = []
  end

end

class Dealer
attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end
end

module Blackjackable
  
  def count_cards(full_hand)
    total = 0
    hand = full_hand.map{|card| card.value}

    hand.each do |idv_card|
      if idv_card == "Ace"
        total += 11
      elsif idv_card.to_i == 0
        total += 10
      else
        total += idv_card.to_i
      end
    end

    hand.select{|val| val == "Ace"}.count.times do
      break if total <= 21 
      total -= 10
    end
    total
    
  end
end

class Blackjack
  include Blackjackable
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new("Angelica")
    @dealer = Dealer.new("Matt")
    @deck = Deck.new
  end
  
  def player_hit
    new_card = deck.deal_one
    puts "The new card is a #{new_card.what_card}"
    player.cards << new_card
    puts "You now have a total of #{count_cards(player.cards)}"
    if count_cards(player.cards) > 21
      return false
    else
      return true
      
    end
  end

  def dealer_hit
    new_card = deck.deal_one
    puts "The new card is a #{new_card.what_card}"
    dealer.cards << new_card
    puts "The dealer now has a total of #{count_cards(dealer.cards)}"
    if count_cards(dealer.cards) > 21
      return false
    else
      return true

    end
  end
  
  def check_for_winner
    if count_cards(player.cards) > count_cards(dealer.cards)
      puts "The player wins with a total of #{count_cards(player.cards)}"
    elsif count_cards(player.cards) < count_cards(dealer.cards)
      puts "The dealer wins with a total of #{count_cards(dealer.cards)}"
    else
      puts "It's a push!"
    end
  end
  
  def run
    player_lost = false
    dealer_lost = false
    player.cards << deck.deal_one
    player.cards << deck.deal_one

    dealer.cards << deck.deal_one
    dealer.cards << deck.deal_one

    puts "\n\nYou have a #{player.cards[0].what_card} and a #{player.cards[1].what_card} showin for a total of #{count_cards(player.cards)}\n"
    puts "The dealer has a #{dealer.cards[1].what_card} showing.\n\nWhat would you like to do (hit/stand)"
    decision = gets.chomp

    while decision == "hit"
      if player_hit == false
        puts "You\'ve busted! Sorry!"
        player_lost = true
        break
      end
      
      puts "What would you like to do (hit/stand)"
      decision = gets.chomp
    end

    if not player_lost
      puts "The dealer flips over a #{dealer.cards[0].what_card}.  He has a total of #{count_cards(dealer.cards)}\n\n"
      while count_cards(dealer.cards) < 17
        if dealer_hit == false
          puts "The dealer busted!  You win!"
          dealer_lost = true
          break
        end
      end
    end

    check_for_winner if dealer_lost == false and player_lost == false
  end
end

Blackjack.new.run
