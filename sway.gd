extends Control

signal loading_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	var settingsFile = loadSettingsFile()
	if settingsFile:
		$noSettings.visible = false
		D.configFilePath = settingsFile["path"]
		loadRoutine()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func loadRoutine():
	loadConfFile()
	loadConfData()
	loadDisplays()
	$menu.visible = true
	emit_signal("loading_finished")
	

func loadConfFile():
	var cf = File.new()
	if not cf.file_exists(D.configFilePath):
		#TODO this should show an error message
		return
	cf.open(D.configFilePath, File.READ)
	var lineNumber = 0
	while not cf.eof_reached():
		var line = cf.get_line().strip_edges()
		if not line.begins_with("#") and line != "":
			D.configFile.append({"line": lineNumber, "text": line})
		lineNumber += 1
		
	cf.close()
	
func loadConfData():
	for line in D.configFile:
		if " bg " in line.text and "output " in line.text:
			if not D.configData.has("wallpapers"):
				D.configData["wallpapers"] = []
			D.configData["wallpapers"].append(line)
	
func loadDisplays():
	var output = []
	var status = OS.execute("swaymsg", ["-t", "get_outputs"], true, output)
	if status == 0:
		var ds = parse_json(output[0])
		D.displays = ds
	else:
		D.displays = []
		#TODO show error message
		print("swaymsg -t get_outputs returned status code " + String(status)
		+ ", dropdowns will not be available. Are you currently using sway?")

func loadSettingsFile():
	var file = File.new()
	if not file.file_exists("user://swayconf.json"):
		return false
	file.open("user://swayconf.json", File.READ)
	var data = parse_json(file.get_line())
	file.close()
	return data


func _on_noSettings_accepted(path):
	var file = File.new()
	file.open("user://swayconf.json", File.WRITE)
	file.store_line(to_json({"path": path}))
	file.close()
	var settingsFile = loadSettingsFile()
	D.configFilePath = settingsFile["path"]
	loadRoutine()
