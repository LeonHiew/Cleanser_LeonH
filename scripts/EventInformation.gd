class_name EventInformation extends Resource

###Event template###
#["title", "long description of the event",
# {"key": int}
#
#
#]

#postive event array
#format :eventName :eventDesc :{resource change} :[events banned]
var positiveEventArray = [
	[
		"Great Hunt", 
		"the town's hunters had a great haul",
		{"food": 8},
		["Bad Hunt"]
	],
	[
		"farming Surplus", 
		"the town’s farmers farmed a great surplus of food",
		{"food": 15},
		["Drought"]
	],
	[
		"Ancient Weapons",
		 "the town’s scouts managed to find a stockpile of Ancient weapons left behind from the great war ",
		{"military": 5},
		[]
	],
	[
		"Machine AI",
		 "the town found a Great war Machine that houses an AI, it’s not that smart but its database of information will prove usefull",
		{"ingenuity": 10},
		[]
	],
	[
		"Ancient Stockpile", 
		"the town’s scouts found a great war stockpile filled with food and water",
		{"food": 10, "water": 10},
		[]
	]
]

var negativeEventArray = [
	[
		"Bad Hunt",
		 "the town’s hunters couldn’t find any food and got really hungry from their search",
		{"food": -3},
		["Great Hunt"]
	],
	[
		"Drought",
		 "the town suffered a bad drought this week and the farmers 
		couldn’t grow any plants",
		{"food": -10, "water": -10},
		["Drought"]
	], 
	[
		"Glowing Rock",
		"settler.name found a glowing rock and decided to take it home, unfortunately for everyone else it was radioative",
		{"settler": "" ,"radStage1": [1,3]},
		[]
	]
]
