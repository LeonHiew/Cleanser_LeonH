 							Cleanser
Working at [drive folder](https://drive.google.com/drive/folders/1BkrRELmQ1t2c_jsFfaNaNqXFmQ7sx_RI) and update on GIT as much we have.
================================================
Developed by
Caelan Legg
Thi Hoang Oanh Nguyen
Leon Hiew
Michael Wang
================================================
## CONTROLS ##
 mouse left click
	 on buttons on the screen
ESC 
	while playing opens up pause menu


## IMPORTANT NOTES FOR TUTORS
Godot has inbuilt functions that are marked with the prefix "_" 
for example _ready() is the engines on ready function
and thus cannot be renamed

godot also does not have public and private functions the prefix "_" is used within the code to signify that a function is private and not to be called outside the function

the code produced by us can be found in the scripts folder with the suffix .gd

Godot uses a custom language called gdscript with the same syntax as Python
 

we are also also aware of an annoying bug with godot.
for some reason every time its updated with git every single piece of text in the game has its spaces (\n) duplicated, resulting in hard coded text displays looking really bad. we tried to fix what we can, but due to time constraints we couldn't eliminate the bug in its entirely

### Story of the game:
- The game is set in a post-apocalyptic world ravaged by the nuclear Armageddon caused by the great war. You the player are a "Cleanser" preservers of the powerful  bio-rejuvenation tanks able to cure any and all mental and physical ailments. having completed your initiation you have been charged with the management and construction of a brand new settlement, your task is to ensure the settlements survival by strategically managing its resources until the settlers arrive to live in the town. being a Cleanser you also bring along with you a single bio-rejuvenation tank, usable once a week you must manage its use wisely by strategically choosing each week who gets to use the tank, use it to safe the sickly child? or the farmer vital for food production, the choice is yours and the consequences may be fierce.

- The task is simple. Keep your town alive until more people arrive.
===============================================

### How to Play ### 
- each round (except round 0) 3 random events are rolled that have positive or negative afffects.
- each round, every settler produces resources, food and water is additive to the towns total but Ingenuity and Military are not, and if the settler were to die they would not longer provide does numbers to the town
- during each round, players can choose a town settler to cure of sickness and increase in mood  or rest, this is done by clicking on their screen in a TV and opening up their logbook.
- resting costs 3 food and 3 water and ensures that a settler cannot die
- sicknesses are caused by events, and can lead to death or getting worse, so curing is a must
- to progress the round and survive the player must have enough food and water to feed each settler once. (eg 8 settlers need 8 food and 8 water)
- periodly bandit raids occur increasing in strength, keep an eye out on the towns military to ensure you can win against them
- every now and then a trader may appear randomly, you can sell resources infinitly but only buy them once.
- if all settlers die its game over
- reach the end of round 15 with atleast 1 settler alive and win


Controls:
- This game has been made with players using keyboard and mouse in mind due to time constraints, but with furthuer development controller support would be possible
- "Left Mouse Button"- To click on any buttons available on screen 
- "Esc" button- To open up the pause menu 


### Core Gameplay Mechanic ###
The core mechanic of the game revolves around the players ability to heal a settler once a week
This Heal cures them of all sickness as well as increases their mood.



### supplementary Mechanics ###
-Settlers
	Settlers themselves are a resource, each week they produce food and water for town, consume 1 food and water each, and provide military and ingenuity for the town, however they can die, be it sickness or some other cause'
	resulting in them not producing any resource anymore. this results in the player having to think carefully about who they heal, to ensure the towns survival

-Resources 
	there are 5 resources in the game
	- Military (required to pass bandit raid skill checks)
	- Food  (required for each settler to live)
	- Water (required for each settler to live)
	- Ingenuity  (increases the chance for a good event, was going to also be used for skill checks but ran out of time)
	- Scrap (currency/money used for trading)

-Events system
	at the begining of each round, 3 events are randomly selected resulting in positive or negtive affects on the town,
	events can give players food and water as well as permanent military and ingenuity increases, they can also result in loss of food and water as well as sicknesses.
	the system acts as the main way to apply sicknesses to settlers

-Sickness System
	there are three sicknesses in the game
	1. radiation stage 1 (moderate)     Survival Chance 60, death chance 10, worsen chance 30
	2. radiation stage 2 (severe)       Survival Chance 30, death chance 30, worsen chance 40
	3. radiation stage 3 (lethal)       Survival Chance 1, death chance 99, worsen chance 0
	
	if a settler survives they do not die but remain sick, if they roll worsen they proceed to a higher stage of illness
	if they roll death, the effect settler dies

-Mood System 
	each settler has a Mood, the better the mood the more resources they produce
	The moods and their times bonus are
		"Great": moodBonus = 1.5 
		"Good": moodBonus = 1.3
		"Fine": moodBonus = 1
		"Bad": moodBonus = 0.7
		"Terrible": moodBonus = 0.5
	each week they have a 30% chance to increase or decrese in mood by 1 until they are fine
	Healing maximised mood
	each week of being sick decreases mood

-Trade System 
	to add another layer of control each week traders may visit the town, allowing players the opportunity to buy and trade resources they may be desperate for

-Bandit Raid system
	during weeks 2, 5 , 10 and 15 a bandit raid occurs
	players are given warn of when these raids occur
	each bandit raid has an increasaing Military skill check, pass the skill check and earn some resources, lose the skill check and lose resources and potentially lose a settler

-Rest System
	Players can choose to make a settler Rest instead of heal them, it doesn't cure them of their illness but ensures that they cannot die from it
	it does however cost 3 food and water



### Level Design ###
our game is a 2D single screen experience, the player doesn't really explore any environment so all the theory is in context of this.

in this context, landmarks specifically represent a different section of the game that displays information

With this context the game includes two main landmarks, the Settler Tv screens and the information displays.

the Settler TV screens are front and center, visually representing the settlers in the game, most importantly displaying whether or not a settler is sick through colour
white = not sick, yellow = sick, green = resting

importantly each tv screen with a settler is also a button that opens its respective settlerbook.
the Settlerbook is also specifically placed in a position under the information displays to ensure the player always has visibility of them

the second landmark, the information displays, exist solely to display important information to the player.

this information has also been categorised
	left screen: Resources, food, water and scraps
	left middle screen: power resources, military and ingenuity
	right middle screen: current heals left (it was the trader screen but we ended up changing it)
	right screen: time till next raid event, and current round


A minor landmark also included is the trader landmark.
whenever a trader is in town, a small person will appear next to the tv screens, acting as a button to that screen

and finally all the buttons
The most important button is the progress week button, hence its been placed at the middle bottom section of the screen, as its intended to be assessed last by the player.
as well as the show events screen on the bottom left, tucked away because most players won't need to look at the events screen again


There are also two screens that display over the game when certain conditions are met.
The first is the event screen that displays when they press show event cards or progress week.
being information that only affects a round once, it only needs to be displayed once to the player, with the ability to see it again by pressing a button

another is the raid screen that displays the results of a bandit raid, again displayed separately because the player does not need to assess it more than once



### Balancing ###
the biggest challenge with this games development
having heard a second playtest day was planned we decided to push to get all game elements completed in time for this so that we may take notes for balancing
the key note was food and water is produced by way to much

tldr at the bottom

The games economy has 3 major resource generation components
	1. Settlers 
	each week they produce food and water and apply Ingenuity and Military to the town while each also drain 1 food and water each.
	being the biggest source of stress for the player they are the only guaranteed source of resources
	in total with all 8 settlers alive they produce 12 food and water each week, meaning assuming they are all alive they will produce enough food for the next weeks survival and half the week after
	this changes with the mood system, with them produce 1.5 times more at all high or 0.5 times less at all low Moods.
	resulting in either barely producing resources or producing an abundance.
	the resource generation has also been purposely spread out to force players to decide which settlers are more important based on their resource generation'
	
		Mood
		Settlers each have a mood, the higher the mood the more resources the produce
			"Great": moodBonus = 1.5 
			"Good": moodBonus = 1.3
			"Fine": moodBonus = 1
			"Bad": moodBonus = 0.7
			"Terrible": moodBonus = 0.5
		this system was put in place to give players more choice in who they pick to heal, say the only sick person provides military but the town farmer is very sad and not producing allot of resources, the towns survival may 		depend on giving them the heal so that they can produce more for the community.
		this system also acts as a way to ensure the heal is still important even if no one is sick

		to ensure no settler remains at a Great or terrible mood (besides events that can mass increase or decrease) each round they have a 30% of increasing of reducing their mood to bringing them closer to being "Fine"

	2. Events
	Each week 3 events are randomly rolled, this was particularly hard to balance due to its inherent randomness.
	The first important aspect of an event is whether its positive or negative. Having tried many linear and exponential equations on the website Desmos (to get a visual graph) we ended up with this equation
	 20 + 80*(1 - exp(-0.02352 * townIngenuity))   (exp represents e or Euler's number)
	this equation was chosen because we wanted to exponentially decrease the positive luck gain as ingenuity increases, resulting in 60 ingenuity being 100% (an almost impossible value for a player to get too). This equation also 	results in 20 ingenuity being around 50% chance for a positive event, as well as 20% positive event chance at 0 ingenuity, ensuring the player isn’t 100% locked out of positive events ever, and may strike a hand of really good 	luck potentially saving a game

	The second aspect is event rarity, due to 3 events being rolled at a  time, we ended up with Common at an 80% chance, Uncommon at a 18% chance and rare at a 2% chance to ensure rare events feel actually rare.
	In terms of balancing rewards from these events we balanced it around the idea of how much supplies it produces a week
	Positive Common events give ¼ of an weeks worth of supplies, Uncommon events give about half while rare gives around a weeks worth of supplies, on the flip size negative common events take half, Uncommon events take a weeks 	worth and rare uncommon’s take more then a weeks worth. This was done to drain resources from the passive settler generation, increasing the importance of keeping settlers alive


	3. Trade
	The trade event is a random event that will have a chance of occurring each week, there is a base 30% chance that a trade event will happen each week however if the player does not get the trade event in the week, the percentage 	for a trade event to occur in the next week will increase by 15% each week until a trade event occurs(which will reset the percentage back to 30%). If the player does get the trade event, a maid like character will appear near 	the bottom left of the screen with the label "Open Trades". Once player has clicked on the character, they will be taken to a separate screen specifically for trades. In this screen, players can still see they're resource 	amounts and the weeks left until the next raid like in the main play scene, however there are now 2 tables for trades, one being the "Buy trades" and the other for the "Sell trades". 
	In the "buy trades" box, the player will be able to buy a resource of a randomized number in exchange for a randomized number of scraps. The resources trade value are randomised each week there is a trade option for the player. 	Players can only buy trades once and cannot repeat the same purchase.
	In the "sell trades" box, the player can sell a randomised number of their resource for scraps. The player can sell as much as they want, as long as their resource does not go below 0 or below the base number of the resource. 	The sell trade's amount of resource for scrap will also be randomised each new week there is a new trade event. 
	There is also a box for the rules of trade that the player can open at any time to remind themselves of the rules for the trade event.
	To return to the main play screen, the player just needs to press on the maid icon labeled "Return to main screen". 
	The purpose of this trade system is to give the player more involvement in deciding which resources they need to prioritise in buying and which resource they can sell in order to gain scraps. This does also help a bit with 	balancing the game as it acts as a drain to resources to gain other resources and provides the players with a means of saving themselves when their situation is dire or helping them stabilize their game.  	

 
	having tried our best to balance this we realized that there is just too much resource generation and not enough focus on keeping settlers alive (this was especially prevalent during the final minor prototype submission)
	so we added a 4th mechanic:
	Resting
	each week the player has the choice to make a settler rest instead of healing them via the tank, doing so costs a weeks worth of resources and has the benefit of keeping a settler from dying from an illness, however they don't 	produce any resources, both solving the potential problem of events causing way to many people to get ill resulting in game overs and draining the players resources.
	this also came with the removal of settlers getting better by themselves, forcing players to make more risky decisions 

outside of econmoy are sicknesses.
we wanted to do more with this system but ended up just leaving it at 3 different sicknesses
each sickness has a survival chance, death chance and worsen chance (chance to progress stage eg stage 1 -> stage 2)
	1. radiation stage 1 (moderate)     Survival Chance 60, death chance 10, worsen chance 30
	2. radiation stage 2 (severe)       Survival Chance 30, death chance 30, worsen chance 40
	3. radiation stage 3 (lethal)       Survival Chance 1, death chance 99, worsen chance 0

you may notice that Lethal has a 1% chance of survival, we thought it would be a fun mechanic if a settler could rarely survive it, possibly causing high moment for the player if they win the gamble

balance of this changed alot over time, Moderate used to be an exact copy of lethal except suvival chance was 69 and death 1
in the end we decided to increase the death chances for everything

Death being the key adversery to the player and only caused via failed bandit raids and sicknesses we made all sicknesses cause death.

after our week 11 playtest survival chance had one big chance, it used to be the chance the settler heals themselves from the illness.
however due to the economy being was to forgiving, ruining the impact of picking who gets to go into the tank, we decided to remove this and instead make surviva chance just lead to nothing changing.
combined with the rest system, it drains player resources and forces them to really think critically 


Gameplay strategies
throught both playtests and minor submissions we learned about alot of different strategies poeople had for the game.
for example, early playtesters found a interesting stratergy where if they let everyone but one person die, it resulted in a garenteed win because they could constantly heal that person to full, and if they were a food and water producer they would never starve, this of course goes against the intended gameplay loop so we included a bandit raid mechanic. 
this mechanic originally was gonna be a random event mechanic but seeing this playstyle, and after recieveing feedback that players don't have much choice, we decided to make it happen duriung set time frames with set skill checks.
this ensures players have to think about their military stat, making this playstyle impossible while also forcing the player to make more chocies.

overall the intended strategy is for players to consider each and every settler based on their current needs.
are they at risk of running out of food and water, that farmer is probably more important.
big raid coming in soon, get the soldier ready


TLDR of game balance, Settlers are super important and the key to the game, Players must carefully manage them to ensure survival.
resources are balanced so that Settlers all together produce an abundence and everything else supplements it
sicknesses and bandit raids kill settlers and the are main adversarial force



	



Art and design: 
- We discussed and used 2D art from design on Canva and Drawing by Ibis for GODOT game (export to use): character, character list, the TV (Main screen).
- Finish updating the main screen TV (background, light, black room, pick to heal char...)
- Artstyle anime, sync all about artstyle (tank, character, character book, shop...)
- The event will have 2 versions, 1 is black-white for printing to use on paper- prototype and 1 more color than. Both style can realise the positive, negative, trade (and anything else in future development) through color and same art (for prototype).
-> update: event card updating of image and icon on godot (we choose option 1 art 1 type (negative, positive, trade...))
- The idea of the event is to make it have an icon and to be a card for play.
- Still in discussion: On Godot event not be in card anymore
- We get the ideas of character list from the books after research, analyzing their advantage/ (-) point and all team member decide option so all the ideas are now near the last version.
- Design characters' ideas: Based on the resources, story, and style of game, we decide to choose the style a bit survival, not too much technical and real but still keep their own personalities. Different job to different resources they will be receive (for example- Luffy, a farmer, so design based on some symbol that a farmer should have then his resources will focus on providing the food and water).
- Graphic (Main menu design): This is the total from experience playing games and favorite of each team member such as from game (Wuthering Waves, Arknight, That's Not My Neighbor (Nightmare), Vocaloid fanmade, ...)
- Animation notes: 
1. Still deciding on exact details, but we know some animations like cards flipping to reveal event, will be animations that we want to see
2. Some flickering/turning off the camera screens once a character dies
3. Maybe some kind of vignette for when a character is sick (depending on level of sickness, the TV screen portrait has a stronger vignette)
4. Hopefully be able to translate some of the animations from Canva to the game 
5. Currently, there is an animation completed for the event card "flipping" in the play scene (make sure to select "cardflip ani test1" in the timeline next to the animation text)
- Story design:
1. Game's story: Based on the first main -goal is specific: floatation, ''survival'' and cure diseases by putting them in a floatation tank 
2. Char's story: Based on the favorite, multiple style-job and the char's status such as: Not sick, sickness level: , dead...
3. Event's story: based on the status of story game could be (for example: sickness, hunt...) and based on character (ex: the witch- Caitlyn)...


Overall update of art after test play 1: 
+Adding other types of character and their backgrounds: healing, sickness, tank.
+Discuss and add art of trade shop
+Finish updating the icon and image of events.
+Finish and improve the UI main screen (TV)
+Provide the screen after lose and win



### Prototypeing process video ###
here is a link to the our prototyping video, its in our shared drive which tutors should already have access to
https://drive.google.com/file/d/1KxR5wbjOspz64W0Q7_Nrcp44xnIBme1g/view



