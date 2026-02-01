@tool
extends EditorPlugin

# Replace "PluginToggle" with all plugin folders you want to control:
const PLUGINS :Array = ["PluginToggle"]



var toggle_button :Button
var plugin_names :Array

func _enter_tree():
	var all = get_all_plugins()
	if all.is_empty():
		printerr("No Plugins found!")
		return
	elif PLUGINS.is_empty():
		printerr("No Plugins specified!")
		return
	elif PLUGINS.size() == 1:
		if PLUGINS[0] == "PluginToggle":
			printerr("Please specify plugins to control within the " +
					 "plugintoggle.gd and re-enable the plugin.")
			return
	for p in PLUGINS:
		for a in all:
			if a["folder"] == p:
				plugin_names.append(a["name"])
	toggle_button = CheckButton.new()
	toggle_button.toggle_mode = true
	toggle_button.text = "Plugins"
	toggle_button.tooltip_text = "Controls Plugins:\n" + "\n".join(plugin_names)
	toggle_button.toggled.connect(_on_toggle_toggled)
	add_control_to_container(CONTAINER_TOOLBAR, toggle_button)


func _exit_tree():
	if toggle_button:
		remove_control_from_container(CONTAINER_TOOLBAR, toggle_button)
		toggle_button.queue_free()


func _on_toggle_toggled(button_pressed: bool) -> void:
	for p in PLUGINS:
		EditorInterface.set_plugin_enabled(p, button_pressed)
	if button_pressed:
		prints("Plugin Enabled:", plugin_names)
	else:
		prints("Plugin Disabled:", plugin_names)

func get_all_plugins() -> Array:
	var result := []
	var d := DirAccess.open("res://addons")
	if d == null:
		return result
	d.list_dir_begin()
	var name := d.get_next()
	while name != "":
		if d.current_is_dir() and not name.begins_with("."):
			var cfg_path := "res://addons/"+name+"/plugin.cfg"
			if FileAccess.file_exists(cfg_path):
				var cfg := ConfigFile.new()
				if cfg.load(cfg_path) == OK:
					result.append({
						"folder": name,
						"name": cfg.get_value("plugin", "name", name),
					})
		name = d.get_next()
	d.list_dir_end()
	return result
