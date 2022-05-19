extends MarginContainer

class_name Box

signal selected

export (Color) var predefined_color:Color = Color.darkgray
export (Color) var filled_color:Color = Color.royalblue
export (Color) var invalid_color:Color = Color.sienna
export (DynamicFont) var font:DynamicFont

var value_label:Label
var note_label:Label
var status_indicator:ColorRect
var button:Button

enum STATUS {PREDEFINED, FILLED, NOTED, EMPTY}
var status:int setget set_status
enum MODE {VALUE, NOTE}
var mode:int setget , get_mode

enum {NEG=-1, ZERO, POS}
var initial:int = 0 setget set_initial
var value:int = 0 setget set_value
var note:int = 0 setget set_note
var content = 0 setget , get_content
var notes:Array = [] setget set_notes

func get_mode():
	match status:
		STATUS.NOTED: return MODE.NOTE
		_: return MODE.VALUE

func get_content():
	match status:
		STATUS.NOTED: return notes.duplicate()
		_: return value

func set_size_flags(node:Control, horizontal:int, vertical:int):
	node.size_flags_horizontal = horizontal
	node.size_flags_vertical = vertical

func make_component(prop:String, type:GDScriptNativeClass):
	self[prop] = type.new()
	if (type == Label):
		self[prop].align = HALIGN_CENTER
		self[prop].valign = VALIGN_CENTER
		if (font != null):
			self[prop].add_constant_override("font", font)
	if (type != Button):
		self[prop].mouse_filter = MOUSE_FILTER_IGNORE
	else:
		self[prop].connect("pressed", self, "_on_Button_pressed")
	add_child(self[prop])
	set_size_flags(self[prop], SIZE_EXPAND_FILL, SIZE_EXPAND_FILL)

func _init(nfont:DynamicFont=font):
	font = nfont
	make_component("button", Button)
	make_component("status_indicator", ColorRect)
	make_component("note_label", Label)
	make_component("value_label", Label)

func set_visuals(vl_visible:bool, nl_visible:bool, si_visible:bool, si_color:Color):
	value_label.visible = vl_visible
	note_label.visible = nl_visible
	status_indicator.visible = si_visible
	status_indicator.color = si_color
	status_indicator.color.a = 0.1

func set_note_label(vals:Array):
	var text:String = ""
	for val in vals:
		text += " %d " % val
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

func set_status(val:int):
	status = val
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
		set_visuals(true, false, true, invalid_color)

func _on_Button_pressed():
	emit_signal("selected")
