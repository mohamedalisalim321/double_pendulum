extends Node2D

# Constants
var origin # Center of the screen
const radius = 15  # Radius of pendulum bobs
var g = 9.8  # Gravitational acceleration

# Pendulum 1
var color_one = Color.RED
var point_one = Vector2()
var mass_one = 1
var theta_one = PI / 2  # Initial angle
var theta_one_velocity = 0.0
var leng_one = 50  # Length of the first pendulum arm

# Pendulum 2
var color_two = Color.BLUE
var point_two = Vector2()
var mass_two = 1
var theta_two = PI / 2  # Initial angle
var theta_two_velocity = 0.0
var leng_two = 50  # Length of the second pendulum arm

@onready var line = $Line2D
@onready var line2 = $Line2D2

func _ready() -> void:
	origin = Vector2(get_viewport().size / 2)
	Engine.time_scale = 8
	line.default_color = color_one
	line2.default_color = color_two
	line.clear_points()
	line2.clear_points()

func _process(delta: float) -> void:
	$UI/HBoxContainer/Labels/Length1T.text = "Length-1: " + str(leng_one)
	$UI/HBoxContainer/Labels/Length2T.text = "Length-2: " + str(leng_two)
	$UI/HBoxContainer/Labels/Mass1T.text = "Mass-1: " + str(mass_one)
	$UI/HBoxContainer/Labels/Mass2T.text = "Mass-2: " + str(mass_two)
	$UI/HBoxContainer/Labels/GravityT.text = "Gravity: " + str(g)

	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("space"):
		line.clear_points()
		line2.clear_points()

func _physics_process(delta: float) -> void:
	# Calculate angular accelerations using double pendulum equations
	var delta_theta = theta_one - theta_two
	var den1 = (2 * mass_one + mass_two - mass_two * cos(2 * delta_theta))
	
	var alpha1 = -g * (2 * mass_one + mass_two) * sin(theta_one)
	var alpha2 = -mass_two * g * sin(theta_one - 2 * theta_two)
	var alpha3 = -2 * sin(delta_theta) * mass_two * (theta_two_velocity * theta_two_velocity * leng_two + theta_one_velocity * theta_one_velocity * leng_one * cos(delta_theta))
	var theta_one_acceleration = (alpha1 + alpha2 + alpha3) / (leng_one * den1)
	
	var beta1 = 2 * sin(delta_theta)
	var beta2 = theta_one_velocity * theta_one_velocity * leng_one * (mass_one + mass_two)
	var beta3 = g * (mass_one + mass_two) * cos(theta_one)
	var beta4 = theta_two_velocity * theta_two_velocity * leng_two * mass_two * cos(delta_theta)
	var theta_two_acceleration = (beta1 * (beta2 + beta3 + beta4)) / (leng_two * den1)
	
	# Update angular velocities and angles
	theta_one_velocity += theta_one_acceleration * delta
	theta_two_velocity += theta_two_acceleration * delta
	theta_one += theta_one_velocity * delta
	theta_two += theta_two_velocity * delta
	
	# Update positions of pendulum bobs
	point_one.x = origin.x + leng_one * sin(theta_one)
	point_one.y = origin.y + leng_one * cos(theta_one)
	
	point_two.x = point_one.x + leng_two * sin(theta_two)
	point_two.y = point_one.y + leng_two * cos(theta_two)
	
	line.add_point(point_one)
	line2.add_point(point_two)
	queue_redraw()

func _draw() -> void:
	draw_line(point_one, point_two, color_two, 2)
	draw_circle(point_two, radius, color_two)
	
	draw_line(origin, point_one, color_one, 2)
	draw_circle(point_one, radius, color_one)

func _on_length_1s_value_changed(value: float) -> void:
	leng_one = value


func _on_length_2s_value_changed(value: float) -> void:
	leng_two = value


func _on_mass_1s_value_changed(value: float) -> void:
	mass_one = value


func _on_mass_2s_value_changed(value: float) -> void:
	mass_two = value # Replace with function body.


func _on_gravity_s_value_changed(value: float) -> void:
	g = value
