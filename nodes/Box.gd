extends MarginContainer

class_name Box

signal selected

export (Color) var predefined_color:Color = Color.darkgray
export (Color) var filled_color:Color = Color.royalblue
export (Color) var invalid_color:Color = Color.crimson
export (Color) var hl_match_color:Color = Color.deepskyblue
export (Color) var hl_valid_color:Color = Color.aquamarine
export (Color) var hl_invalid_color:Color = Color.crimson
export (Font) var filled_font:Font
export (Font) var noted_font:Font

var value_label:Label
var note_label:Label
var status_indicator:ColorRect
var highlighter:ColorRect
var button:Button

enum STATUS {PREDEFINED, FILLED, NOTED, EMPTY}
var status:int setget set_status
enum MODE {VALUE, NOTE}
var mode:int setget , get_mode
enum HIGHLIGHT {MATCH, VALID, INVALID, NONE}
var highlight:int setget set_highlight

enum {NEG=-1, ZERO, POS}
var initial:int = 0 setget set_initial
var value:int = 0 setget set_value
var note:int = 0 setget set_note
var content = 0 setget , get_content
var notes:Array = [] setget set_notes
var toggle_mode:bool = false setget set_toggle_mode
var pressed:bool = false setget set_pressed
var invalid:bool = false

func get_mode():
	match status:
		STATUS.NOTED: return MODE.NOTE
		_: return MODE.VALUE

func get_content():
	match status:
		STATUS.NOTED: return notes.duplicate()
		_: return value

func set_toggle_mode(val):
	toggle_mode = val
	button.toggle_mode = val

func set_pressed(val):
	pressed = val
	button.pressed = val

func set_size_flags(node:Control, horizontal:int, vertical:int):
	node.size_flags_horizontal = horizontal
	node.size_flags_vertical = vertical

func make_component(prop:String, type:GDScriptNativeClass, extraInfo=null):
	self[prop] = type.new()
	if (type == Label):
		self[prop].align = HALIGN_CENTER
		self[prop].valign = VALIGN_CENTER
		if (extraInfo != null and extraInfo is Font):
			self[prop].add_font_override("font", extraInfo)
	if (type != Button):
		self[prop].mouse_filter = MOUSE_FILTER_IGNORE
	else:
		self[prop].connect("pressed", self, "_on_Button_pressed")
	add_child(self[prop])
	set_size_flags(self[prop], SIZE_EXPAND_FILL, SIZE_EXPAND_FILL)

func _init(nf_font:Font=filled_font, nn_font:Font=noted_font):
	filled_font = nf_font
	noted_font = nn_font
	make_component("button", Button)
	make_component("status_indicator", ColorRect)
	make_component("highlighter", ColorRect)
	make_component("note_label", Label, nn_font)
	make_component("value_label", Label, nf_font)

func set_highlighter(hl_visible:bool, hl_color:Color):
	highlighter.visible = hl_visible
	highlighter.color = hl_color
	highlighter.color.a = .25

func set_visuals(vl_visible:bool, nl_visible:bool, si_visible:bool, si_color:Color, si_opacity:float=0.1):
	value_label.visible = vl_visible
	note_label.visible = nl_visible
	status_indicator.visible = si_visible
	status_indicator.color = si_color
	status_indicator.color.a = 0.1

func set_note_label(vals:Array):
	var text:String = ""
	var i:int = 0
	for val in vals:
		if i != 0:
			text += "\n" if not (i % 3) else ""
		text += " %d " % val
		i += 1
	note_label.text = text

func set_value_label(val:int):
	var text:String
	match int(sign(val)):
		NEG: text = String(abs(val))
		POS: text = String(abs(val))
		ZERO: text = ""
	value_label.text = text

func notes_updated():
	notes.sort()
	set_note_label(notes)
	match notes.size():
		ZERO: set_status(STATUS.EMPTY)
		_: set_status(STATUS.NOTED)

func set_notes(val:Array):
	notes = val
	notes_updated()

func set_note(val:int):
	if notes.has(val): notes.erase(val)
	else: notes.append(val)
	notes_updated()

func value_updated():
	set_value_label(value)
	match int(sign(value)):
		NEG: set_status(STATUS.PREDEFINED)
		POS: set_status(STATUS.FILLED)
		ZERO: set_status(STATUS.EMPTY)

func set_initial(val:int):
	value = val
	value_updated()

func set_value(val:int):
	value = 0 if (value == val) else val
	value_updated()

func set_highlight(val:int):
	highlight = val
	match highlight:
		HIGHLIGHT.MATCH:
			set_highlighter(true, hl_match_color)
		HIGHLIGHT.VALID:
			set_highlighter(true, hl_valid_color)
		HIGHLIGHT.INVALID:
			set_highlighter(true, hl_invalid_color)
		HIGHLIGHT.NONE:
			set_highlighter(false, Color.black)

func set_status(val:int):
	status = val
	invalid = false
	match status:
		STATUS.PREDEFINED:
			set_visuals(true, false, true, predefined_color)
		STATUS.FILLED:
			set_visuals(true, false, true, filled_color)
		STATUS.NOTED:
			set_visuals(false, true, false, Color.black)
		STATUS.EMPTY:
			set_visuals(false, false, false, Color.black)

func validate(val:int):
	if status == STATUS.FILLED and val != value:
		invalid = true
		set_visuals(true, false, true, invalid_color, 0.25)
		if highlight != HIGHLIGHT.NONE:
			set_highlight(HIGHLIGHT.INVALID)

func match_to(val:int):
	if status == STATUS.FILLED and val == value:
		if invalid: set_highlight(HIGHLIGHT.INVALID)
		else: set_highlight(HIGHLIGHT.MATCH)
	elif status == STATUS.NOTED and notes.has(val):
		set_highlight(HIGHLIGHT.MATCH)
	else: set_highlight(HIGHLIGHT.NONE)

func clear_highlight():
	set_highlight(HIGHLIGHT.NONE)

func empty():
	return status == STATUS.EMPTY

func _on_Button_pressed():
	emit_signal("selected")
