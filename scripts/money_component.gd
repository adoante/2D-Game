extends Node2D

class_name MoneyComponent

func earn():
	GameManager.player_money += 1 * GameManager.coin_multiplier
	GameManager.level_earned_money += 1 * GameManager.coin_multiplier
