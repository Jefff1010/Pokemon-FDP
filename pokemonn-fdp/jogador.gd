extends CharacterBody2D

var tamanho_tile = 32
var duracao_movimento = 0.1

var direcao = Vector2.ZERO
var movendo = false

func _physics_process(delta: float) -> void:
	
	mover_grid()
	
	move_and_slide()

func mover_grid():
	
	if movendo == true:
		return
		
	direcao = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
	if direcao == Vector2.ZERO:
		return
		
	var posicao_final = position + (direcao*tamanho_tile)
	
	var movimento_tween = create_tween()
	
	movimento_tween.tween_property(self,"position", posicao_final, duracao_movimento)
	
	movendo = true
	
	await movimento_tween.finished
	
	movendo = false
