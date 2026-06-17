extends Area2D



func _on_body_entered(body: Node2D) -> void:
	$"../FadeOut".play("FadeOut")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://fase.tscn")
