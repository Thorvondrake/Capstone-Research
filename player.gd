extends Area2D
signal hit

var invincible := false

@export var speed = 400 #Player speed (Px/s)
var screen_size #Game window size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # Players movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D):
	if invincible:
		return
	hit.emit()
	

func die():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
func start(pos):
	position = pos
	invincible = false
	$AnimatedSprite2D.modulate.a = 1.0
	show()
	$CollisionShape2D.disabled = false


func start_invincibility():
	invincible = true
	var tween = create_tween().set_loops(6)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.3, 0.1)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 1.0, 0.1)
	await tween.finished
	invincible = false
