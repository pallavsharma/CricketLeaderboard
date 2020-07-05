class Team
  BATTING = 'batting'
  FIELDING = 'fielding'

  attr_accessor :players, :available_players, :status, :name, :score, :outs, :overs

  def initialize(players, status=nil, name='', score=0, outs=0, overs=0)
    @players = create_players(players)
    @status = status
    @name = name
    @score = score
    @outs = outs
    @overs = overs
  end

  def available_players
    @players.select {|p| p.status == Player::STANDBY}
  end

  def add_over
    self.overs += 1
  end

  def add_outs
    self.outs += 1
  end

  private
  def create_players(order)
    players = []
    order.each_with_index do |name, order|
      players << Player.new(name, order+1, self)
    end
    players
  end
end
