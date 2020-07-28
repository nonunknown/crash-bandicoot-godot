extends Node

func sort_dict(data) -> Array:
	var temp_arr:Array = []
	var keys_arr:Array = []
	var value_arr:Array = []
	var moved_idx:Array = []
	var _min:float = 1000
	
	#fill the arrays
	for key in data:
		if data[key] > 900: continue
		keys_arr.append(key)
		value_arr.append(data[key])
#	print(str(keys_arr))
#	print(str(value_arr))
#
	#sort values with indexes changed pos in moved_idx
#	var rounds = 0
	while(temp_arr.size() != keys_arr.size()):
#		rounds += 1
		var idx = -1
		_min = 1000
		for i in range(value_arr.size()):
			if value_arr[i] < _min and !temp_arr.has(value_arr[i]):
				_min = value_arr[i]
				idx = i
				
				
				i = 0
				continue
			
		temp_arr.append(_min)
		moved_idx.append(value_arr.find(_min))
#		print("Round %d: \nTEMP: %s\nVALUE: %s\n\n" % [rounds, str(temp_arr), str(value_arr)])
		
	
#	print(str(moved_idx))
#	print("expected: [3,1,2,0]")
	
	#return the organized dict
	var result = []
	for i in range(keys_arr.size()):
		result.append({
			name=keys_arr[moved_idx[i]] ,
			time=temp_arr[i]
			})
	
#	print("Final result: "+ str(result))
	return result
