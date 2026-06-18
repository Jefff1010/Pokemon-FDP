extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Trainer"):
		$"../AnimationPlayer".play("FadeOut")
		await get_tree().create_timer(1).timeout
		Global.facing_dir = body.facing_dir
		get_tree().change_scene_to_file("res://Mom's House.tscn")
