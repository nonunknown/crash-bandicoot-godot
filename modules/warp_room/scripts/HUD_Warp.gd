extends Control
class_name HUDWarp
enum Items {crystal, gem, second_gem, relic}
enum Relics {saffire,gold,platinum}

var flag_item:BitFlag
var flag_relics:BitFlag
onready var hud_items = [$LevelInfo/Crystal,$LevelInfo/WhiteGem,$LevelInfo/SecondGem,$LevelInfo/Relic]
onready var initial_color = $LevelInfo/Crystal.modulate
func _init():
	add_to_group(str(Groups.HUD_WARP))

func _ready():
	flag_item = BitFlag.new(Items, true)
	flag_relics = BitFlag.new(Relics, true)
	check_items()
	print("sum: %d" % flag_item.get_active_keys_sum())
#	flag_item.put(flag_item.crystal)
#	print( str( flag_item.get_active_keys()))

func check_items():
	flag_item.put(flag_item.crystal)
	flag_item.put(flag_item.relic)
	for i in range(hud_items.size()):
		var item:VBoxContainer = hud_items[i]
		var k = flag_item._get(Items.keys()[i])
		if flag_item.check(k ):
			print(str(k))

func set_data(data:R_Level):
	print("data name %s\ndata got %s" % [data.name, str(data.got)])
	if data.type == data.TYPE.BOSS:
		$LevelInfo.visible = false
	else: $LevelInfo.visible = true
	
	for i in range(data.got.size()):
		print("i: "+str(i))
		var h = hud_items[i]
		if data.got[i]: 
			h.modulate = Color.white
			print("got one")
		else: h.modulate = initial_color
	
	#Boss name
	var boss_name = get_parent().get_node("Warp_data").data.boss_name
	$BossInfo/Name.text = boss_name
	
	var second_gem = $LevelInfo/SecondGem
	if data.items[2]: second_gem.visible = true
	else: second_gem.visible = false
	
	$LevelInfo/Level/Leve.text = data.name
	
	pass

func show():
	visible = true
	$AnimationPlayer.play("Show")
	pass

func hide():
	$AnimationPlayer.play("Hide")
	pass

func do_loop(hud:Control,target_pos:Vector2):
	while(!hud.rect_position.y == target_pos.y):
		hud.rect_position = lerp(hud.rect_position,Vector2(hud.rect_position.x,target_pos.y),0.1)
		yield(get_tree(),"idle_frame")
		pass

#func _process(delta):
#	if Input.is_action_just_pressed("ui_up"):
#		var data = SaveResource.new()
#		data.warp_1.boss_beaten = true
#		SaveManager.save_game(data)
#		print("saved")
#		pass
#	elif Input.is_action_just_pressed("ui_down"):
#		var data = SaveManager.load_game()
#		print("loaded")
#		print("is boss beaten: "+ str( data.warp_1) )
#		pass
