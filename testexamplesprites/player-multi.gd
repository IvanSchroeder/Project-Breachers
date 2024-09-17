extends Node2D

func play(animation):
	$character_base/animation_player.play(animation)
	$prison_jumpsuit/animation_player.play(animation)
