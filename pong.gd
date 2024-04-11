extends Node2D  # Indicates that this script extends Node2D, making it a 2D game object.

# Member variables - think of these like your game's personal notes.
var screen_size  # Stores the size of the game window.
var pad_size  # Stores the size of the paddles.
var direction = Vector2(1.0, 0.0)  # Sets the initial direction for the ball to move to the right.

# Constants for ball and pads speed - like setting the rules for how fast things can go.
const INITIAL_BALL_SPEED = 80  # The starting speed of the ball.
var ball_speed = INITIAL_BALL_SPEED  # The current speed of the ball, starts at initial speed.
const PAD_SPEED = 150  # How fast the paddles can move.

func _ready():
	# This is called when the game starts, to set everything up.
	screen_size = get_viewport_rect().size  # Finds out how big the game window is.
	pad_size = get_node("left").get_texture().get_size()  # Measures the size of the left paddle.
	set_process(true)  # Tells Godot to start running the _process function repeatedly.

func _process(delta):
	# This function is like the heartbeat of the game, it's called all the time to update the game.
	# Get current ball position.
	var ball_pos = get_node("ball").position
	
	# Create invisible rectangles to know where our paddles are.
	var left_rect = Rect2(get_node("left").position - pad_size * 0.5, pad_size)
	var right_rect = Rect2(get_node("right").position - pad_size * 0.5, pad_size)

	# Moves the ball according to its speed and direction.
	ball_pos += direction * ball_speed * delta

	# Checks if the ball hits the top or bottom of the screen and makes it bounce.
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y

	# Checks if the ball hits a paddle and makes it bounce.
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x  # Bounce horizontally.
		direction.y = randf() * 2.0 - 1  # Adds a random factor to the vertical bounce.
		direction = direction.normalized()  # Keeps the ball's speed consistent.
		ball_speed *= 1.1  # Each bounce off a paddle makes the ball a little faster.

	# Checks if the ball has missed the paddles and restarts the game.
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		ball_pos = screen_size * 0.5  # Puts the ball back in the middle.
		ball_speed = INITIAL_BALL_SPEED  # Resets the ball speed to the initial speed.
		direction = Vector2(1 if randf() > 0.5 else -1, 0)  # Chooses a new horizontal direction randomly.

	# Applies the new ball position.
	get_node("ball").position = ball_pos

	# Controls for moving the left paddle up and down.
	var left_pos = get_node("left").position
	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta  # Moves the paddle up.
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta  # Moves the paddle down.
	get_node("left").position = left_pos

	# Controls for moving the right paddle up and down.
	var right_pos = get_node("right").position
	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta  # Moves the paddle up.
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta  # Moves the paddle down.
	get_node("right").position = right_pos
