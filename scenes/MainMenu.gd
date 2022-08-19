extends Node

export (String, FILE, "*.tscn,*.scn") var game_path:String

func start_game():
	get_tree().change_scene(game_path)
#	get_tree().change_scene("res://Main.tscn")
