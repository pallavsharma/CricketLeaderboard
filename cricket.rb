require_relative 'team.rb'
require_relative 'player.rb'
require 'terminal-table'

class Cricket
  attr_accessor :striker, :non_striker, :batting_team, :fielding_team

  def initialize(player_info={'team1' => [1,2,3,4,5], 'team2' => [6,7,8,9,10]}, overs=2)
    create_teams(player_info)
    @overs = overs
  end

  def play_over(over)
    over.each do |ball|
      set_score(ball)
    end
    batting_team.add_over
    print_score
    after_over
  end

  private
  def create_teams(player_info)
    @batting_team = Team.new(player_info['team1'], Team::BATTING, 'team1')
    @fielding_team = Team.new(player_info['team2'], Team::FIELDING, 'team2')
    set_players
  end
  def set_players
    @striker = @batting_team.available_players[0]
    @striker.status = Player::STRIKER
    @non_striker = @batting_team.available_players[0]
    @non_striker.status = Player::NON_STRIKER
  end
  def after_over
    side_change
    if ((batting_team.overs == @overs) && (fielding_team.overs == 0))
      change_team
    elsif ((batting_team.overs == @overs) && (fielding_team.overs == 2))
      declare_winner
    end
  end
  def declare_winner
    if batting_team.score > fielding_team.score
      winner = batting_team
      runs = batting_team.score - fielding_team.score
    else
      winner = fielding_team
      runs = fielding_team.score - batting_team.score
    end
    puts "Result: #{winner.name} won the match by #{runs} runs" 
  end
  def change_team
    puts "Changing Teams"
    @batting_team, @fielding_team = @fielding_team, @batting_team
    @batting_team.status = Team::BATTING
    @fielding_team.status = Team::FIELDING
    set_players
  end
  def side_change
    if @striker && @non_striker
      @striker, @non_striker = @non_striker, @striker
      @striker.status = Player::STRIKER
      @non_striker.status = Player::NON_STRIKER    
    end
  end
  def set_score(ball)
    @striker.add_ball
    case ball
    when 1
      @striker.add_score(1)
      change_striker
    when 2
      @striker.add_score(2)
    when 4
      @striker.add_score(4)
      @striker.add_fours
    when 6
      @striker.add_score(6)
      @striker.add_sixes
    when 'WD' # Wide Ball
      @striker.remove_ball
      batting_team.score += 1
    when 'W' # Wicket
      set_striker_out
    end
  end
  def set_striker_out
    @striker.status = Player::OUT
    batting_team.add_outs
    if @non_striker && batting_team.available_players
      @striker = batting_team.available_players.first
    elsif @non_striker && !batting_team.available_players
      @striker = @non_striker
      @striker.status = Player::STRIKER
      @non_striker = nil
    else
      # notify game team change
    end
  end
  def change_striker
    @striker, @non_striker = @non_striker, @striker
    @striker.status = Player::STRIKER
    @non_striker.status = Player::NON_STRIKER
  end
  def print_score
    rows = []
    batting_team.players.each do |p|
      rows << ["#{p.name}#{p.get_star}", p.score, p.fours, p.sixes, p.balls]
    end
    table = Terminal::Table.new(:title => "Scorecard for Team #{batting_team.name.capitalize}:", 
                                :headings => ['Player Name', 'Score', '4s', '6s', 'Balls'],
                                :rows => rows
                                )
    puts table
    puts "Total #{batting_team.score} / #{batting_team.outs}"
    puts "Overs #{batting_team.overs}"
    puts "Striker #{@striker.name}" rescue ''
  end
end
