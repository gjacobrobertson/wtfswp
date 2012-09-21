#What The Fuck Should We Play?
Because what the fuck should we play? Inspired by the beautiful whatthefuckshouldimakefordinner.com, What The Fuck Should We Play is a rails 3.2 web application that gives random board game recommendations based on a boardgamegeek.com username and a number of players.

##Requirements
*      ruby 1.9.3
*      bundler 1.1.5
*      memcached 1.4 (in production environment only)

##Installation
       git clone git://github.com/gjacobrobertson/wtfswp.com
       cd wtfswp
       bundle install
       
##Usage
Just navigate to whatthefuckshouldweplay.com (or whatever URL you set up if you build from source), enter a valid BoardGameGeek username, and number of players that you have, and the app will tell you what the fuck to play. Result will always be a game that the user owns in their BGG Collection, and that is at least recommended for the given number of players. Results are weighted by the user's rating of the game, the average BGG rating, and the suggested number of players poll.