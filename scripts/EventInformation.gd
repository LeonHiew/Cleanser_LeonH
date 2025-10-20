class_name EventInformation extends Resource

###Event template###
#["title", 
#"long description of the event",
# {"key": int} #key = resource affected, int = value, doesn't have to be int
# [banned event title], used to stop similar events from triggering in a round
#
#[
	#"",
	#"",
	#{},
	#[]
#]



#postive event array
#format :eventName :eventDesc :{resource change} :[events banned]
var positiveEventArray = {
	"Common":
		[

			[
				"Ancient Weapons",
				 "the town’s scouts managed to find a stockpile of Ancient weapons left behind from the great war",
				{"military": 2},
				[]
			],


			[
				"Rainfall Harvest",
				"After a week of dry air, a strong rainfall fell on us filling the reservoirs",
				{"water": 2},
				[""]
			],


			[
				"Forgotten Bunker",
				"A sealed bunker was found intact. Supplies inside were preserved",
				{"food": 2, "water": 2},
				[]
			],

			
		],
	"Uncommon":
		[
			[
				"Ancient Stockpile", 
				"the town’s scouts found a great war stockpile filled with food and water",
				{"food": 3, "water": 4},
				[]
			],
			[
				"Great Hunt", 
				"our hunters found an untouched valley filled with prey",
				{"food": 5},
				["Bad Hunt"]
			],
			[
				"Restored Generator",
				"Settlers repaired an old generator and connected its wiring",
				{"ingenuity": 2, "military": 2},
				[]
			],

		],
	"Rare":
		[
			[
				"Machine AI",
				 "We found a Great war Machine that houses an AI, it’s not that smart but its database of information will prove useful",
				{"ingenuity": 5},
				[]
			],
			[
				"Psychic sooth",
				"you hear a voice, calm and relaxing, maybing living here isn't such a bad idea after all",
				{"Mood": 1},
				["Psychic drone"]
			],
			[
				"old fertilizer", 
				"our farmers found a old war era bag of fertilizer, using it boosted our crop yields ",
				{"food": 6},
				["Drought"]
			],
			[
				"Mutant Beast Hunt",
				"Hunters slew a dangerous mutant beast. Its meat was edible and hide could be used for armour",
				{"food": 5, "military": 3},
				[]
			],
			[
				"Inspiring Leader",
				"settler.name inspired hope with a rousing speech, boosting morale",
				{"military": 3, "ingenuity":3, "settler": ""},
				[]
			]
		]
}



var negativeEventArray = {
	"Common":
		[
			[
				"Bad Hunt",
				 "our hunters couldn’t find any food and got really hungry from their search",
				{"food": -5},
				["Great Hunt"]
			],

			[
				"Glowing Rock",
				"settler.name found a glowing rock and decided to take it home, unfortunately for everyone else it was radioative",
				{"settler": "" ,"radStage1": [1,3]},
				[]
			],
			[
				"Tainted Water",
				"the Town’s water source was contaminated with radioactive debris and had to be cleaned water",
				{"water": -6, "radStage1": [1,2]},
				[]
			],

			[
				"Faulty seal",
				"while making repairs to the healing tank, the waste water seal broke spilling radioactive waste",
				{"radStage1": [1,1]},
				[]
			],


		],
	"Uncommon":
		[
			[
				"Radioactive rain",
				"the rain this week was filled with radiation,contaminating our water and making some people sick",
				{"radStage1": [1,3], "water": -7},
				["Radiation Storm"]
			],
			[
				"Drought",
				 "we suffered a bad drought this week and the farmers couldn’t grow any plants",
				{"food": -8, "water": -8},
				["Rainfall Harvest"]
			], 
			[
				"Drought",
				 "we suffered a bad drought this week and the farmers couldn’t grow any plants",
				{"food": -8, "water": -8},
				["Drought"]
			], 
		],
	"Rare":
		[
			[
				"Abandoned Hospital",
				"We sent a team to explore an old hospital. we managed to find some useful data, but the old corpses of the patients still leaked severe radiation",
				{"ingenuity": 2, "radstage2": [1,3]},
				[]
			],
			[
				"Radiation Storm",
				"A sudden storm swept through, exposing the settlers to severe radiation and contaminating our water",
				{"radStage2": [1,4], "water": -10},
				["Radioactive rain"]
			],
			[
				"Psychic drone",
				"you hear a voice, scratching at the back of your mind, you don't like what it's saying",
				{"Mood": -1},
				["Psychic sooth"]
			],
		]
	}
