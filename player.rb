class Player
  
  STRIKER = 'striker'
  NON_STRIKER = 'non_striker'
  OUT = 'out'
  STANDBY = 'standby'
  STATUS = [STRIKER, NON_STRIKER, OUT, STANDBY]
  
  attr_accessor :name, :score, :status, :team, :balls, :fours, :sixes

  def initialize(name='', order=nil, team=nil, score=0, status=STANDBY, fours=0, sixes=0, balls=0)
    @name = name
    @order = order
    @score = score
    @status = status
    @team = team
    @fours = fours
    @sixes = sixes
    @balls = balls
  end

  def get_star
    return '*' if [STRIKER,NON_STRIKER].include? self.status
    return 'W' if self.status == OUT
  end

  def add_fours
    self.fours += 1
  end

  def add_sixes
    self.sixes += 1
  end

  def add_ball
    self.balls += 1
  end

  def remove_ball
    self.balls -= 1
  end

  def add_score(run)
    self.score += run
    self.team.score += run
  end
end
