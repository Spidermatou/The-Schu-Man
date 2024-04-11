extends Node2D

func _ready():
	checkBuildingsHealth()

signal ruinedBuilding(building: buildings)

enum buildings {IT, SSU, CENTRAL, CHEMISTRY, CIVILENGINEERING, LEO}

var buildingsHealth: Dictionary = {
	buildings.IT: 0,
	buildings.SSU: 10,
	buildings.CENTRAL: 30,
	buildings.CHEMISTRY: 50,
	buildings.CIVILENGINEERING: 80,
	buildings.LEO: 80,
}

#-------------------------------------------------------------------------------

enum colors {BLACK, RED, ORANGE, YELLOW, GREEN}

var colorsHex: Dictionary = {
	colors.BLACK: "0b0100",
	colors.RED: "e81c1c",
	colors.ORANGE: "ff9117",
	colors.YELLOW: "fffb09",
	colors.GREEN: "06ff15",
}

#-------------------------------------------------------------------------------

func increaseHealth(building: buildings, value: int):
	buildingsHealth[building] += value
	
	if buildingsHealth[building] > 100:
		buildingsHealth[building] = 100

	checkBuildingsHealth()
	
func decreaseHealth(building: buildings, value: int):
	buildingsHealth[building] -= value
	checkBuildingsHealth()
	
func increaseAllHealth(value: int):
	for building in buildings.values():
		increaseHealth(building, value)
	
func decreaseAllHealth(value: int):
	for building in buildings.values():
		decreaseHealth(building, value)

#-------------------------------------------------------------------------------

func checkBuildingsHealth():
	for building in buildings.values():
		var health: int = buildingsHealth[building]
		
		if health <= 0:
			updateBuildingColor(building, colors.BLACK)
			ruinedBuilding.emit(building)

		elif health > 0 && health <= 20:
			updateBuildingColor(building, colors.RED)
			
		elif health > 20 && health <= 40:
			updateBuildingColor(building, colors.ORANGE)
			
		elif health > 40 && health <= 70:
			updateBuildingColor(building, colors.YELLOW)
		
		else:
			updateBuildingColor(building, colors.GREEN)


func updateBuildingColor(building: buildings, color: colors):
	match building:
		buildings.IT:
			$IT.color = Color(colorsHex[color])
		buildings.SSU:
			$SSU.color = Color(colorsHex[color])
		buildings.CENTRAL:
			$Central.color = Color(colorsHex[color])
		buildings.CHEMISTRY:
			$Chemistry.color = Color(colorsHex[color])
		buildings.CIVILENGINEERING:
			$CivilEngineering.color = Color(colorsHex[color])
		buildings.LEO:
			$Leo.color = Color(colorsHex[color])
