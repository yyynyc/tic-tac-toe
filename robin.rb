class Board
	attr_reader :grid
	def initialize(input = {})
		@grid = input.fetch(:grid, default_grid)
		greeting
	end

	def greeting
		puts "\nWelcome to Tic Tac Toe: a two-player game."
	    
	end

	def get_cell(x, y)
		grid[y][x]
	end

	def set_cell(x, y, value)
		get_cell(x, y).value = value
	end

	def game_over
		return :winner if winner?
		return :draw if draw?
	end

	def formatted_grid
      grid.each_with_index do |row, i|
      	a = Array.new(3)
        row.each_with_index do |cell, col| 
        	if cell.value.empty? 
        		a[col] = i*3 + col + 1
        	else 
        		a[col] = cell.value
        	end
        end 
        puts a.join("|")
      end
    end

	private

	def default_grid
		Array.new(3) {Array.new(3) {Cell.new}}
	end

	def draw?
		grid.flatten.map{|cell| cell.value}.none_empty?
	end

	def winner?
		winning_positions.each do |position|
			next if winning_position_values(position).all_empty?
			return true if winning_position_values(position).all_same?
		end
		false
	end

	def winning_positions
		grid + grid.transpose + diagonals
	end

	def diagonals
		[
			[get_cell(0, 0), get_cell(1, 1), get_cell(2, 2)],
			[get_cell(0, 2), get_cell(1, 1), get_cell(2, 0)]
		]
	end

	def winning_position_values(position)
		position.map{|cell| cell.value}
	end
end

class Player
	attr_reader :role, :name
	def initialize(input)
		@role = input.fetch(:role) 
		@name = input.fetch(:name)
	end
end

class Cell
	attr_accessor :value
	def initialize(value = "")
		@value = value
	end
end

class Game
	attr_reader :players, :board, :current_player, :other_player
	def initialize(board=Board.new)
		@board = board
		@current_player, @other_player = [@current_player, @other_player].shuffle
	end

	def switch_players
		@current_player, @other_player = @other_player, @current_player
	end

	def solicit_move		
		"#{@current_player.name.capitalize}: To make a move, enter a number between 1 and 9"
	end

	def get_move(human_move = gets.chomp)
		human_move_to_coordinate(human_move)
	end

	def human_move_to_coordinate(human_move)
		mapping = {
			"1" => [0, 0],
			"2" => [1, 0],
			"3" => [2, 0],
			"4" => [0, 1],
			"5" => [1, 1],
			"6" => [2, 1],
			"7" => [0, 2],
			"8" => [1, 2],
			"9" => [2, 2]		
		}
		mapping[human_move]
	end

	def game_over_message
		if board.game_over == :winner
			return "#{@current_player.name.capitalize} won!"
		elsif board.game_over == :draw
			return "The game ended in a tie"
		end
	end

	def play
		puts "Before we get started, what is your name?"
		@current_player = Player.new({role: "X", name: gets.chomp})
	    puts "Nice to meet you #{@current_player.name.capitalize}. Your input will be marked as X.\nNext, what is the other player's name?"
	    @other_player = Player.new({role: "O", name: gets.chomp})
	    puts "Nice to meet you #{@other_player.name.capitalize}. Your input will be marked as O."
		puts "#{@current_player.name.capitalize} has been randomly set as the first player"
		while true
			board.formatted_grid
			puts ""
			puts solicit_move
			x, y = get_move
			board.set_cell(x,y, current_player.role)
			if board.game_over
				puts game_over_message
				board.formatted_grid
				return
			else
				switch_players
			end
		end
	end
end

class Array
	def all_empty?
		self.all?{|e| e.to_s.empty?}
	end

	def any_empty?
		self.any?{|e| e.to_s.empty?}
	end

	def none_empty?
		!any_empty?
	end

	def all_same?
		self.all?{|e| e == self[0]}
	end
end

Game.new.play

