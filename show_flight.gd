extends HBoxContainer


func _process(delta):
    visible = (
        GlobalManager.player.is_flight_allowed() or GlobalManager.player.state is Player.Flying
    )
    if GlobalManager.player.state is Player.Flying:
        $Label.text = "CURL"
    else:
        $Label.text = "FLY "
