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
		["radiation sickness(Moderate)", 69 , 1, 30, sickness.radStage2]
	,
	sickness.radStage2:
		["radiation sickness(Severe)", 30 , 30, 40, sickness.radStage3]
	,
	sickness.radStage3:
		["radiation sickness(Lethal)", 1 , 99, 0, null]
}
func GetNameString(target: sickness):
	return sicknessArray[target][0]

#enter sickness, returns survive chance
func GetSurvivalChance(target: sickness):
	return sicknessArray[target][1]

func GetDeathChance(target: sickness):
	return sicknessArray[target][2]

func GetWorsenChance(target: sickness):
	return sicknessArray[target][3]

#enter sickness, returns worsen target
func GetWorsenTarget(target: sickness):
	var returnValue = sicknessArray[target][4]
	return returnValue
