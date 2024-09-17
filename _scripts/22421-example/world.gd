extends Node2D

func play(animation):
	$player1.play(animation)
	$player2.play(animation)

func _on_up_pressed():
	play("walk-up")

func _on_right_pressed():
	play("walk-right")

func _on_left_pressed():
	play("walk-left")

func _on_down_pressed():
	play("walk-down")
