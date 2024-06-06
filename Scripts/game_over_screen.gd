extends Control

func _on_retry_button_pressed():
	get_tree().reload_current_scene()

func set_score(value):
	$Panel/Score.text = "SCORE: " + str(value)
	
func set_highscore(value):
	$Panel/HighScore.text = "HIGH SCORE: " + str(value)
