extends AspectRatioContainer

onready var board:Board = $MarginContainer/MainColumn/MarginContainer/PlaySpace/ARContainer2/Board
onready var bank:LetterBank = $MarginContainer/MainColumn/MarginContainer/PlaySpace/ARContainer/LetterBank

onready var connect_sources:Array = [
	$MarginContainer/MainColumn/TopBar/Back,
	$MarginContainer/MainColumn/TopBar/Customize,
	$MarginContainer/MainColumn/BottomBar/Restart,
	$MarginContainer/MainColumn/BottomBar/Validate,
	$MarginContainer/MainColumn/BottomBar/Notetaking,
	$MarginContainer/MainColumn/BottomBar/Undo,
	bank, bank,
	board, board,
]
var connect_signals:Array = [
	"pressed", "pressed", "pressed", "pressed", "pressed", "pressed",
	"selected", "unselected", "box_selected", "box_unselected",
]
onready var connect_targets:Array = [
	self, self, self, self, self, self,
	self, self, self, self,
]
var connect_methods:Array = [
	"Back", "Customize", "Restart", "Validate", "Notetaking", "Undo",
	"Select_Number", "UnSelect_Number", "Select_Box", "UnSelect_Box",
]

var paint_mode = false
var tenkey_mode = false

func _ready():
	
	print("Ready")
	Matrixes.test()
	
	for i in range(min(connect_sources.size(), connect_targets.size())):
		var source:Object = connect_sources[i]
		var csignal:String = connect_signals[i]
		var target:Object = connect_targets[i]
		var method:String = connect_methods[i]
		source.connect(csignal, target, method)

func Back():
	get_tree().change_scene("res://MainMenu.tscn")
#	get_tree().quit()

func Customize():
	pass

func Restart():
	board.reset()

func Validate():
	board.validate()

var is_notetaking = false
func Notetaking():
	is_notetaking = not is_notetaking
	bank.mode = bank.MODE.NOTE if is_notetaking else bank.MODE.VALUE
	board.mode = board.MODE.NOTE if is_notetaking else board.MODE.VALUE

func Undo():
	board.undo()

func UnSelect_Box():
	if tenkey_mode:
		tenkey_mode = false
		board.set_box_toggle_modes(false)
		board.clear_highlight()

func Select_Box(empty:bool):
	if paint_mode:
		board.set_box()
		board.match_to()
	else:
		tenkey_mode = true
		if not empty:
			board.match_to()

func UnSelect_Number():
	print("Unselected")
	if paint_mode:
		paint_mode = false
		board.set_box_toggle_modes(true)
		board.clear_highlight()

func Select_Number(num:int):
	board.set_number(num)
	if tenkey_mode:
		board.set_box()
		bank.deselect()
	else:
		if not paint_mode:
			paint_mode = true
			board.set_box_toggle_modes(false)
		board.match_to()
