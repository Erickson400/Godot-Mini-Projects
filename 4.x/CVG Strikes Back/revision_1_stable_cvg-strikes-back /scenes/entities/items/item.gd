extends AnimatedSprite2D

# State 0 - inactive
# State 1 - going up and towards the facing direction
# State 2 - going up and towards the facing direction
var state = 0

# Direciton is also the speed in which it moves. Its either 2 or -2.
var dir = 0
