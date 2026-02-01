@tool
extends EditorPlugin

var reg_button :Button
var all_button :Button


func _enter_tree():
	var script_editor = EditorInterface.get_script_editor()
	var toolbar := script_editor.get_child(0).get_child(0)
	if toolbar == null:
		push_error("ScriptEditor toolbar not found")
		return
	
	reg_button = Button.new()
	reg_button.text = "#reg"
	reg_button.tooltip_text = "Toggle Code Regions"
	reg_button.pressed.connect(_on_reg_button_pressed)
	toolbar.add_child(reg_button)
	
	all_button = Button.new()
	all_button.text = "all()"
	all_button.tooltip_text = "Collapse all"
	all_button.pressed.connect(_on_all_button_pressed)
	toolbar.add_child(all_button)


func _exit_tree():
	if reg_button:
		reg_button.queue_free()
	if all_button:
		all_button.queue_free()


func _on_reg_button_pressed() -> void:
	var editor = EditorInterface.get_script_editor().get_current_editor().get_base_editor()
	if editor is CodeEdit:
		for i in editor.get_line_count()-1:
			if editor.is_line_code_region_start(i):
				if editor.is_line_folded(i):
					editor.unfold_line(i)
				else:
					editor.fold_line(i)


func _on_all_button_pressed() -> void:
	var editor = EditorInterface.get_script_editor().get_current_editor().get_base_editor()
	if editor is CodeEdit:
		editor.fold_all_lines()


#region
var foo

func bar():
	var foobar
	pass

#endregion
