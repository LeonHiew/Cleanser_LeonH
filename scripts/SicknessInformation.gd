class_name SicknessInformation extends Resource

enum sickness
{
	notSick,
	radStage1,
	radStage2,
	radStage3,
}

#format  name, survive chance, deeath chance, worsen chance, what is worsens to
var sicknessArray = {
	sickness.notSick:
		["Not Sick", 100, 0 , 0, null]
	,
	sickness.radStage1:
		["radiation sickness(stage 1)", 69 , 1, 30, sickness.radStage2]
	,
	sickness.radStage2:
		["radiation sickness(stage 2)", 30 , 30, 40, sickness.radStage3]
	,
	sickness.radStage3:
		["radiation sickness(stage 3)", 1 , 99, 0, null]
}
func GetNameString(sickness):
	return sicknessArray[sickness][0]

#enter sickness, returns survive chance
func GetSurvivalChance(sickness):
	return sicknessArray[sickness][1]

func GetDeathChance(sickness):
	return sicknessArray[sickness][2]

func GetWorsenChance(sickness):
	return sicknessArray[sickness][3]


#enter sickness, returns worsen target
func GetWorsenTarget(sickness):
	var target = sicknessArray[sickness][4]
	return target
