@tool
extends EditorPlugin

# Replace "PluginToggle" with all plugin folders you want to be controlled:
var plugins :PackedStringArray = ["PluginToggle"]

var toggle_button :Button

func _enter_tree():
	toggle_button = CheckButton.new()
	toggle_button.toggle_mode = true
	toggle_button.tooltip_text = "Enables plugins:\n" + "\n".join(plugins)
	toggle_button.toggled.connect(_on_toggle_toggled)
	add_control_to_container(CONTAINER_TOOLBAR, toggle_button)


func _exit_tree():
	if toggle_button:
		remove_control_from_container(CONTAINER_TOOLBAR, toggle_button)
		toggle_button.queue_free()


func _on_toggle_toggled(button_pressed: bool) -> void:
	for p in plugins:
		EditorInterface.set_plugin_enabled(p, button_pressed)
