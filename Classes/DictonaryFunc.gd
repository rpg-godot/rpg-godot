class_name DictonaryFunc
var script_name = "dictonary_func"


# Get a given data from a dictionary with position provided as a list
static func getFromDict(dataDict, mapList):    
	for k in mapList: 
		dataDict = dataDict[k]
	return dataDict


# Set a given data in a dictionary with position provided as a list
# eg. path="dict.subdict.value"
#     setInDict(dict, path.split(".", false), value)
static func setInDict(dataDict, mapList, value):
	var dict = mapList
	dict.remove(dict.size() - 1)
	
	for k in dict: 
		dataDict = dataDict[k]
	dataDict[mapList[-1]] = value


static func merge_dict(target, patch):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge_dict(tv, patch[key])
			else:
				target[key] = patch[key]
		else:
			target[key] = patch[key]
 

static func find_all_value(_dict, target):
	for key in _dict.keys():
		#case 1: it is a dictionary but not match the key
		if typeof(_dict[key]) == TYPE_DICTIONARY and key != target:
			return find_all_value(_dict[key], target)
		#case 2: it is a dictionary but match the key -> put it in result
		elif typeof(_dict[key]) == TYPE_DICTIONARY and key == target:
			return [_dict[key]] + find_all_value(_dict[key], target)
		#case 3: it is not dictionary and match the key -> put it in result
		elif key == target:
			return [_dict[key]]
