class_name SettlerStats extends Resource


#-Name 
#-Short Description of the Settler and their role in the town
#-current mood (Terrible, Bad, Fine, Good,Great)
#-production stats (food, water, military, ingenuity)and what they contribute to the town
#-Consumption (eg, food -2, water -1) , what they consume in a week

#settler information

@export var settlerName = ""
@export var settlerDesc = ""

#settler assets
@export var settlerPortrait = Texture2D
@export var settlerChibiPortrait = Texture2D
@export var settlerChibi = Texture2D

@export var bIsDead = false
@export var bIsResting = false

#settler production stats
@export var foodProduction = 0
@export var waterProduction = 0
@export var militaryProduction = 0
@export var ingenuityProduction = 0

#settler mood stats
#later down the line will put stuff here related to mood but for now
@export var settlerMood = settlerMoods.Great

enum settlerMoods {
	Great,
	Good,
	Fine,
	Bad,
	Terrible
}

#settler drain stats
@export var foodDrain = 1
@export var waterDrain = 1

#sickness
@export var sickness = SicknessInformation.sickness.notSick
