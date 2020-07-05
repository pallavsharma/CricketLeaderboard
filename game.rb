# gem install terminal-table

require_relative 'cricket.rb'
players_info = {'team1' => [1,2,3,4,5],
                'team2' => [6,7,8,9,10]
              }
overs = 2
c = Cricket.new(players_info, overs)

c.play_over([1,1,1,1,1,2])
c.play_over(['W',4,4,'WD','W',1,6])

c.play_over([4,6,'W','W',1,1])
c.play_over([6,1,'W','W'])
