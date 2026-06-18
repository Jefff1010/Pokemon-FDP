extends CharacterBody2D
var facing_dir = Vector2i.ZERO
var tamanho_tile = 16
@export var duracao_movimento = 0.3

# Converter as variáveis de Vector2 para Vector2i
var direcao := Vector2i.ZERO
var movendo = false

# Acessar o TileMapLayer e a posição no tabuleiro do jogador
@export var grade_fase : TileMapLayer
var posicao_grid = Vector2i.ZERO

func _ready() -> void:
	facing_dir = Global.facing_dir
	# Pegamos qual casa mais próxima do centro do jogador e depois movemos o jogador para a posição especifica dessa casa
	posicao_grid = grade_fase.local_to_map(position)
	position = grade_fase.map_to_local(posicao_grid)
	
func _physics_process(delta: float) -> void:
	
	mover_grid()
	
	atualizar_animacao()
	move_and_slide()

func atualizar_animacao():
	if facing_dir == Vector2i.UP and movendo == true:
		$AnimatedSprite2D.play("Walk Back")
	elif facing_dir == Vector2i.DOWN and movendo == true:
		$AnimatedSprite2D.play("Walk Front")
	elif facing_dir == Vector2i.RIGHT and movendo == true:
		$AnimatedSprite2D.play("Walk Direita")
	elif facing_dir == Vector2i.LEFT and movendo == true:
		$AnimatedSprite2D.play("Walk Esquerda")
	elif facing_dir == Vector2i.UP and movendo == false:
		$AnimatedSprite2D.play("Idle Back")
	elif facing_dir == Vector2i.DOWN and movendo == false:
		$AnimatedSprite2D.play("Idle Front")
	elif facing_dir == Vector2i.LEFT and movendo == false:
		$AnimatedSprite2D.play("Idle Esquerda")
	elif facing_dir == Vector2i.RIGHT and movendo == false:
		$AnimatedSprite2D.play("Idle Direita")

func mover_grid():
	
	if movendo == true:
		facing_dir = direcao
		return
		
	direcao = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
	if direcao == Vector2i.ZERO:
		return
	
	if direcao.x != 0 and direcao.y != 0:
		direcao = Vector2i(sign(direcao.x), 0)
		
	# Onde o jogador está agora
	posicao_grid = grade_fase.local_to_map(position)
	
	# Calcular para onde ele vai se mover
	var coordenadas_final = posicao_grid + direcao
	
	# Coletar o bloco para onde estamos nos movendo
	var proximo_bloco = grade_fase.get_cell_tile_data(coordenadas_final)
	
	# Se o proximo bloco for nulo, encerrar a função
	if proximo_bloco == null:
		return
	
	# Se o proximo bloco for Blocked, encerrar a função
	if proximo_bloco.get_custom_data("Blocked") == true:
		return
	
	var posicao_final = grade_fase.map_to_local(coordenadas_final)
	
	var movimento_tween = create_tween()
	
	movimento_tween.tween_property(self,"position", posicao_final, duracao_movimento)
	
	#var scale_tween = create_tween()
	#if direcao.x != 0:
		#scale_tween.tween_property(self, "scale", Vector2(1.2,0.8), 0.15)
	#else:
		#scale_tween.tween_property(self, "scale", Vector2(0.8,1.2), 0.15)
	#scale_tween.tween_property(self, "scale", Vector2(1,1), 0.15)
	
	movendo = true
	
	await movimento_tween.finished
	
	movendo = false
	
	


func _on_sair_da_casa_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
