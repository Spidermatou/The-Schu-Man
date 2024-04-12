extends Node2D

signal ruinedBuilding(building: buildings)

signal RenovatedBuilding

enum buildings {IT, SSU, CENTRAL, CHEMISTRY, CIVILENGINEERING, LEO}

var buildingsHealth: Dictionary = {
	buildings.IT: 0,
	buildings.SSU: 0,
	buildings.CENTRAL: 0,
	buildings.CHEMISTRY: 0,
	buildings.CIVILENGINEERING: 0,
	buildings.LEO: 0,
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

func addToHealth(building: buildings, value: int):
	buildingsHealth[building] += value
	
	if buildingsHealth[building] > 100:
		buildingsHealth[building] = 100
	
	checkBuildingsHealth()
	checkBuildingsHealthForWin()


func addToAllHealth(value: int):
	for building in buildings.values():
		addToHealth(building, value)

#-------------------------------------------------------------------------------

func setHealth(building: buildings ,value: int):
		buildingsHealth[building] = value
		checkBuildingsHealth()
		checkBuildingsHealthForWin()

func setAllHealth(value: int):
	for building in buildings.values():
		buildingsHealth[building] = value
	checkBuildingsHealth()
	checkBuildingsHealthForWin()

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
			
func checkBuildingsHealthForWin():
	var count = 0
	for building in buildings.values():
		var health: int = buildingsHealth[building]
		
		if health >= 71:
			count += 1
		
	if count >= 6:
			RenovatedBuilding.emit()


func updateBuildingColor(building: buildings, color: colors):
	match building:
		buildings.IT:
			$Polygons/IT.color = Color(colorsHex[color])
		buildings.SSU:
			$Polygons/SSU.color = Color(colorsHex[color])
		buildings.CENTRAL:
			$Polygons/Central.color = Color(colorsHex[color])
		buildings.CHEMISTRY:
			$Polygons/Chemistry.color = Color(colorsHex[color])
		buildings.CIVILENGINEERING:
			$Polygons/CivilEngineering.color = Color(colorsHex[color])
		buildings.LEO:
			$Polygons/Leo.color = Color(colorsHex[color])	
