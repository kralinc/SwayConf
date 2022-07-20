extends Control

signal accepted(path)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_button_pressed():
	$fileSelect.popup_centered_ratio(0.75)


func _on_fileSelect_file_selected(path):
	$input.text = path
	$acceptButton.visible = true


func _on_input_text_changed(new_text):
	if $input.text.strip_edges() == "":
		$acceptButton.visible = false
	else:
		$acceptButton.visible = true


func _on_acceptButton_pressed():
	visible = false
	emit_signal("accepted", $input.text)
