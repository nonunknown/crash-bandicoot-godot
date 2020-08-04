extends Control
class_name HUDWarp
enum Items {crystal, gem, second_gem, relic}
enum Relics {saffire,gold,platinum}

var flag_item:BitFlag
var flag_relics:BitFlag
onready var hud_items = [$LevelInfo/Crystal,$LevelInfo/WhiteGem,$LevelInfo/SecondGem,$LevelInfo/Relic]

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
