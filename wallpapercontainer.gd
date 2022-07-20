extends HBoxContainer

func loadWallpaperData(path):
	$input.text = path
	setImage(path)
	setDisplayOptions()

func setImage(path):
	$image.texture = get_external_texture(path)
	
func setDisplayOptions():
	$displaymenu.add_item("*")
	for display in D.displays:
		$displaymenu.add_item(display.name)
		
func setCurrentDisplay(displayName):
	var id
	for itemId in range($displaymenu.get_item_count()):
		if $displaymenu.get_item_text(itemId) == displayName:
			$displaymenu.selected = itemId
			return

func _on_button_pressed():
	$fileselect.popup_centered_ratio(0.75)


func _on_fileselect_file_selected(path):
	loadWallpaperData(path)

func get_external_texture(path):
	var img = Image.new()
	img.load(path)
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	return texture
