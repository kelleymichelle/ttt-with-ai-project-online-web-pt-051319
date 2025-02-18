require 'pry'
class Game
  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]
  
  def initialize(player1=Players::Human.new("X"), player2=Players::Human.new("O"), board=Board.new)
    @player_1 = player1
    @player_2 = player2
    @board = board
  end

  def self.token_determinator(arg)
    if arg.upcase == "X"
      return "O"
    elsif arg.upcase == "O"
      return "X"
    end
  end      
  
  def self.start
    # binding.pry
    puts "Welcome to Tic-Tac-Toe on steriods! It's probably not great but here goes..."
    puts "Would you like to play a 0, 1, or 2 player game?"
    reply = gets.chomp
    
      case
      when reply == "0"
        game0 = Game.new(Players::Computer.new("X"), Players::Computer.new("O"), Board.new)
        game0.play
      when reply == "1"
        puts "Would you like to be X or O?"
        token_reply = gets.chomp
        other_token = token_determinator(token_reply)
        game1 = Game.new(Players::Human.new(token_reply.upcase), Players::Computer.new(other_token), Board.new)
        game1.play
      when reply == "2"
        puts "Does player 1 want to be X or O?"
        token2 = gets.chomp
        puts "Let's hope player 2 knows what the fuck player 1 wants and doesn't fuck this up because I don't feel like programming that functionality..."
        token3 = gets.chomp
        game2 = Game.new(Players::Human.new(token2.upcase), Players::Human.new(token3.upcase), Board.new)
        game2.play
      
    end  
  end  

  def board
    @board
  end

  def current_player
    # binding.pry
    x = @board.turn_count
    case
    when x.even?
      return @player_1
    when x.odd?
      return @player_2
    end  
  end
  
  def won?
    WIN_COMBINATIONS.each do |combo|
      # binding.pry
      if board.cells[combo[0]] == "X" && board.cells[combo[1]] == "X" && board.cells[combo[2]] == "X" || board.cells[combo[0]] == "O" && board.cells[combo[1]] == "O" && board.cells[combo[2]] == "O"
        return combo 
      end
    end
    false 
  end

  def draw?
    self.won? == false && self.board.full? == true
  end  
  
  def over?
    case
    when self.draw? || self.won? == true
      return true
    when self.board.full? == false && self.won? == false
      return false
    end
    true  
  end

  def winner
    if self.won?
      return self.board.cells[self.won?[0]]
    else
      return nil
    end  
  end
  
  def turn
    @board.display
    player = self.current_player
    move_1 = player.move(@board)
    
    if @board.valid_move?(move_1) == true && @board.taken?(move_1) == false
      @board.update(move_1, player)
      @board.display
      
    else 
      puts "invalid"
      player.move(@board)
    end   
  end
  
  def play
    while over? == false 
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    end
    if draw?
      puts "Cat's Game!" 
    end     
  end  

end  