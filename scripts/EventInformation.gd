class_name EventInformation extends Resource

###Event template###
#["title", "long description of the event",
# {"key": int}
#
#
#[
	#"",
	#"",
	#{},
	#[]
#]




#postive event array
#format :eventName :eventDesc :{resource change} :[events banned]
var positiveEventArray = [
	[
		"Great Hunt", 
		"the town's hunters had a great haul food +8",
		{"food": 8},
		["Bad Hunt"]
	],
	[
		"farming Surplus", 
		"the town’s farmers farmed a great surplus of food food +15",
		{"food": 15},
		["Drought"]
	],
	[
		"Ancient Weapons",
		 "the town’s scouts managed to find a stockpile of Ancient weapons left behind from the great war military perm +5",
		{"military": 5},
		[]
	],
	[
		"Machine AI",
		 "the town found a Great war Machine that houses an AI, it’s not that smart but its database of information will prove usefull ingenuity +3",
		{"ingenuity": 3},
		[]
	],
	[
		"Ancient Stockpile", 
		"the town’s scouts found a great war stockpile filled with food and water food +10 water +15",
		{"food": 10, "water": 15},
		[]
	],
	[
		"Rainfall Harvest",
		"After weeks of dry air, a strong rainfall filled the reservoirs water +15",
		{"water": 15},
		[]
	],
	[
		"Mutant Beast Hunt",
		"Hunters slew a dangerous mutant beast. Its meat was edible and hide could be used food +10 military +5",
		{"food": 10, "military": 5},
		[]
	],
	[
		"Restored Generator",
		"Settlers repaired an old generator and connected its wiring ingenuity +5 military +5",
		{"ingenuity": 5, "military": 2},
		[]
	],
	[
		"Forgotten Bunker",
		"A sealed bunker was found intact. Supplies inside were preserved food +5 water +8",
		{"food": 5, "water": 8},
		[]
	],
	[
		"Inspiring Leader",
		"settler.name inspired hope with a rousing speech, boosting morale military +5 ingenuity +5",
		{"military": 5, "ingenuity": 5, "settler": ""},
		[]
	]

	
	
	
]

var negativeEventArray = [
	[
		"Bad Hunt",
		 "the town’s hunters couldn’t find any food and got really hungry from their search food -3",
		{"food": -3},
		["Great Hunt"]
	],
	[
		"Drought",
		 "the town suffered a bad drought this week and the farmers 
		couldn’t grow any plants food -10 water -10",
		{"food": -10, "water": -10},
		["Drought"]
	], 
	[
		"Glowing Rock",
		"settler.name found a glowing rock and decided to take it home, unfortunately for everyone else it was radioative 1-3 people have gotten sick",
		{"settler": "" ,"radStage1": [1,3]},
		[]
	],
	[
		"Tainted Water",
		"the Town’s water source was contaminated with radioactive debris and had to be cleaned water -10 1-3 people have gotten sick",
		{"water": -10, "radStage1": [1,3]},
		[]
	],
	[
		"Radiation Storm",
		"A sudden storm swept through, exposing the settlers 1-4 people have gotten sick",
		{"radStage1": [1,4]},
		[]
	],
	[
		"Faulty seal",
		"A small leak in the tank exposes the operator to ambient radiation 1 person has gotten sick",
		{"radStage1": [1,1]},
		[]
	],
	[
		"Radioactive rain",
		"Radioactive rain contaminated the drinking water 1-3 people have gotten sick water -5",
		{"radStage1": [1,3], "water": -5},
		[]
	],
	[
		"Abandoned Hospital",
		"A scouting team explored an old hospital. The walls still leaked radiation ingenuity +2 1-3 people have gotten sick moderately sick",
		{"ingenuity": 2, "radstage2": [1,3]},
		[]
	]
]
