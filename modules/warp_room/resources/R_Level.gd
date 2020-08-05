extends Resource
class_name R_Level

enum TYPE { DEFAULT, BOSS}
#Level name (showed in UI)
export var name:String = "Level Name"
# Crystal,Gem,Second Gem, Relic
export var items:Array = [true,true,false,true]
export var got:Array = [false,false,false,false]
export(TYPE) var type = TYPE.DEFAULT
export var give_power:int = -1
