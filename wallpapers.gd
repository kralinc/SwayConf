extends Control

var WallpaperContainer = preload("res://wallpapercontainer.tscn")

func _ready():
	pass # Replace with function body.

func _on_main_loading_finished():
	var regex = RegEx.new()
	#Find file paths
	regex.compile("(\\/.*?\\.[\\w:]+)")
	for wallpaper in D.configData["wallpapers"]:
		var path = regex.search(wallpaper.text).get_string()
		var wc = WallpaperContainer.instance()
		wc.loadWallpaperData(path)
		wc.setCurrentDisplay(wallpaper.text.rsplit(" ")[1])
		get_parent().get_child(0).get_child(0).add_child(wc)
