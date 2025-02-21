#option_explicit

//
// Common code.
//

//-----------------------------------------------------
// Booleans.
//
#constant FALSE = 0
#constant TRUE = 1

#constant WIN_MODE = 0

//-----------------------------------------------------
// General purpose directions.

#constant DIR_C 0
#constant DIR_N 1
#constant DIR_S 2
#constant DIR_E 4
#constant DIR_R 4
#constant DIR_W 8
#constant DIR_L 8
#constant DIR_U 16
#constant DIR_D 32
#constant DIR_H 64
#constant DIR_V 128

#constant DIR_NE 5
#constant DIR_NW 9
#constant DIR_SE 6
#constant DIR_SW 10

#constant DIR_TR 5
#constant DIR_TL 9
#constant DIR_BL 6
#constant DIR_BR 10

#constant ROT_CW 1
#constant ROT_ACW 2

#constant CO_CS 16
#constant CO_CS2 8
#constant CO_BS 128
#constant CO_BS2 64

#constant CO_LINE_MID_CIRC 1
#constant CO_LINE_MID_SQR 2
#constant CO_LINE_END_CIRC 3
#constant CO_LINE_END_SQR 4

#constant CO_FONT_REGULAR 0
#constant CO_FONT_EXTRA_LIGHT 1
#constant CO_FONT_LIGHT 2
#constant CO_FONT_MEDIUM 3
#constant CO_FONT_SEMI_BOLD 4
#constant CO_FONT_BOLD 5
#constant CO_FONT_BLACK 6

#constant DATE_SCALE_NONE = 0
#constant DATE_SCALE_WEEK5 = 1
#constant DATE_SCALE_WEEK7 = 2
#constant DATE_SCALE_1MONTH = 3
#constant DATE_SCALE_3MONTHS = 4
#constant DATE_SCALE_6MONTHS = 5
#constant DATE_SCALE_12MONTHS = 6
#constant DATE_SCALE_MIN = 1
#constant DATE_SCALE_MAX = 6

#constant TIME_SCALE_NONE = 0
#constant TIME_SCALE_QTRHOUR = 1
#constant TIME_SCALE_HALFHOUR = 2
#constant TIME_SCALE_1HOUR = 3
#constant TIME_SCALE_6MONTHS = 4
#constant TIME_SCALE_12MONTHS = 5
#constant TIME_SCALE_MIN = 1
#constant TIME_SCALE_MAX = 5

#constant DAY_SECS = 86400
#constant HOUR_SECS = 3600
#constant YEAR_SECS = 31536000
#constant WRAP_SECS = 3133696 // The number of seconds to skip forward from INT_MIN to arrive at the next day after INT_MAX.
#constant WRAP_YEARS = 136

#constant INT_MIN = -2147483648
#constant INT_MAX = 2147483647

#constant YEAR_MIN = 2000
#constant YEAR_MAX = 2100

global CO_PI as float
global CO_PI_2 as float
global _Q as string

_Q = chr(34)

//-----------------------------------------------------
// Drag distance before a touch becomes a drag.
//
#constant DRAG_SIZE_MIN = 20 // The minimum distance a drag needs to be to not just be a touch.

//-----------------------------------------------------
// Strip chars for a file name.
//
#constant L_ALPHA$ = "abcdefghijklmnopqrstuvwxyz"
#constant U_ALPHA$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#constant DELIMS$ = " ~!@#$%^&*()_+`-=[]\[]\;':,./<>?" + chr(34)
#constant HEX_CHARS$ = "0123456789abcdef"

//-----------------------------------------------------
global co as Common

//-----------------------------------------------------
type Common

	perfs as Perf[]
	perfTime as integer

	log as string[]
	logTop as integer
	logNbr as integer
	logMsg as string 
	printSize as integer
	logLineMax as integer
	
	pixImg as integer
	circleImg as integer[]
	circleSize as integer[]
	
	cs as float // Width of one block, e.g. 8
	bs as float // Width of a square button.
	w as float
	h as float
	dw as float
	dh as float
	w1 as float
	w2 as float
	w3 as float
	iw as float
	iw0 as float
	iw1 as float
	iw2 as float
	iw3 as float
	iw4 as float
	h1 as float
	h2 as float
	h3 as float
	ih as float
	ih0 as float
	ih1 as float
	ih2 as float
	ih3 as float
	ih4 as float
	tabW as float
	
	red as integer[9]
	blue as integer[9]
	green as integer[9]
	deeppurple as integer[9]
	yellow as integer[9]
	pink as integer[9]
	orange as integer[9]
	indigo as integer[9]
	amber as integer[9]
	deeporange as integer[9]
	grey as integer[9]
	brown as integer[9]
	lightgreen as integer[9]
	lime as integer[9]
	teal as integer[9]
	lightblue as integer[9]
	cyan as integer[9]
	purple as integer[9]
	bluegrey as integer[9]
	white as integer
	black as integer
	
	_colorName as string // Temp name for constructing the table.
	_colorNameIdx as integer

	openCol as integer
	renameCol as integer
	editCol as integer
	deleteCol as integer
	helpCol as integer
	detailsCol as integer
	cutCol as integer
	copyCol as integer
	undoCol as integer
	redoCol as integer
	runCol as integer
	moreCol as integer
	special1Col as integer
	special11Col as integer
	special12Col as integer
	special13Col as integer
	special2Col as integer
	special21Col as integer
	special22Col as integer
	special23Col as integer
	special3Col as integer
	special31Col as integer
	special32Col as integer
	special33Col as integer
	special4Col as integer
	special41Col as integer
	special42Col as integer
	special43Col as integer
	colors as integer[]
	colorNames as ColorName[]

	//fonts as integer[]
	fonts as Font[]
	editFontSizes as float[]

	sprs as integer[] // Debug holder.
	sprNames as string[]
	txts as integer[]
	imgs as integer[]
	sprDebug as integer
	baseName as string
	appName as string

	dateFmt as string[]
	dateFmtHelp as string[]
	timeFmt as string[]
	timeFmtHelp as string[]
	days as string[]
	daysShort as string[]
	months as string[]
	monthsShort as string[]
	monthDays as integer[]
	monthOrdinals as string[]
	ordinals as string[]
	dateScaleW as integer[]
	dateScaleNames as string[]
	timeScaleH as integer[]
	timeScaleNames as string[]
	
endtype

type Perf
	
	name as string
	idx as integer
	time as integer
	
endtype

type KVPair

	k as string
	v as string
	
endtype

type Line

	x0 as float
	y0 as float // y first, because we want to sort by y.
	x1 as float
	y1 as float
	
endtype

// The edges of a box.
type Bounds
	
	l as float
	r as float
	t as float
	b as float
	
endtype

type Rect

	x as float
	y as float // y first, because we want to sort by y.
	w as float
	h as float
	
endtype

type Point

	x as float
	y as float
	
endtype

type Location

	x as integer
	y as integer
	
endtype

type NameUnique

	name as string
	unique as integer
	suffix as integer
	
endtype

type LoadedImage

	file as string
	img as integer
	
endtype

type RGB
	
	r as integer
	g as integer
	b as integer
	
endtype

type HSV
	
	h as float
	s as float
	v as float
	
endtype

type HSL
	
	h as float
	s as float
	l as float
	
endtype

type ColorName
	
	name as string
	col as integer
	
endtype

//-----------------------------------------------------
// Mem block / image pixel handling.
//
type MemBlock

	id as integer
	w as integer
	h as integer

endtype

type Segment

	y as integer
	xl as integer
	xr as integer
	dy as integer

Endtype

type FloodFill

	pixCount as integer
	stack as Segment[]
	x0 as integer
	y0 as integer
	x1 as integer
	y1 as integer
	col as integer

EndType

type Font 
	
	name as string
	id as integer
	weight as integer
	italic as integer
	
endtype

type Duration
	
	d as integer
	h as integer
	m as integer
	s as integer
	
endtype

type Time
	
	h as integer
	m as integer
	s as integer
	
endtype

type Date 
	
	y as integer
	m as integer
	d as integer
	
endtype

type SubImage
	
	img as integer // The master image.
	subImg as integer // The sub image.
	ext as string // The file ext.
	name as string // The subimage name in the .txt file.
	x as float
	y as float
	w as float
	h as float
	
endtype

//-----------------------------------------------------
// init common library.
//
function coInit()

	local i as integer
	local f as float
	local font as Font
	local cn as ColorName

	co.pixImg = LoadImage("gfx/pix.png")

	CO_PI = 3.14159265359
	CO_PI_2 = CO_PI / 2.0

	co.cs = CO_CS
	co.bs = CO_BS
	co.w = GetVirtualWidth()
	co.h = GetVirtualHeight()
	co.dw = GetMaxDeviceWidth()
	co.dh = GetMaxDeviceHeight()
	co.w1 = co.w / 4
	co.w2 = co.w / 2
	co.w3 = co.w2 + co.w1
	co.iw = co.w / 6 * 5	
	co.iw0 = (co.w - co.iw) / 2
	co.iw1 = co.w1 / 4
	co.iw2 = co.w / 2
	co.iw3 = co.iw2 + co.iw1
	co.iw4 = co.w - co.iw0
	co.h1 = co.h / 4
	co.h2 = co.h / 2
	co.h3 = co.h2 + co.h1
	co.ih = co.h / 71 * 60
	co.ih0 = (co.h - co.ih) / 2
	co.ih1 = co.ih / 4
	co.ih2 = co.h / 2
	co.ih3 = co.h2 + co.ih1
	co.ih4 = co.h - co.ih0
	co.tabW = co.h
	
	co._colorName = "red"
	co._colorNameIdx = 0
	
	co.colors.length = -1
	co.red[0] = coAddMasterColor("FFEBEE")
	co.red[1] = coAddMasterColor("FFCDD2")
	co.red[2] = coAddMasterColor("EF9A9A")
	co.red[3] = coAddMasterColor("E57373")
	co.red[4] = coAddMasterColor("EF5350")
	co.red[5] = coAddMasterColor("F44336")
	co.red[6] = coAddMasterColor("E53935")
	co.red[7] = coAddMasterColor("D32F2F")	
	co.red[8] = coAddMasterColor("C62828")	
	co.red[9] = coAddMasterColor("B71C1C")	

	co._colorName = "pink"
	co._colorNameIdx = 0

	co.pink[0] = coAddMasterColor("FCE4EC")
	co.pink[1] = coAddMasterColor("F8BBD0")
	co.pink[2] = coAddMasterColor("F48FB1")
	co.pink[3] = coAddMasterColor("F06292")
	co.pink[4] = coAddMasterColor("EC407A")
	co.pink[5] = coAddMasterColor("E91E63")
	co.pink[6] = coAddMasterColor("D81B60")
	co.pink[7] = coAddMasterColor("C2185B")
	co.pink[8] = coAddMasterColor("AD1457")
	co.pink[9] = coAddMasterColor("880E4F")

	co._colorName = "purple"
	co._colorNameIdx = 0

	co.purple[0] = coAddMasterColor("F3E5F5")
	co.purple[1] = coAddMasterColor("E1BEE7")
	co.purple[2] = coAddMasterColor("CE93D8")
	co.purple[3] = coAddMasterColor("BA68C8")
	co.purple[4] = coAddMasterColor("AB47BC")
	co.purple[5] = coAddMasterColor("9C27B0")
	co.purple[6] = coAddMasterColor("8E24AA")
	co.purple[7] = coAddMasterColor("7B1FA2")
	co.purple[8] = coAddMasterColor("6A1B9A")
	co.purple[9] = coAddMasterColor("4A148C")
	
	co._colorName = "deeppurple"
	co._colorNameIdx = 0

	co.deeppurple[0] = coAddMasterColor("EDE7F6")
	co.deeppurple[1] = coAddMasterColor("D1C4E9")
	co.deeppurple[2] = coAddMasterColor("B39DDB")
	co.deeppurple[3] = coAddMasterColor("9575CD")
	co.deeppurple[4] = coAddMasterColor("7E57C2")
	co.deeppurple[5] = coAddMasterColor("673AB7")
	co.deeppurple[6] = coAddMasterColor("5E35B1")
	co.deeppurple[7] = coAddMasterColor("512DA8")	
	co.deeppurple[8] = coAddMasterColor("4527A0")	
	co.deeppurple[9] = coAddMasterColor("311B92")	

	co._colorName = "indigo"
	co._colorNameIdx = 0

	co.indigo[0] = coAddMasterColor("E8EAF6")
	co.indigo[1] = coAddMasterColor("C5CAE9")
	co.indigo[2] = coAddMasterColor("9FA8DA")
	co.indigo[3] = coAddMasterColor("7986CB")
	co.indigo[4] = coAddMasterColor("5C6BC0")
	co.indigo[5] = coAddMasterColor("3F51B5")
	co.indigo[6] = coAddMasterColor("3949AB")
	co.indigo[7] = coAddMasterColor("303F9F")
	co.indigo[8] = coAddMasterColor("283593")
	co.indigo[9] = coAddMasterColor("1A237E")

	co._colorName = "blue"
	co._colorNameIdx = 0

	co.blue[0] = coAddMasterColor("E3F2FD")
	co.blue[1] = coAddMasterColor("BBDEFB")
	co.blue[2] = coAddMasterColor("90CAF9")
	co.blue[3] = coAddMasterColor("64B5F6")
	co.blue[4] = coAddMasterColor("42A5F5")
	co.blue[5] = coAddMasterColor("2196F3")
	co.blue[6] = coAddMasterColor("1E88E5")
	co.blue[7] = coAddMasterColor("1976D2")
	co.blue[8] = coAddMasterColor("1565C0")
	co.blue[9] = coAddMasterColor("0D47A1")

	co._colorName = "lightblue"
	co._colorNameIdx = 0

	co.lightblue[0] = coAddMasterColor("E1F5FE")
	co.lightblue[1] = coAddMasterColor("B3E5FC")
	co.lightblue[2] = coAddMasterColor("81D4FA")
	co.lightblue[3] = coAddMasterColor("4FC3F7")
	co.lightblue[4] = coAddMasterColor("29B6F6")
	co.lightblue[5] = coAddMasterColor("03A9F4")
	co.lightblue[6] = coAddMasterColor("039BE5")
	co.lightblue[7] = coAddMasterColor("0288D1")
	co.lightblue[8] = coAddMasterColor("0277BD")
	co.lightblue[9] = coAddMasterColor("01579B")

	co._colorName = "cyan"
	co._colorNameIdx = 0

	co.cyan[0] = coAddMasterColor("E0F7FA")
	co.cyan[1] = coAddMasterColor("B2EBF2")
	co.cyan[2] = coAddMasterColor("80DEEA")
	co.cyan[3] = coAddMasterColor("4DD0E1")
	co.cyan[4] = coAddMasterColor("26C6DA")
	co.cyan[5] = coAddMasterColor("00BCD4")
	co.cyan[6] = coAddMasterColor("00ACC1")
	co.cyan[7] = coAddMasterColor("0097A7")
	co.cyan[8] = coAddMasterColor("00838F")
	co.cyan[9] = coAddMasterColor("006064")

	co._colorName = "teal"
	co._colorNameIdx = 0

	co.teal[0] = coAddMasterColor("E0F2F1")
	co.teal[1] = coAddMasterColor("B2DFDB")
	co.teal[2] = coAddMasterColor("80CBC4")
	co.teal[3] = coAddMasterColor("4DB6AC")
	co.teal[4] = coAddMasterColor("26A69A")
	co.teal[5] = coAddMasterColor("009688")
	co.teal[6] = coAddMasterColor("00897B")
	co.teal[7] = coAddMasterColor("00796B")
	co.teal[8] = coAddMasterColor("00695C")
	co.teal[9] = coAddMasterColor("004D40")

	co._colorName = "green"
	co._colorNameIdx = 0

	co.green[0] = coAddMasterColor("E8F5E9")
	co.green[1] = coAddMasterColor("C8E6C9")
	co.green[2] = coAddMasterColor("A5D6A7")
	co.green[3] = coAddMasterColor("81C784")
	co.green[4] = coAddMasterColor("66BB6A")
	co.green[5] = coAddMasterColor("4CAF50")
	co.green[6] = coAddMasterColor("43A047")
	co.green[7] = coAddMasterColor("388E3C")
	co.green[8] = coAddMasterColor("2E7D32")
	co.green[9] = coAddMasterColor("1B5E20")

	co._colorName = "lightgreen"
	co._colorNameIdx = 0

	co.lightgreen[0] = coAddMasterColor("F1F8E9")
	co.lightgreen[1] = coAddMasterColor("DCEDC8")
	co.lightgreen[2] = coAddMasterColor("C5E1A5")
	co.lightgreen[3] = coAddMasterColor("AED581")
	co.lightgreen[4] = coAddMasterColor("9CCC65")
	co.lightgreen[5] = coAddMasterColor("8BC34A")
	co.lightgreen[6] = coAddMasterColor("7CB342")
	co.lightgreen[7] = coAddMasterColor("689F38")
	co.lightgreen[8] = coAddMasterColor("558B2F")
	co.lightgreen[9] = coAddMasterColor("33691E")

	co._colorName = "lime"
	co._colorNameIdx = 0

	co.lime[0] = coAddMasterColor("F9FBE7")
	co.lime[1] = coAddMasterColor("F0F4C3")
	co.lime[2] = coAddMasterColor("E6EE9C")
	co.lime[3] = coAddMasterColor("DCE775")
	co.lime[4] = coAddMasterColor("D4E157")
	co.lime[5] = coAddMasterColor("CDDC39")
	co.lime[6] = coAddMasterColor("C0CA33")
	co.lime[7] = coAddMasterColor("AFB42B")
	co.lime[8] = coAddMasterColor("9E9D24")
	co.lime[9] = coAddMasterColor("827717")

	co._colorName = "yellow"
	co._colorNameIdx = 0

	co.yellow[0] = coAddMasterColor("FFFDE7")
	co.yellow[1] = coAddMasterColor("FFF9C4")
	co.yellow[2] = coAddMasterColor("FFF59D")
	co.yellow[3] = coAddMasterColor("FFF176")
	co.yellow[4] = coAddMasterColor("FFEE58")
	co.yellow[5] = coAddMasterColor("FFEB3B")
	co.yellow[6] = coAddMasterColor("FDD835")
	co.yellow[7] = coAddMasterColor("FBC02D")
	co.yellow[8] = coAddMasterColor("F9A825")
	co.yellow[9] = coAddMasterColor("F57F17")

	co._colorName = "amber"
	co._colorNameIdx = 0

	co.amber[0] = coAddMasterColor("FFF8E1")
	co.amber[1] = coAddMasterColor("FFECB3")
	co.amber[2] = coAddMasterColor("FFE082")
	co.amber[3] = coAddMasterColor("FFD54F")
	co.amber[4] = coAddMasterColor("FFCA28")
	co.amber[5] = coAddMasterColor("FFC107")
	co.amber[6] = coAddMasterColor("FFB300")
	co.amber[7] = coAddMasterColor("FFA000")	
	co.amber[8] = coAddMasterColor("FF8F00")
	co.amber[9] = coAddMasterColor("FF6F00")

	co._colorName = "orange"
	co._colorNameIdx = 0

	co.orange[0] = coAddMasterColor("FFF3E0")
	co.orange[1] = coAddMasterColor("FFE0B2")
	co.orange[2] = coAddMasterColor("FFCC80")
	co.orange[3] = coAddMasterColor("FFB74D")
	co.orange[4] = coAddMasterColor("FFA726")
	co.orange[5] = coAddMasterColor("FF9800")
	co.orange[6] = coAddMasterColor("FB8C00")
	co.orange[7] = coAddMasterColor("F57C00")
	co.orange[8] = coAddMasterColor("EF6C00")
	co.orange[9] = coAddMasterColor("E65100")

	co._colorName = "deeporange"
	co._colorNameIdx = 0

	co.deeporange[0] = coAddMasterColor("FBE9E7")
	co.deeporange[1] = coAddMasterColor("FFCCBC")
	co.deeporange[2] = coAddMasterColor("FFAB91")
	co.deeporange[3] = coAddMasterColor("FF8A65")
	co.deeporange[4] = coAddMasterColor("FF7043")
	co.deeporange[5] = coAddMasterColor("FF5722")
	co.deeporange[6] = coAddMasterColor("F4511E")
	co.deeporange[7] = coAddMasterColor("E64A19")
	co.deeporange[8] = coAddMasterColor("D84315")
	co.deeporange[9] = coAddMasterColor("BF360C")

	co._colorName = "brown"
	co._colorNameIdx = 0

	co.brown[0] = coAddMasterColor("EFEBE9")
	co.brown[1] = coAddMasterColor("D7CCC8")
	co.brown[2] = coAddMasterColor("BCAAA4")
	co.brown[3] = coAddMasterColor("A1887F")
	co.brown[4] = coAddMasterColor("8D6E63")
	co.brown[5] = coAddMasterColor("795548")
	co.brown[6] = coAddMasterColor("6D4C41")
	co.brown[7] = coAddMasterColor("5D4037")	
	co.brown[8] = coAddMasterColor("4E342E")
	co.brown[9] = coAddMasterColor("3E2723")
	
	co._colorName = "grey"
	co._colorNameIdx = 0

	co.grey[0] = coAddMasterColor("FAFAFA")
	co.grey[1] = coAddMasterColor("F5F5F5")
	co.grey[2] = coAddMasterColor("EEEEEE")
	co.grey[3] = coAddMasterColor("E0E0E0")
	co.grey[4] = coAddMasterColor("BDBDBD")
	co.grey[5] = coAddMasterColor("9E9E9E")	
	co.grey[6] = coAddMasterColor("757575")
	co.grey[7] = coAddMasterColor("616161")
	co.grey[8] = coAddMasterColor("424242")
	co.grey[9] = coAddMasterColor("212121")
	
	co._colorName = "bluegrey"
	co._colorNameIdx = 0

	co.bluegrey[0] = coAddMasterColor("ECEFF1")
	co.bluegrey[1] = coAddMasterColor("CFD8DC")
	co.bluegrey[2] = coAddMasterColor("B0BEC5")
	co.bluegrey[3] = coAddMasterColor("90A4AE")
	co.bluegrey[4] = coAddMasterColor("78909C")
	co.bluegrey[5] = coAddMasterColor("607D8B")
	co.bluegrey[6] = coAddMasterColor("546E7A")
	co.bluegrey[7] = coAddMasterColor("455A64")
	co.bluegrey[8] = coAddMasterColor("37474F")
	co.bluegrey[9] = coAddMasterColor("263238")

	co.white = coMakeHexColor("FFFFFF")
	cn.name = "white"
	cn.col = co.white
	co.colorNames.insert(cn)

	co.black = coMakeHexColor("000000")
	cn.name = "black"
	cn.col = co.black
	co.colorNames.insert(cn)

	font.id = 0
	font.name = "Default"
	font.weight = CO_FONT_REGULAR
	font.italic = false
	co.fonts.insert(font)
		
	font.name = "Muli"
	font.weight = CO_FONT_REGULAR
	font.italic = false
	co.fonts.insert(font)
	font.weight = CO_FONT_BOLD
	font.italic = false
	co.fonts.insert(font)
	font.weight = CO_FONT_BLACK
	font.italic = false
	co.fonts.insert(font)

	font.name = "Oswald"
	font.weight = CO_FONT_REGULAR
	font.italic = false
	co.fonts.insert(font)
	font.weight = CO_FONT_BOLD
	font.italic = false
	co.fonts.insert(font)

	font.name = "Solway"
	font.weight = CO_FONT_REGULAR
	font.italic = false
	co.fonts.insert(font)
	font.weight = CO_FONT_BOLD
	font.italic = false
	co.fonts.insert(font)

	co.dateFmt = ["{D}", "{DD}", "{Ddd}", "{ddd}", "{DDD}", "{Dddd}", "{dddd}", "{DDDD}", "{M}", "{MM}", "{Mmm}", "{mmm}", "{MMM}", "{Mmmm}", "{mmmm}", "{MMMM}", "{YY}", "{YYYY}"]
	co.dateFmtHelp.insert("Date as 1 or 2 digits. If date < 10, then only shows 1 digit, e.g. 1, 15, 31.")
	co.dateFmtHelp.insert("Date as 2 digits. If date < 10, then shows a zero prefix, e.g. 01, 15, 31.")
	co.dateFmtHelp.insert("Day of the week in short format, e.g. Mon, Wed, Sat.")
	co.dateFmtHelp.insert("Day of the week in short format, all lowercase, e.g. mon, wed, sat.")
	co.dateFmtHelp.insert("Day of the week in short format, all uppercase, e.g. MON, WED, SAT.")
	co.dateFmtHelp.insert("Day of the week in full format, e.g. Monday, Wednesday, Saturday.")
	co.dateFmtHelp.insert("Day of the week in full format, all lowercase, e.g. monday, wednesday, saturday.")
	co.dateFmtHelp.insert("Day of the week in full format, all uppercase, e.g. MONDAY, WEDNESDAY, SATURDAY.")
	co.dateFmtHelp.insert("Month as 1 or digits. If the month < 10, then only shows 1 digit, e.g. 1, 7, 12")
	co.dateFmtHelp.insert("Month as 2 digits. If the month < 10, then shows zero prefix, e.g. 01, 07, 12")
	co.dateFmtHelp.insert("Month name in short format, e.g. Jan, May, Dec.")
	co.dateFmtHelp.insert("Month name in short format, all lowercase, e.g. jan, may, dec.")
	co.dateFmtHelp.insert("Month name in short format, all uppercase, e.g. JAN, MAY, DEC.")
	co.dateFmtHelp.insert("Month name in full format, e.g. January, May, December.")
	co.dateFmtHelp.insert("Month name in full format, all lowercase, e.g. january, may, december.")
	co.dateFmtHelp.insert("Month name in full format, all uppercase, e.g. JANUARY, MAY, DECEMBER.")
	co.dateFmtHelp.insert("Year as 2 digits, e.g. 66, 00, 18.")
	co.dateFmtHelp.insert("Year as 4 digits, e.g. 1966, 2000, 2018.")

	co.timeFmt = ["{h}", "{hh}", "{H}", "{HH}", "{m}", "{mm}", "{s}", "{ss}", "{t}", "{T}", "{tt}", "{Tt}", "{TT}"]
	co.timeFmtHelp.insert("Hour as 1 or 2 digits, in 12-hour clock. If hour < 10, then only shows 1 digit, e.g. 1, 5, 12.")
	co.timeFmtHelp.insert("Hour as 2 digits, in 12-hour clock. If hour < 10, then only shows 1 digit, e.g. 1, 5, 12.")
	co.timeFmtHelp.insert("Hour as 1 or 2 digits, in 24-hour clock. If hour < 10, then only shows 1 digit, e.g. 1, 13, 23.")
	co.timeFmtHelp.insert("Hour as 2 digits, in 24-hour clock. If hour < 10, then shows a zero prefix, e.g. 01, 13, 23.")
	co.timeFmtHelp.insert("Minute as 1 or 2 digits. If minute < 10, then only shows 1 digit, e.g. 1, 23, 59.")
	co.timeFmtHelp.insert("Minute as 2 digits. If minute < 10, then shows a zero prefix, e.g. 01, 23, 59.")
	co.timeFmtHelp.insert("Second as 1 or 2 digits. If second < 10, then only shows 1 digit, e.g. 1, 23, 59.")
	co.timeFmtHelp.insert("Second as 2 digits. If second < 10, then shows a zero prefix, e.g. 01, 23, 59.")
	co.timeFmtHelp.insert("a or p for am and pm.")
	co.timeFmtHelp.insert("A or P for AM and PM.")
	co.timeFmtHelp.insert("am or pm.")
	co.timeFmtHelp.insert("Am or Pm.")
	co.timeFmtHelp.insert("AM or PM.")

	co.days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	co.daysShort = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	co.monthOrdinals = ["Invalid", "First", "Second", "Third", "Fourth", "Fifth", "Last"]
	co.ordinals = ["Invalid", "First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth", "Eleventh", "Twelfth", "Thirteenth", "Fourteenth", "Fifteenth", "Sixteenth", "Seventeenth", "Eighteenth", "Nineteenth", "Twentieth"]
	co.months = ["Invalid", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	co.monthsShort = ["Inv", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	co.monthDays = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

	co.dateScaleW.length = DATE_SCALE_MAX
	co.dateScaleW[DATE_SCALE_WEEK5] = 5
	co.dateScaleW[DATE_SCALE_WEEK7] = 7
	co.dateScaleW[DATE_SCALE_1MONTH] = 31
	co.dateScaleW[DATE_SCALE_3MONTHS] = 92
	co.dateScaleW[DATE_SCALE_6MONTHS] = 47 // time scale is converted to 6 rows, for day list, weeks 1 - 5, for 6 months.
	co.dateScaleW[DATE_SCALE_12MONTHS] = 95 // time scale is converted to 13 rows, for day list, weeks 1 - 5, for 12 months.

	co.dateScaleNames.length = DATE_SCALE_MAX
	co.dateScaleNames[DATE_SCALE_WEEK5] = "weekdays"
	co.dateScaleNames[DATE_SCALE_WEEK7] = "7 days"
	co.dateScaleNames[DATE_SCALE_1MONTH] = "1 month"
	co.dateScaleNames[DATE_SCALE_3MONTHS] = "3 months"
	co.dateScaleNames[DATE_SCALE_6MONTHS] = "6 months"
	co.dateScaleNames[DATE_SCALE_12MONTHS] = "12 months"

	co.timeScaleH.length = TIME_SCALE_MAX
	co.timeScaleH[TIME_SCALE_QTRHOUR] = 96 // How many second segments in a day.
	co.timeScaleH[TIME_SCALE_HALFHOUR] = 48
	co.timeScaleH[TIME_SCALE_1HOUR] = 24
	co.timeScaleH[TIME_SCALE_6MONTHS] = 6
	co.timeScaleH[TIME_SCALE_12MONTHS] = 13

	co.timeScaleNames.length = TIME_SCALE_MAX
	co.timeScaleNames[TIME_SCALE_QTRHOUR] = "15 minutes"
	co.timeScaleNames[TIME_SCALE_HALFHOUR] = "30 minutes"
	co.timeScaleNames[TIME_SCALE_1HOUR] = "1 hour"
	co.timeScaleNames[TIME_SCALE_6MONTHS] = "6 months"
	co.timeScaleNames[TIME_SCALE_12MONTHS] = "12 months"

	co.sprs.length = -1
	co.sprNames.length = -1
	co.sprDebug = false

	co.baseName = GetDeviceBaseName()
	co.appName = "Planning Tool"

	co.printSize = 50
	co.log.length = -1
	co.logTop = false
	co.logNbr = 1
	co.logMsg = ""
	co.logLineMax = -1 // floor(co.h / co.printSize)
	
	setPrintColor(0, 0, 0)
	SetPrintSize(co.printSize)	

	//coInitCircles()
/*
	local x0 as float
	local y0 as float
	local x1 as float
	local y1 as float
	local sprs as integer[]
	f = 20
	x0 = 400
	y0 = 400
	x1 = x0 + 512
	y1 = y0 + 512

	coDrawSprLine(sprs, x0, y0 + (y1 - y0) / 2, x1, y0 + (y1 - y0) / 2, co.black, f)
	coDrawSprLine(sprs, x0 + (x1 - x0) / 2, y0, x0 + (x1 - x0) / 2, y1, co.black, f)
	coDrawSprLine(sprs, x0, y0, x1, y1, co.black, f)
	coDrawSprLine(sprs, x1, y0, x0, y1, co.black, f)

	x0 = 900
	y0 = 900
	x1 = x0 + 512
	y1 = y0 + 512

	coDrawDotLine(sprs, x0, y0 + (y1 - y0) / 2, x1, y0 + (y1 - y0) / 2, co.black, f)
	coDrawDotLine(sprs, x0 + (x1 - x0) / 2, y0, x0 + (x1 - x0) / 2, y1, co.black, f)
	coDrawDotLine(sprs, x0, y0, x1, y1, co.black, f)
	coDrawDotLine(sprs, x1, y0, x0, y1, co.black, f)

	for i = 0 to sprs.length
		SetSpriteDepth(sprs[i], 1)
	next
*/	

/*
	local col as integer
	local col2 as integer
	local rgb as RGB
	local rgb2 as RGB
	local hsv as HSV
	local hsl as HSL
	
	col = co.green[5]
	coColToRGB(col, rgb)
	//coRGBToHSV(rgb, hsv)
	coRGBToHSL(rgb, hsl)
	//coHSVToRGB(hsv, rgb2)
	coHSLToRGB(hsl, rgb2)
	col2 = coRGBToCol(rgb2)
	
	if col = col2
		col = col2
	endif
*/
	

	//local time as integer
	
	//time = INT_MAX
	//log("time=" + coFormatDateTime(time, "{YYYY}-{MM}-{DD} {hh}:{mm}:{ss}"))
	//time = time + (DAY_SECS * 365 * 68)
	//time = -1
	//log("time=" + coFormatDateTime(time, "{YYYY}-{MM}-{DD} {hh}:{mm}:{ss}"))

endfunction

//-----------------------------------------------------
// Capture a perf time.
//
function coPerf(name as string, idx as integer)
	
	local perf as Perf
	
	perf.name = name
	perf.idx = idx
	perf.time = GetMilliseconds()
	co.perfs.insert(perf)
	
endfunction

//-----------------------------------------------------
// Print perf.
//
function coPerfPrint(file as string)
	
	local i as integer
	local s as string
	local d as integer
	local fh as integer
	local t as integer
	local j as integer
	local k as integer
	local ss as string
	
	if file = ""
		file = "log.txt"
	endif
			
	fh = OpenToWrite(file)
	
	for i = 0 to co.perfs.length

		if co.perfs[i].idx = 0 // Start.
			
			s = "[" + str(i) + "] Start: " + co.perfs[i].name
				
		elseif co.perfs[i].idx = -1 // End.
			
			t = 0
			j = i
			k = j - 1
			s = ""
			
			// Navigate back.
			
			while k > 0
				
				if co.perfs[k].name = co.perfs[j].name
					
					d = co.perfs[j].time - co.perfs[k].time
					inc t, d
					
					ss = "[from:"
					
					if co.perfs[k].idx = 0
						ss = ss + "start"
					elseif co.perfs[k].idx = -1
						ss = ss + "end"
					else
						ss = ss + str(co.perfs[k].idx)
					endif
					
					ss = ss + " to:"

					if co.perfs[j].idx = 0
						ss = ss + "start"
					elseif co.perfs[j].idx = -1
						ss = ss + "end"
					else
						ss = ss + str(co.perfs[j].idx)
					endif
					
					ss = ss + " delta:" + str(d) + "]"
					s = ss + s
					j = k // Move up so we get the next gap.
					
					if co.perfs[k].idx = 0 // Found the top.
						exit
					endif
					
				endif
				
				dec k
				
			endwhile
			
			s = "[" + str(i) + "] End..: " + co.perfs[j].name + " " + s + " [total:" + str(t) + "]"
			
		endif
		
		writeline(fh, s)
		
	next
	
	if co.perfs.length > -1
		
		s = "Total time: " + str(co.perfs[co.perfs.length].time - co.perfs[0].time)
		writeline(fh, s)
		
	endif
	
	CloseFile(fh)
	
endfunction

//-----------------------------------------------------
// Build the circle image.
//
function coInitCircles()

	local x as float
	local y as float
	local d as integer
	local i as integer
	local img as integer
	
	d = 16
	x = 0

	// 16, 32, 64, 128, 256, 512

	co.circleImg.length = -1
	co.circleSize.length = -1
	
	for i = 0 to 5
		
		co.circleImg.insert(0)
		co.circleSize.insert(0)

	next
	
	for i = 0 to co.circleImg.length

		img = CreateImageColor(0, 0, 0, 0)
		ResizeImage(img, d, d)
		SetRenderToImage(img, 0)
		SetVirtualResolution(GetImageWidth(img), GetImageHeight(img))
		DrawEllipse(x + d / 2, y + d / 2, d / 2, d / 2, co.white, co.white, true)
		SetRenderToScreen()
		SetVirtualResolution(co.w, co.h)

		co.circleImg[i] = img
		co.circleSize[i] = d

		d = d * 2

	next
	
endfunction

//-----------------------------------------------------
// Log a message ready to print.
//
function coLog(msg as string)

	local s as string 
	
	s = str(co.logNbr) + ": " + msg
	co.log.insert(s)
	co.logMsg = ""

	if co.logLineMax > -1
		if co.log.length > co.logLineMax
			co.log.remove(0)
		endif
	endif
	
	co.logNbr = co.logNbr + 1
	
endfunction

//-----------------------------------------------------
// Log a message ready to print.
//
function coLogPrint(file as string)

	local msg as string
	local i as integer
	local fh as integer

	if file <> ""	
			
		fh = OpenToWrite(file)
		co.logMsg = "" // To trigger code below.
		
	else
		
		fh = 0
		
	endif

	if co.logMsg = ""
		if co.logTop
			for i = co.log.length to 0 step -1
				if fh
					writeline(fh, co.log[i])
				else
					co.logMsg = co.logMsg + co.log[i] + chr(10)
				endif
			next
		else
			for i = 0 to co.log.length
				if fh
					writeline(fh, co.log[i])
				else
					co.logMsg = co.logMsg + co.log[i] + chr(10)
				endif
			next		
		endif
	endif
	
	if fh
		closefile(fh)
	else
		print(co.logMsg)
	endif
	
endfunction

//-----------------------------------------------------
function coMessage(msg as string)
	
	//coLog(msg$)
	message(msg)
	
endfunction

//-----------------------------------------------------
// Log a message ready to print.
//
function coLogClear()
	
	co.log.length = -1
	co.logNbr = 1
	
endfunction

//-----------------------------------------------------
// Set the log point.
// logTop=true for prepend, or false for append.
//
function coLogTop(logTop as integer)
	
	co.logTop = logTop
	
endfunction

//-----------------------------------------------------
// IMAGES / SPRITES

//-----------------------------------------------------
// Check whether the rect(ax, ay, aw, ah) in completely within rect (bx, by, bw, bh)
//
function coRectWithinRect(ax as float, ay as float, aw as float, ah as float, bx as float, by as float, bw as float, bh as float)
		
	local ret as integer
	
	If ax >= bx and ax + aw <= bx + bw and ay >= by and ay + ah <= by + bh
		ret = true
	else
		ret = false
	endif
	
endfunction ret

//-----------------------------------------------------
// Check whether the rect(ax, ay, aw, ah) overlaps any over rect (bx, by, bw, bh)
//
function coRectOverlapsRect(ax as float, ay as float, aw as float, ah as float, bx as float, by as float, bw as float, bh as float)
		
	local ret as integer
	
	If ax > bx + bw - 1 Or ax + aw - 1 < bx Or ay > by + bh - 1 Or ay + ah - 1 < by
		ret = False
	else
		ret = True
	endif
	
endfunction ret

//-----------------------------------------------------
// Check whether the rect1 overlaps any over rect2
//
function coRectOverlapsRect2(rect1 ref as Line, rect2 as Line)

	local ret as integer
	
	ret = coRectOverlapsRect(rect1.x0, rect1.y0, rect1.x1 - rect1.x0 + 1, rect1.y1 - rect1.y0 + 1, rect2.x0, rect2.y0, rect2.x1 - rect2.x0 + 1, rect2.y1 - rect2.y0 + 1)
	
endfunction ret

//-----------------------------------------------------
// Check whether the rect(ax, ay, aw, ah) overlaps anywhere over rect (bx, by, bw, bh)
// Returns the edges.
//
function coRectOverlapRectEdges(ax as float, ay as float, aw as float, ah as float, bx as float, by as float, bw as float, bh as float)
		
	local ret as integer

	ret = 0
	
	If (ax < bx + bw - 1 and ax + aw - 1 > bx + bw - 1)
		ret = ret || DIR_E
	endif
	
	if (ax < bx and ax + aw - 1 > bx)
		ret = ret || DIR_W
	endif
	
	if (ay < by + bh - 1 and ay + ah - 1 > by + bh - 1)
		ret = ret || DIR_S
	endif
	
	if (ay < by and ay + ah - 1 > by)
		ret = ret || DIR_N
	endif
	
endfunction ret

//-----------------------------------------------------
// Check if two sprites have collided.
// Type both must be visible.
//
function coGetSpriteCollision(spr1 as integer, spr2 as integer)

	local ret as integer = false
	
	if GetSpriteVisible(spr1)
		if GetSpriteVisible(spr2)
			ret = GetSpriteCollision(spr1, spr2)
		endif
	endif
	
endfunction ret

//-----------------------------------------------------
// Create a rect from sprite bounds.
//
function coGetSpriteRect(spr as integer, rect ref as Rect)
	
	rect.x = getspritex(spr)
	rect.y = getspritey(spr)
	rect.w = GetSpriteWidth(spr)
	rect.h = GetSpriteHeight(spr)

endfunction

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
// NOTE: assumes ByOffset positioning.
//
function coGetSpriteHitTest(spr as integer, x as float, y as float, extra as float)
		
	local ret as integer

	ret = coGetSpriteHitTest3(spr, x, y, extra, extra, extra, extra)

endfunction ret

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
// NOTE: assumes ByOffset positioning.
//
function coGetSpriteHitTest2(spr as integer, x as float, y as float, horiz as float, vert as float)
		
	local ret as integer

	ret = coGetSpriteHitTest3(spr, x, y, horiz, horiz, vert, vert)

endfunction ret

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
//
function coGetSpriteHitTest3(spr as integer, x as float, y as float, l as float, r as float, t as float, b as float)
		
	local ret as integer

	if spr
		ret = getspritevisible(spr) and coPointWithinRect(x, y, GetSpriteX(spr) - l, GetSpriteY(spr) - t, l + GetSpriteWidth(spr) + r, t + GetSpriteHeight(spr) + b)
	else
		ret = 0
	endif
	
endfunction ret

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
// NOTE: assumes ByOffset positioning.
//
function coGetSpriteHitTest4(spr as integer, x as float, y as float, extra as float)
		
	local ret as integer

	ret = coGetSpriteHitTest6(spr, x, y, extra, extra, extra, extra)

endfunction ret

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
// NOTE: assumes ByOffset positioning.
//
function coGetSpriteHitTest5(spr as integer, x as float, y as float, horiz as float, vert as float)
		
	local ret as integer

	ret = coGetSpriteHitTest6(spr, x, y, horiz, horiz, vert, vert)

endfunction ret

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
//
function coGetSpriteHitTest6(spr as integer, x as float, y as float, l as float, r as float, t as float, b as float)
		
	local ret as integer

	if spr
		ret = coPointWithinRect(x, y, GetSpriteX(spr) - l, GetSpriteY(spr) - t, l + GetSpriteWidth(spr) + r, t + GetSpriteHeight(spr) + b)
	else
		ret = 0
	endif
	
endfunction ret

//-----------------------------------------------------
// Check whether rect1 px, py is within x,y,w,h
//
function coPointWithinRect(px as float, py as float, x as float, y as float, w as float, h as float)
		
	local ret as integer
	
	if px >= x And px < x + w And py >= y And py < y + h
		ret = true
	else
		ret = false
	endif
	
endfunction ret

//-----------------------------------------------------
// Check whether px, py is within rect
//
function coPointWithinRect2(px as float, py as float, rect ref as Rect)
		
	local ret as integer
	
	ret = coPointWithinRect(px, py, rect.x, rect.y, rect.w, rect.h)
	
endfunction ret

//-----------------------------------------------------
// Given a hex string, return an int value.
// Can include a # at the fromt, which will be ignored.
//
function coHexToInt(h as string)

	local ret as integer
	
	if left(h, 1) = "#"
		h = mid(h, 2, -1)
	endif

	ret = val(h, 16)
	
endfunction ret

//-----------------------------------------------------
// Check if the string is hex.
//
function coIsHex(h as string)

	local ret as integer
	local i as integer
	local c as string 

	ret = true

	for i = 1 to len(h)

		c = mid(h, i, 1)
		
		if FindString(HEX_CHARS$, c) = 0
			
			ret = false
			exit

		endif
		
	next
	
endfunction ret

//-----------------------------------------------------
// Given a string in hex form or dec form, return a makecolor value.
// $ = hex, # = dec, @ = name, e.g. red0
//
function coMakeColor(h as string)

	local ret as integer
	
	if left(h, 1) = "$"
		ret = coMakeHexColor(h)
	elseif left(h, 1) = "#"
		ret = coMakeDecColor(h)
	elseif left(h, 1) = "@"
		ret = coMakeNameColor(h)
	else
		ret = MakeColor(0, 0, 0)
	endif
	
endfunction ret

//-----------------------------------------------------
// Given a string for a color segment, e.g. red, in hex form or dec form, return a makecolor value.
//
function coMakeColorSegment(h as string)

	local ret as integer

	if left(h, 1) = "#"
		ret = coHexToInt(h)
	else 
		ret = val(h)
	endif

	if ret < 0
		ret = 0
	elseif ret > 255
		ret = 255
	endif
	
endfunction ret

//-----------------------------------------------------
// Given a string in hex form or dec form, return a makecolor value.
//
function coIsValidColor(h as string)

	local ret as integer
	local v as string 

	ret = true
	
	if len(h) = 7
		if not coIsValidHex(h)
			ret = false
		endif
	elseif len(h) = 9

		v = left(h, 3)
		
		if not coIsValidNbr(v, false, false) or val(v) > 255
			ret = false
		endif

		v = mid(h, 4, 3)
		
		if not coIsValidNbr(v, false, false) or val(v) > 255
			ret = false
		endif

		v = mid(h, 7, 3)
		
		if not coIsValidNbr(v, false, false) or val(v) > 255
			ret = false
		endif


	endif
	
endfunction ret

//-----------------------------------------------------
// Check that the passed string is valid hex.
//
function coIsValidHex(h as string)

	local i as integer
	local ret as integer
	local c as string 

	ret = true
	h = upper(h)
	
	for i = 1 to len(h)
		
		c = mid(h, i, 1)
		
		if FindString("0123456789ABCDEF", c) = 0
			
			ret = false
			exit

		endif
		
	next
	
endfunction ret

//-----------------------------------------------------
// Check that the passed string is valid number.
// if isDec is true, then one . in the number is okay.
//
function coIsValidNbr(h as string, isDec as integer, allowNeg as integer)

	local i as integer
	local ret as integer
	local c as string
	local dotCount as integer
	local startIdx as integer

	ret = true
	dotCount = 0
	startIdx = 1

	if allowNeg
		if mid(h, 1, 1) = "-"
			inc startIdx
		endif			
	endif
	
	h = upper(h)
	
	for i = startIdx to len(h)
		
		c = mid(h, i, 1)
		
		if FindString("0123456789.", c) = 0
			
			ret = false
			exit

		elseif c = "."

			inc dotCount
			
		endif
		
	next

	if ret
		if isDec
			if dotCount > 1
				ret = false
			endif
		else
			if dotCount > 0
				ret = false
			endif
		endif
	endif		
	
endfunction ret

//-----------------------------------------------------
// Add a color to the master color list.
//
function coAddMasterColor(h as string)
	
	local col as integer
	local cn as ColorName
	
	col = coMakeHexColor(h)
	co.colors.insert(col)
	
	cn.name = co._colorName + str(co._colorNameIdx)
	inc co._colorNameIdx
	cn.col = col
	co.colorNames.insert(cn)
	
endfunction col

//-----------------------------------------------------
// Find a color and move back/forth for another color.
//
function coFindColor(col as integer, delta as integer)
	
	local ret as integer
	local i as integer
	
	ret = col

	for i = 0 to co.colors.length
		
		if co.colors[i] = col
			
			if i + delta > -1 and i + delta < co.colors.length
				ret = co.colors[i + delta]
			endif
			
		endif
		
	next
		
endfunction ret

//-----------------------------------------------------
// Given a hex string in the form rrggbb, return a makecolor value.
//
function coMakeHexColor(h as string)
	
	local r as integer
	local g as integer
	local b as integer
	local ret as integer

	if len(h) = 7

		if left(h, 1) = "#"			
			h = mid(h, 2, -1)
		else
			h = ""
		endif

	endif

	if len(h) = 6
	
		r = val(mid(h, 1, 2), 16)
		g = val(mid(h, 3, 2), 16)
		b = val(mid(h, 5, 2), 16)
		
		ret = makecolor(r, g, b)

	else

		ret = MakeColor(0, 0, 0)

	endif
	
endfunction ret

//-----------------------------------------------------
// Get a color based on a name.
//
function coMakeNameColor(name as string)
	
	local i as integer
	
	if left(name, 1) = "@"
		name = mid(name, 2, -1)
	endif
	
	for i = 0 to co.colorNames.length
		if co.colorNames[i].name = name
			exitfunction co.colorNames[i].col
		endif
	next
	
endfunction co.black

//-----------------------------------------------------
// Given a hex string check that its valid hex chars and no longer than ln.
//
function coValidHex(h as string)
	
	local i as integer
	local c as string
	local ret as string
	
	ret = ""
	
	for i = 1 to len(h)
		
		c = mid(h, i, 1)
		
		if FindStringCount("0123456789ABCDEF", c, true, 1)
			ret = ret + upper(c)
		endif
		
	next
	
endfunction ret

//-----------------------------------------------------
// Given a duration string check that its valid.
//
function coValidDuration(d as string)
	
	local dur as Duration
	local v as integer
	local t as string
	
	v = coParseDuration(d, dur)
	t = coFormatDuration(v, dur)
	
endfunction t

//-----------------------------------------------------
// Given a time string check that its valid.
//
function coValidTime(t as string)
	
	local i as integer
	local c as string
	local ret as string
	
	ret = ""
	
	for i = 1 to len(t)
		
		c = mid(t, i, 1)
		
		if FindStringCount("0123456789:", c, true, 1)
			ret = ret + c
		endif
		
	next
	
endfunction ret

//-----------------------------------------------------
// Get the number of days for a month.
//
function coMonthDays(m as integer, y as integer)
	
	local d as integer
	
	d = co.monthDays[m]

	if m = 2
		d = d + getleapyear(y) // coIsLeapYear(y)
	endif
	
endfunction d

//-----------------------------------------------------
// Get the number of days for a year.
//
function coYearDays(y as integer)
	
	local d as integer
	
	d = 365 + getleapyear(y) // coIsLeapYear(y)
	
endfunction d

//-----------------------------------------------------
// Return 1 if the year is a leap year, otherwise 0.
//
function coIsLeapYear(y as integer)
	
	local leap as integer
	
	leap = 0
	
	if mod(y, 4) = 0
		if mod(y, 100) = 0
			if mod(y, 400) = 0
				leap = 1
			endif
		else
			leap = 1
		endif
	endif
	
endfunction leap

//-----------------------------------------------------
// Return the Julian day number from the passed date.
//
function coDateToJDN(day as integer, month as integer, year as integer)
	
	local a as integer
	local m as integer
	local y as integer
	local ret as integer
	
	a = (14 - month) / 12
	m = month + 12 * a - 3
	y = year + 4800 - a
	ret = day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045

endfunction ret

//-----------------------------------------------------
// Return the date from Julian day number.
//
function coJDNToDate(jdn as integer, date ref as Date)
	
	local t1 as integer
	local t2 as integer
	local t3 as integer
	local t4 as integer
	
	t1 = jdn + 1401 + (((4 * jdn + 274277) / 146097) * 3) / 4 -38
	t2 = 4 * t1 + 3
	t3 = Mod(t2,1461) / 4
	t4 = 5 * t3 + 2
	date.d = Mod(t4, 153) / 5 + 1
	date.m = Mod((t4 / 153 + 2), 12) + 1
	date.y = t2 / 1461 - 4716 + (12 + 2 - date.m) / 12
	
endfunction

//-----------------------------------------------------
// Return the days b/n two dates.
//
function coDaysBetween(d1 as integer, m1 as integer, y1 as integer, d2 as integer, m2 as integer, y2 as integer)

	local j1 as integer
	local j2 as integer
	local ret as integer
	
	j1 = coDateToJDN(d1, m1, y1)
	j2 = coDateToJDN(d2, m2, y2)
	ret = j1 - j2

endfunction ret

//-----------------------------------------------------
// Add days to the passed date.
//
function AddDays(date ref as Date, v as integer)
	
	local j as integer
	
	j = coDateToJDN(date.d, date.m, date.y) + v
	coJDNToDate(j, date)
	
endfunction

//-----------------------------------------------------
// Add (or subtract with -ve) amounts to a time.
//
function coAddDateTime(time as integer, yy as integer, mm as integer, dd as integer, h as integer, m as integer, s as integer)
	
	local tmp as integer
	local d as Date
	local t as Time
	
	coGetDate(time, d)
	coGetTime(time, t)
	
	t.s = t.s + s
	
	if t.s > 59
		
		tmp = t.s / 60
		t.s = t.s - tmp * 60
		t.m = t.m + tmp
	
	endif
	
	t.m = t.m + m
	
	if t.m > 59
		
		tmp = t.m / 60
		t.m = t.m - tmp * 60
		t.h = t.h + tmp
	
	endif
	
	t.h = t.h + h
	
	if t.h > 23
		
		tmp = t.h / 24
		t.h = t.h - tmp * 24
		d.d = d.d + tmp
	
	endif

	d.m = d.m + m
	
	if d.m > 12
		
		tmp = d.m / 12
		d.m = d.m - tmp * 12
		d.y = d.y + tmp
	
	endif
	
	d.d = d.d + dd
	
	while d.d > co.monthDays[d.m]

		d.d = d.d - co.monthDays[d.m]
		
		inc d.m
		
		if d.m > 12
			
			d.y = d.y + 1
			d.m = 1
			
		endif
				
	endwhile
	
	d.y = d.y + yy
	
	if d.y > 2038		
		d.y = 2038		
	endif
	
	//time = coDateTimeToTime(d, t)
	tmp = GetUnixFromDate(d.y,d.m, d.d, t.h, t.m, t.s)

endfunction tmp

//-----------------------------------------------------
// Calculate the text color to use based on the col passed in.
//
function coCalcTextColor(col as integer)
	
/*
	local cols as float[]
	local ret as float
	local i as integer
	
	cols.insert(GetColorRed(col) / 255.0)
	cols.insert(GetColorGreen(col) / 255.0)
	cols.insert(GetColorBlue(col) / 255.0)
	
	for i = 0 to cols.length
		if cols[i] < 0.03928
			cols[i] = col / 12.92
		else
			cols[i] = pow((cols[i] + 0.055) / 1.055, 2.4)
		endif
	next

	col = (0.2126 * cols[0]) + (0.7152 * cols[1]) + (0.0722 * cols[2])
  
	if col > 0.179
		ret = co.black
	else
		ret = co.white
	endif
*/
	
	local r as float
	local g as float
	local b as float
	local ret as integer
	
	r = GetColorRed(col)
	g = GetColorGreen(col)
	b = GetColorBlue(col)
	
	if ((r * 0.299) + (g * 0.587) + (b * 0.114)) > 149 // 186
		ret = co.black
	else
		ret = co.white
	endif

endfunction ret

//-----------------------------------------------------
// Given a dec string in the form rrrgggbbb, return a makecolor value.
//
function coMakeDecColor(h as string)
	
	local r as integer
	local g as integer
	local b as integer
	local ret as integer

	if len(h) = 9
		
		r = val(mid(h, 1, 3), 10)
		g = val(mid(h, 4, 3), 10)
		b = val(mid(h, 7, 3), 10)
		
		ret = makecolor(r, g, b)

	else

		ret = makecolor(0, 0, 0)

	endif
	
endfunction ret

//-----------------------------------------------------
// Return the smaller of the too values.
//
function coMinValue(a as float, b as float)
	
	if a > b
		exitfunction b
	endif
	
endfunction a

//-----------------------------------------------------
// Return the larger of the too values.
//
function coMaxValue(a as float, b as float)
	
	if a > b
		exitfunction a
	endif
	
endfunction b

//-----------------------------------------------------
// Return the value adjusted to be within a and b.
//
function coBetweenValue(v as float, a as float, b as float)
	
	if v < a
		exitfunction a
	elseif v > b
		exitfunction b
	endif
	
endfunction v

//-----------------------------------------------------
// Set the color of the clear color.
//
function coSetPrintSize(size as integer)

	SetPrintSize(size)
	co.printSize = size
	//co.logLineMax = floor(co.h / co.printSize)

endfunction

//-----------------------------------------------------
// Set the color of the print color.
//
function coSetPrintColor(col as integer)
	
	SetPrintColor(getcolorred(col), getcolorgreen(col), getcolorblue(col))

endfunction

//-----------------------------------------------------
// Set the color of the clear color.
//
function coRandomColor()
	
	local col as integer
	
	col = makecolor(random(0, 255), random(0, 255), random(0, 255))
	
endfunction col

//-----------------------------------------------------
// Set the color of the clear color.
//
function coSetClearColor(col as integer)
	
	SetClearColor(getcolorred(col), getcolorgreen(col), getcolorblue(col))

endfunction


//-----------------------------------------------------
// Set the color of the clear color.
//
function coSetBorderColor(col as integer)
	
	SetborderColor(getcolorred(col), getcolorgreen(col), getcolorblue(col))

endfunction

//-----------------------------------------------------
// Set the color of the passed sprite using bit pattern color.
//
function coSetSpriteColor(spr as integer, col as integer)
	
	SetSpriteColor(spr, getcolorred(col), getcolorgreen(col), getcolorblue(col), 255)

endfunction

//-----------------------------------------------------
// Set the color of the passed sprite using bit pattern color.
//
function coSetSpriteColor2(spr as integer, col as integer)
	
	SetSpriteColor(spr, getcolorred(col), getcolorgreen(col), getcolorblue(col), GetColorAlpha(col))

endfunction

//-----------------------------------------------------
// Set the color of the sky box.
//
function coSetSkyBoxHorizonColor(col as integer)
	
	SetSkyBoxHorizonColor(getcolorred(col), getcolorgreen(col), getcolorblue(col))

endfunction
	
//-----------------------------------------------------
// Set the color of the passed sprite using bit pattern color.
//
function coSetSpriteColorAlpha(spr as integer, col as integer, alpha as integer)
	
	SetSpriteColor(spr, getcolorred(col), getcolorgreen(col), getcolorblue(col), alpha)

endfunction

//-----------------------------------------------------
// Set the color of the passed sprite using bit pattern color.
//
function coSetSpriteAlpha(spr as integer, alpha as integer)
	
	SetSpriteColor(spr, getSpriteColorRed(spr), getSpriteColorGreen(spr), getSpriteColorBlue(spr), alpha)

endfunction

//-----------------------------------------------------
// Get the color of the passed sprite returning a bit pattern color.
//
function coGetSpriteColor(spr as integer)
	
	ret as integer
	ret = makecolor(getspritecolorred(spr), getspritecolorgreen(spr), getspritecolorblue(spr))

endfunction ret

//-----------------------------------------------------
// Get the color of the passed sprite returning a bit pattern color + alpha.
//
function coGetSpriteColor2(spr as integer)
	
	ret as integer
	ret = makecolor(getspritecolorred(spr), getspritecolorgreen(spr), getspritecolorblue(spr), getspritecoloralpha(spr))

endfunction ret

//-----------------------------------------------------
// Set the color of the passed text using bit pattern color.
//
function coSetTextColor(text as integer, col as integer)
	
	SetTextColor(text, getcolorred(col), getcolorgreen(col), getcolorblue(col), 255)

endfunction

//-----------------------------------------------------
// Set the color of the passed text using bit pattern color.
//
function coSetTextColorAlpha(spr as integer, col as integer, alpha as integer)
	
	SetTextColor(spr, getcolorred(col), getcolorgreen(col), getcolorblue(col), alpha)

endfunction

//-----------------------------------------------------
// Set the color of the passed text using bit pattern color.
//
function coSetTextAlpha(text as integer, alpha as integer)
	
	SetTextColor(text, getTextColorRed(text), getTextColorGreen(text), getTextColorBlue(text), alpha)

endfunction

//-----------------------------------------------------
// Set the color of the passed edit box using bit pattern color.
//
function coSetEditBoxColor(box as integer, col as integer)
	
	SetEditBoxBackgroundColor(box, getcolorred(col), getcolorgreen(col), getcolorblue(col), 255)

endfunction

//-----------------------------------------------------
// Set the color of the passed edit box using bit pattern color.
//
function coSetEditBoxColorAlpha(box as integer, col as integer, alpha as integer)
	
	SetEditBoxBackgroundColor(box, getcolorred(col), getcolorgreen(col), getcolorblue(col), alpha)

endfunction

//-----------------------------------------------------
// Set the color of the passed edit box text using bit pattern color.
//
function coSetEditBoxTextColor(box as integer, col as integer)
	
	SetEditBoxTextColor(box, getcolorred(col), getcolorgreen(col), getcolorblue(col))

endfunction

//-----------------------------------------------------
// Set the color of the passed edit box text using bit pattern color.
//
function coSetEditBoxCursorColor(box as integer, col as integer)
	
	SetEditBoxCursorColor(box, getcolorred(col), getcolorgreen(col), getcolorblue(col))

endfunction

//-----------------------------------------------------
// Set the color of the passed edit box border using bit pattern color.
//
function coSetEditBoxBorderColor(box as integer, col as integer)
	
	SetEditBoxBorderColor(box, getcolorred(col), getcolorgreen(col), getcolorblue(col), 255)

endfunction

//-----------------------------------------------------
// Set the color of the passed edit box border using bit pattern color.
//
function coSetEditBoxBorderColorAlpha(box as integer, col as integer, alpha as integer)
	
	SetEditBoxBorderColor(box, getcolorred(col), getcolorgreen(col), getcolorblue(col), alpha)

endfunction

//-----------------------------------------------------
// Set the color of the passed edit box border using bit pattern color.
//
function coSetEditBoxBackgroundColor(box as integer, col as integer)
	
	SetEditBoxBackgroundColor(box, getcolorred(col), getcolorgreen(col), getcolorblue(col), 255)

endfunction

//-----------------------------------------------------
// Display the passed 'millis' int as hh:mm:ss
//
function coTimeToString(millis as integer, frac as integer)

	local h as integer
	local m as integer
	local s as integer
	local f as integer // Hundreths.
	local div as integer

	div = (1000 * 60 * 60)
	h = millis / div
	millis = millis - h * div
	
	div = (1000 * 60)
	m = millis / div
	millis = millis - m * div

	div = 1000
	s = millis / div
	millis = millis - s * div

	f = round(millis / 10.0)

	local ret as string

	if h > 0

		ret = ret + right("00" + str(h), 2)
		ret = ret + ":"

	endif
	
	ret = ret + right("00" + str(m), 2)
	ret = ret + ":"
	ret = ret + right("00" + str(s), 2)

	if frac

		ret = ret + "."
		ret = ret + right("00" + str(f), 2)

	endif

endfunction ret

//-----------------------------------------------------
// Convert a float to a string price.
//
function coFloatToPrice(price as float)

	local ret as string
	local pos as integer

	ret = "$" + str(price)
	pos = FindString(ret, ".")

	if pos > 0
		
		pos = pos + 2
		ret = mid(ret, 1, pos)
		
	endif
	
endfunction ret

//-----------------------------------------------------
// Convert a color value to a rrrgggbbb dec string
//
function coColorToDec(col as integer)

	local ret as string

	ret = ""
	ret = ret + right("00" + str(GetColorRed(col)), 3)
	ret = ret + right("00" + str(GetColorGreen(col)), 3)
	ret = ret + right("00" + str(GetColorBlue(col)), 3)
	
endfunction ret

//-----------------------------------------------------
// Convert a color segment value (e.g. red) to a nnn dec string
//
function coColorSegmentToDec(col as integer, digits as integer)

	local ret as string

	if digits > 0
		ret = right("00" + str(col), digits)
	else
		ret = str(col)
	endif
	
endfunction ret

//-----------------------------------------------------
// Convert a color value to a rrggbb hex string
//
function coColorToHex(col as integer)

	local ret as string

	ret = ""
	ret = ret + right("0" + hex(GetColorRed(col)), 2)
	ret = ret + right("0" + hex(GetColorGreen(col)), 2)
	ret = ret + right("0" + hex(GetColorBlue(col)), 2)
	
endfunction ret

//-----------------------------------------------------
// Convert a color segment value (e.g. red) to a nn hex string
//
function coColorSegmentToHex(col as integer, digits as integer)

	local ret as string

	if digits > 0
		ret = ret + right("0" + hex(col), digits)
	else
		ret = hex(col)
	endif
	
endfunction ret

//-----------------------------------------------------
function coBoolToString(bool as integer)

	local ret as string

	if bool
		ret = "true"
	else
		ret = "false"
	endif
	
endfunction ret

//-----------------------------------------------------
function coStringToBool(text as string)

	local ret as integer

	if lower(text) = "true"
		ret = 1
	else
		ret = 0
	endif
	
endfunction ret

//-----------------------------------------------------
// Convert a dir to a string.
//
function coDirToString(dir as integer)

	local ret as string

	ret = ""

	if dir && DIR_N

		ret = ret + "n"
	endif
	
	if dir && DIR_S

		if ret <> "" then ret = ret + "-"
		ret = ret + "s"

	endif
	
	if dir && DIR_W

		if ret <> "" then ret = ret + "-"
		ret = ret + "w"

	endif
	
	if dir && DIR_E

		if ret <> "" then ret = ret + "-"
		ret = ret + "e"

	endif
		
endfunction ret

//-----------------------------------------------------
// Convert a string to a dir.
// The string can be a single dir, e.g. n / north,
// or multiple delimited by -, e.g. n-e, or north-east.
//
function coStringToDir(s as string)

	local dir as integer
	local count as integer
	local t as string
	local i as integer

	dir = 0

	count = CountStringTokens2(s, "-")
	
	for i = 1 to count

		t = GetStringToken2(s, "-", i)
		
		if t= "n"
			dir = dir || DIR_N
		endif
		
		if t = "s"
			dir = dir || DIR_S
		endif
		
		if t = "e"
			dir = dir || DIR_E
		endif
		
		if t = "w"
			dir = dir || DIR_W
		endif

	next
				
endfunction dir


//-----------------------------------------------------
// Get a direction, based on an angle.
// If fuzzy is true, then the ang will be "forced" to a 90 degree angle.
//
function coAngleToDir(ang as float, fuzzy as integer)

	local dir as integer

	ang = mod(ang, 360)

	if fuzzy
		ang = (ang / 90) * 90
	endif
	
	if ang = 0
		dir = DIR_N
	elseif ang = 90
		dir = DIR_E
	elseif ang = 180
		dir = DIR_S
	elseif ang = 270
		dir = DIR_W
	endif

endfunction dir

//-----------------------------------------------------
// Get the angle for the passed dir.
//
function coDirToAngle(dir as integer)

	local ang as float
	
	if dir = DIR_E
		ang = 90
	elseif dir = DIR_S
		ang = 180
	elseif dir = DIR_W
		ang = 270
	elseif dir = DIR_NE
		ang = 45
	elseif dir = DIR_SE
		ang = 135
	elseif dir = DIR_SW
		ang = 225
	elseif dir = DIR_NW
		ang = 315
	else // if dir = DIR_N
		ang = 0
	endif

endfunction ang

//-----------------------------------------------------
// Creates a string with 's' repeated 'count' times.
//
function coRepeatString(s as string, count as integer, delim as string)

	local ret as string
	local i as integer

	for i = 1 to count
		
		if i > 1 then ret = ret + delim
		ret = ret + s
		
	next
	
endfunction ret

//----------------------------------------------------------
// Takes a number that is a float like 0.000000 amd strips all
// unneccesary 0's.
//
function coTrimFloatStr(s as string)

	local idx as integer
	local pos as integer

	// Check redundant 0's at front of number.
	idx = 1
	
	while mid(s, idx, 1) = "0"
		inc idx
	endwhile

	s = mid(s, idx, -1)

	if s = ""

		// Integer 0, put it back. We're done.
		s = "0"
		
	else

		// Check if it's decimal.
		pos = FindString(s, ".")

		if pos > 0
			
			// Is it decimal, now remove 0's from the back.
			idx = len(s)
			
			while mid(s, idx, 1) = "0"
				dec idx
			endwhile

			// If we have eaten all the decimal zeroes, get rid of the dot too.
			if mid(s, idx, 1) = "."
				dec idx
			endif

			s = left(s, idx)

			// Make sure we still have a zero before the .
			if pos = 1
				s = "0" + s
			endif
			
		endif

	endif
		
endfunction s

//-----------------------------------------------------
// Fill 'arr' with value 'v'.
//
function coFillArray(arr ref as integer[], v as integer)

	local i as integer

	for i = 0 to arr.length - 1
		arr[i] = v
	next

endfunction

// --------------------------------------------------------------------
// Make an integer value combining x as top 16 bits, and y as bottom 16 bits.
//
function coMakePoint(x as integer, y as integer)

	local v as integer
	v = x << 16
	v = v + y
	//colog("x=" + str(x) + ", y=" + str(y) + ", v=" + str(v))
	
endfunction v

// --------------------------------------------------------------------
// Return the x portion of a maze point.
//
function coGetPointX(pt as integer)

	local x as integer
	x = (pt >> 16) && 0x0000ffff
	//colog("pt=" + str(pt) + ", x=" + str(x))
	
endfunction x

// --------------------------------------------------------------------
// Return the y portion of a maze point.
//
function coGetPointY(pt as integer)

	local y as integer
	y = pt && 0x0000ffff
	//colog("pt=" + str(pt) + ", y=" + str(y))
	
endfunction y

// --------------------------------------------------------------------
// Get a string rep of a pt.
//
function coPointToString(pt as integer)

	local s as string

	s = "(" + str(coGetPointX(pt)) + "," + str(coGetPointY(pt)) + ")"
	
endfunction s

// --------------------------------------------------------------------
// Create a color streak (list of colors) starting from firstCol, ending at lastCol.
//
function coCalcColorRange(cols ref as integer[], steps as float, firstCol as integer, lastCol as integer)

	local i as integer
	local ratio as float
	local red as integer
	local green as integer
	local blue as integer
	local newCol as integer
	//local cols as integer[]
	
	for i = 0 to steps - 1
	
		ratio = i / steps
		red = GetColorRed(lastCol) * ratio + GetColorRed(firstCol) * (1 - ratio)
		green = GetColorGreen(lastCol) * ratio + GetColorGreen(firstCol) * (1 - ratio)
		blue = GetColorBlue(lastCol) * ratio + GetColorBlue(firstCol) * (1 - ratio)		
		newCol = MakeColor(red, green, blue)
		//colog("ratio=" + str(ratio) + ", r=" + str(red) + ", g=" + str(green) + ", b=" + str(blue))
		cols.insert(newCol)

	next

endfunction

// --------------------------------------------------------------------
// Convert a hsv to rgb.
//
function coColToRGB(col as integer, rgb ref as RGB)
	
	rgb.r = GetColorRed(col)
	rgb.g = GetColorGreen(col)
	rgb.b = GetColorBlue(col)
	
endfunction

// --------------------------------------------------------------------
// Convert a hsv to rgb.
//
function coHSVToRGB(hsv ref as HSV, rgb ref as RGB)
		
	if hsv.h > 360
		hsv.h = 360
	elseif hsv.h < 0
		hsv.h = 0
	endif
		
	if hsv.s > 100
		hsv.s = 100
	elseif hsv.s < 0
		hsv.s = 0
	endif
		
	if hsv.v > 100
		hsv.v = 100
	elseif hsv.v < 0
		hsv.v = 0
	endif

	local s as float 
	local v as float
	local c as float 
	local x as float 
	local m as float
	local r as float
	local g as float
	local b as float

	s = hsv.s / 100.0
	v = hsv.v / 100.0
	c = s * v
	x = c * (1 - abs(fmod(hsv.h / 60.0, 2) - 1))
	m = v - c

	if hsv.v >= 0 and hsv.v < 60
		
		r = c
		g = x
		b = 0
		
	elseif hsv.h >= 60 and hsv.h < 120
		
		r = x
		g = c
		b = 0
	
	elseif hsv.h >= 120 and hsv.h < 180
	
		r = 0
		g = c
		b = x
	
	elseif hsv.h >= 180 and hsv.h < 240
	
		r = 0
		g = x
		b = c
	
	elseif hsv.h >= 240 and hsv.h < 300
		
		r = x
		g = 0
		b = c
	
	else
	
		r = c
		g = 0
		b = x
		
	endif
	
	rgb.r = (r + m) * 255
	rgb.g = (g + m) * 255
	rgb.b = (b + m) * 255
    	
endfunction

// --------------------------------------------------------------------
// Convert a hsl to rgb.
//
function coHSLToRGB(hsl ref as HSL, rgb ref as RGB)

	if hsl.h > 360
		hsl.h = 360
	elseif hsl.h < 0
		hsl.h = 0
	endif
		
	if hsl.s > 100
		hsl.s = 100
	elseif hsl.s < 0
		hsl.s = 0
	endif
		
	if hsl.l > 100
		hsl.l = 100
	elseif hsl.l < 0
		hsl.l = 0
	endif
		
	local s as float 
	local l as float
	local c as float 
	local x as float 
	local m as float
	local r as float
	local g as float
	local b as float

	s = hsl.s / 100.0
	l = hsl.l / 100.0
	c = (1 - abs(2 * l - 1)) * s
	x = c * (1 - abs(fmod(hsl.h / 60.0, 2) - 1))
	m = l - c / 2

	if hsl.h >= 0 and hsl.h < 60
		
		r = c
		g = x
		b = 0
		
	elseif hsl.h >= 60 and hsl.h < 120
		
		r = x
		g = c
		b = 0
	
	elseif hsl.h >= 120 and hsl.h < 180
	
		r = 0
		g = c
		b = x
	
	elseif hsl.h >= 180 and hsl.h < 240
	
		r = 0
		g = x
		b = c
	
	elseif hsl.h >= 240 and hsl.h < 300
		
		r = x
		g = 0
		b = c
	
	else
	
		r = c
		g = 0
		b = x
		
	endif
	
	rgb.r = (r + m) * 255
	rgb.g = (g + m) * 255
	rgb.b = (b + m) * 255
    	
endfunction

// --------------------------------------------------------------------
// Convert an rgb to hsv.
//
function coRGBToHSV(rgb ref as RGB, hsv ref as HSV)
	
	local r as float
	local g as float
	local b as float
	local cmin as float
	local cmax as float
	local diff as float
	
	r = rgb.r / 255.0
	g = rgb.g / 255.0
	b = rgb.b / 255.0
	
	cmax = coMaxValue(r, coMaxValue(g, b))
	cmin = coMinValue(r, coMinValue(g, b))
	diff = cmax - cmin
	
	if diff = 0 // if cmax and cmax are equal then h = 0
		hsv.h = 0
	elseif cmax = r // if cmax equal r then compute h
		hsv.h = fmod(60 * ((g - b) / diff) + 360, 360)
	elseif cmax = g // if cmax equal g then compute h
		hsv.h = fmod(60 * ((b - r) / diff) + 120, 360)
	elseif cmax = b // if cmax equal b then compute h
		hsv.h = fmod(60 * ((r - g) / diff) + 240, 360)
	endif
	
	if cmax = 0 // if cmax equal zero
		hsv.s = 0
	else
		hsv.s = (diff / cmax) * 100
	endif
	
	hsv.v = cmax * 100 // compute v
	
endfunction

// --------------------------------------------------------------------
// Convert an rgb to hsl.
//
function coRGBToHSL(rgb ref as RGB, hsl ref as HSL)
	
	local r as float
	local g as float
	local b as float
	local cmin as float
	local cmax as float
	local diff as float
	
	r = rgb.r / 255.0
	g = rgb.g / 255.0
	b = rgb.b / 255.0
	
	cmax = coMaxValue(r, coMaxValue(g, b))
	cmin = coMinValue(r, coMinValue(g, b))
	diff = cmax - cmin
	
	if diff = 0 // if cmax and cmax are equal then h = 0
		hsl.h = 0
	elseif cmax = r // if cmax equal r then compute h
		hsl.h = fmod(60 * ((g - b) / diff) + 360, 360)
	elseif cmax = g // if cmax equal g then compute h
		hsl.h = fmod(60 * ((b - r) / diff) + 120, 360)
	elseif cmax = b // if cmax equal b then compute h
		hsl.h = fmod(60 * ((r - g) / diff) + 240, 360)
	endif
	
	hsl.l = (cmax + cmin) / 2 // * 100 // compute v

	if diff = 0 // if cmax equal zero
		hsl.s = 0
	else
		hsl.s = diff / (1 - abs(2 * hsl.l - 1)) * 100
	endif
	
	hsl.l = hsl.l * 100
	//hsl.l = ((cmax + cmin) / 2) * 100 // compute v
		
endfunction

// --------------------------------------------------------------------
// Convert a col to hsv.
//
function coRGBToCol(rgb ref as RGB)
	
	local col as integer
	
	col = MakeColor(rgb.r, rgb.g, rgb.b)
	
endfunction col

//-----------------------------------------------------
//
function coSgn(v as integer)

	local ret as integer
	
	if v < 0
		ret = -1
	elseif v > 0
		ret = 1
	else
		ret = 0
	endif
	
endfunction ret

//-----------------------------------------------------
// Take a size that may be a power of 2 and make it the next power of 2.
//
function coRoundImageSize(v as integer, min as integer, max as integer)

	local pp as integer
	local p as integer

	pp = min
	p = min

	while p < v and p < max

		pp = p
		p = p * 2
		
	endwhile

	if v < pp + (p - pp) / 2
		p = pp
	endif
		
endfunction p

//-----------------------------------------------------
// Load a file containing a string, e.g. json.
//
function coLoadString(fileName as string)

	local file as integer
	local s as string
	
	file = OpenToRead(fileName)
	s = ""
	
	if file
		
		s = readstring(file)	
		CloseFile(file)
		
	endif
	
endfunction s

//-----------------------------------------------------
// Save a file containing a string, e.g. json.
//
function coSaveString(fileName as string, s as string)

	local file as integer
	
	file = OpenToWrite(fileName)
	
	if file
		
		writestring(file, s)	
		CloseFile(file)
		
	endif
	
endfunction

//-----------------------------------------------------
// Delete the settings file.
//
function coDeleteSettings(fileName as string)

	DeleteFile(fileName)
	
endfunction

//-----------------------------------------------------
// Load a file containing a list of k=v lines.
//
function coLoadSettings(fileName as string, list ref as KVPair[])

	local file as integer
	local line as string
	local pair as KVPair
	
	file = OpenToRead(fileName)
	
	if file
		
		while not FileEOF(file)
			
			line = ReadLine(file)
			pair.k = GetStringToken2(line, "=", 1)
			pair.v = GetStringToken2(line, "=", 2)
			coInsertSetting(list, pair)

		endwhile

	endif
	
	CloseFile(file)
	
endfunction

//-----------------------------------------------------
// Insert a pair into the list.
// If the pair's k already exists, replace the value only.
//
function coInsertSetting(list ref as KVPair[], pair ref as KVPair)

	local i as integer
	local found as integer

	found = false
	
	for i = 0 to list.length
		
		if list[i].k = pair.k

			list[i].v = pair.v
			found = true
			
		endif
		
	next

	if not found
		list.insert(pair)
	endif
	
endfunction

//-----------------------------------------------------
// Insert a pair into the list.
// If the pair's k already exists, replace the value only.
//
function coSetSetting(list ref as KVPair[], k as string, v as string)

	local i as integer
	local found as integer
	local pair as KVPair

	found = false
	
	for i = 0 to list.length
		
		if list[i].k = k

			list[i].v = v
			found = true
			
		endif
		
	next

	if not found

		pair.k = k
		pair.v = v
		list.insert(pair)
		
	endif
	
endfunction

//-----------------------------------------------------
// Find a value for a given k (key) into thr settings list.
//
function coGetSetting(list ref as KVPair[], k as string, def as string)

	local i as integer
	local ret as string

	ret = def
	
	for i = 0 to list.length
		
		if list[i].k = k

			ret = list[i].v
			
		endif
		
	next
	
endfunction ret

//-----------------------------------------------------
// Save a list of k=v (Key-value pairs) into the passed file.
//
function coSaveSettings(fileName as string, list ref as KVPair[])

	local file as integer
	local i as integer
	
	file = opentowrite(fileName)

	if file

		for i = 0 to list.length
			writeline(file, list[i].k + "=" + list[i].v)
		next
		
	endif

	CloseFile(file)
	
endfunction

//-----------------------------------------------------
//
function coInitAds() 
 
        select GetDeviceType() //just an array with the contents of getDeviceType()
 
            case "ios"
                SetAdMobDetails("ca-app-pub-3359100048392078/9758071542") //pushdown_full_ios_admob_interstit
 
            endcase
 
            case "android"                
                setAdMobDetails("ca-app-pub-xxxxxxxxxxxxxxx/xxxxxxxxxxxxxxx") //pushdown_android_admob_banner
 
            endcase
        endselect
 
endfunction

//-----------------------------------------------------
//
function coDisplayAdvertBanner()
//call this when you want a banner ad
 
        CreateAdvert(0, 1, 0, 1)
		SetAdvertLocationEx(1, 0, 0, 100, co.iw)
        SetAdvertVisible(true)
        RequestAdvertRefresh()
 
endfunction

//-----------------------------------------------------
//
function coDisplayAdvertFullscreen()
//call this when you want a full screen ad
 
        coInitAds() 
        //PauseMusic() //full screen ads sometimes have sounds/music
        CreateFullscreenAdvert()
        SetAdvertVisible(true)
        RequestAdvertRefresh()
 
endfunction

//-----------------------------------------------------
// Find the sprite as position, that is visible.
//
function coFindDbgSpr(x as float, y as float)

	local spr as integer
	local i as integer
	local depth as integer

	spr = 0
	depth = 0xffffff
	
	if co.sprDebug
		
		for i = 0 to co.sprs.length
			
			if GetSpriteHitTest(co.sprs[i], x, y)
				
				if GetSpriteVisible(co.sprs[i])

					if GetSpriteDepth(co.sprs[i]) < depth
						
						depth = GetSpriteDepth(co.sprs[i])
						spr = co.sprs[i]
						colog("spr=" + str(spr) + ", name=" + co.sprNames[i])
						exit

					endif
					
				endif
				
			endif
			
		next
		
	endif

endfunction spr

//-----------------------------------------------------
//
function coCreateSprite(s as string, img as integer)

	local spr as integer

	spr = createsprite(img)

	if co.sprDebug
		
		co.sprs.insert(spr)
		co.sprNames.insert(s)
			
	endif

	//colog("coCreateSprite: " + s + ", spr=" + str(spr))
	
endfunction spr

//-----------------------------------------------------
//
function coCloneSprite(s as string, img as integer)

	local spr as integer

	spr = clonesprite(img)

	if co.sprDebug
		
		co.sprs.insert(spr)
		co.sprNames.insert(s)

	endif

	//colog("coCreateSprite: " + s + ", spr=" + str(spr))
	
endfunction spr

//-----------------------------------------------------
// Create a text with an explicit size, not a fixed size from fontSizes list.
//
function coCreateText(s as string, fontIdx as integer, fontSiz as float)

	text as integer

	text = createtext(s)
	cosettextfont(text, fontIdx)
	SetTextSize(text, fontSiz)
	coSetTextColor(text, co.white)
	
endfunction text

//-----------------------------------------------------
//
function coSetTextFont(text as integer, fontIdx as integer)
	
	if fontIdx < 0
		fontIdx = 0
	elseif fontIdx > co.fonts.length
		fontIdx = co.fonts.length
	endif
	
	coLoadTextFont(fontIdx)
	SetTextFont(text, co.fonts[fontIdx].id)
	
endfunction

//-----------------------------------------------------
// Convert a weight code to name.
//
function coFontWeightToName(weight as integer)
	
	local ret as string
	
	if weight = CO_FONT_EXTRA_LIGHT
		ret = "Extra Light"
	elseif weight = CO_FONT_LIGHT
		ret = "Light"
	elseif weight = CO_FONT_REGULAR
		ret = "Regular"
	elseif weight = CO_FONT_MEDIUM
		ret = "Medium"
	elseif weight = CO_FONT_SEMI_BOLD
		ret = "Semi Bold"
	elseif weight = CO_FONT_BOLD
		ret = "Bold"
	elseif weight = CO_FONT_BLACK
		ret = "Black"
	else 
		ret = ""
	endif

endfunction ret

//-----------------------------------------------------
// Get the full name of the font for this font object.
//
function coGetFontName(font ref as Font)

	local name as string
	
	name = font.name + " " + coFontWeightToName(font.weight)
	
	if font.italic
		name = name + " Italic"
	endif
	
endfunction name

//-----------------------------------------------------
//
function coLoadTextFont(fontIdx as integer)

	local file as string 
	local folder as string
	local name as string
	
	if fontIdx = 0 // Default font.
		exitfunction
	endif
	
	if not co.fonts[fontIdx].id
		
		folder = replacestring(co.fonts[fontIdx].name, " ", "_", -1)
		name = co.fonts[fontIdx].name + "-" + coFontWeightToName(co.fonts[fontIdx].weight)
		
		if co.fonts[fontIdx].italic
			name = name + " Italic"
		endif

		//colog("Font name before = '" + name + "'")
		name = replacestring(name, " ", "", -1)	
		//colog("Font name after = '" + name + "'")
		file = "fonts/" + folder + "/" + name + ".ttf"
		//colog("Loading font " + file)
		
		co.fonts[fontIdx].id = LoadFont(file)
		
		if not co.fonts[fontIdx].id
			colog("Error: Font " + file + " not found")
		endif
		
	endif

endfunction

//-----------------------------------------------------
// Create a box.
//
function coCreateBox(s as string, w as float, h as float)
	
	spr as integer

	spr = coCreateSprite(s, co.pixImg)	
	SetSpriteScale(spr, w, h)
	
endfunction spr

//-----------------------------------------------------
// Load an image, if it exists in the cache, use that.
//
function coLoadImage(imgs ref as LoadedImage[], file as string)

	local idx as integer
	local li as LoadedImage

	idx = imgs.find(file)

	if idx > -1
		
		li.img = imgs[idx].img
colog("reusing image: " + file)
	else

		li.file = file
		li.img = loadimage(file)
		imgs.insertsorted(li)
colog("loaded image: " + file)
	
	endif
		
endfunction li.img

//-----------------------------------------------------
// Delete an image, and from the cache.
//
function coDeleteImageByName(imgs ref as LoadedImage[], file as string)

	local idx as integer

	idx = imgs.find(file)

	if idx > -1
		
		deleteimage(imgs[idx].img)
		imgs.remove(idx)
	
	endif
		
endfunction

//-----------------------------------------------------
// Remove the img from the img list.
//
function coDeleteImageById(imgs ref as LoadedImage[], img as integer)

	local i as integer

	for i = 0 to imgs.length

		if imgs[i].img = img
			
			imgs.remove(i)
			exit

		endif
	
	next
		
endfunction

//-----------------------------------------------------
//
function coDeleteSprite(s as string, spr as integer)

	deletesprite(spr)

	if co.sprDebug
		
		local i as integer
		
		for i = 0 to co.sprs.length

			if co.sprs[i] = spr
				
				co.sprs.remove(i)
				co.sprnames.remove(i)
				spr = 0
				exit

			endif
			
		next

		if spr
			colog("coDeleteSprite: " + s + ", spr=" + str(spr) + ", was NOT allocated")
		endif

	endif
	
endfunction

//-----------------------------------------------------
//
function coDeleteText(s as string, txt as integer)

	deletetext(txt)

	if co.sprDebug
		
		local i as integer
		
		for i = 0 to co.txts.length

			if co.txts[i] = txt
				
				co.txts.remove(i)
				txt = 0
				exit

			endif
			
		next

		if txt
			colog("coDeleteText: " + s + ", txt=" + str(txt) + ", was NOT allocated")
		endif

	endif

endfunction

//-----------------------------------------------------
//
function coIsMobileDevice()

	local ret as integer
	
	ret = co.baseName = "ios" or co.baseName = "android"

endfunction ret

//-----------------------------------------------------
// Replace tilde + a char with the char they represent, e.g.
// ~n with be replaced with newline
// ~q with quote
// ~0 with nothing, used to seperate ~ and char (e.g. ~n) to be displayed.
// ~~ replaced with 1 single tilde.
//
function coReplaceTildes(s as string)

	s = ReplaceString(s, "~n", chr(9), -1)
	s = ReplaceString(s, "~q", chr(34), -1)
	s = ReplaceString(s, "~0", "", -1)
	s = replacestring(s, "~~", "~", -1)

endfunction s

//-----------------------------------------------------
// Returns the distance between v1 and v2.
//
function covdistance(v1 ref as Point, v2 ref as Point)

	local ret as float
	
	ret = covlength(covsub(v1, v2))

endfunction ret

//-----------------------------------------------------
// Returns the length of v.
//
function covlength(v ref as Point)

	local ret as float
	
	ret = sqrt(covdot(v, v))

endfunction ret

//-----------------------------------------------------
// Normalise the vector.
//
function covnorm(v ref as Point)

	local ret as Point
	local length as float
	
	length = v.x * v.x + v.y * v.y
	
	If length > 0
		
		length = sqrt(length)
		
		ret.x = v.x / length
		ret.y = v.y / length
		
	else // Return as it is.
		
		ret.x = v.x
		ret.y = v.y
		
	EndIf

endfunction ret

//-----------------------------------------------------
// Vector dot product.
//
function covdot(v1 ref as Point, v2 ref as Point)

	local ret as float
	
	ret = v1.x * v2.x + v1.y * v2.y

endfunction ret

//-----------------------------------------------------
// Vector dot product.
//
function covmult(v ref as Point, f as float)

	local ret as Point
	
	ret.x = v.x * f
	ret.y = v.y * f

endfunction ret

//-----------------------------------------------------
// Add two vectors.
// Note v1 and v2 are "points" created with coMakePoint.
//
function covadd(v1 ref as Point, v2 ref as Point)

	local pt as Point

	//pt = coCreatePoint(v1.x - v2.x, v1.y - v2.y)
	pt.x = v1.x + v2.x
	pt.y = v1.y + v2.y

endfunction pt

//-----------------------------------------------------
// Subtract two vectors.
// Note v1 and v2 are "points" created with coMakePoint.
//
function covsub(v1 ref as Point, v2 ref as Point)

	local pt as Point

	//pt = coCreatePoint(v1.x - v2.x, v1.y - v2.y)
	pt.x = v1.x - v2.x
	pt.y = v1.y - v2.y

endfunction pt

//-----------------------------------------------------
// Check if the panel was moved, or left the area that was original touched.
//
Function coDistSq(x as Float, y as Float, x2 as Float, y2 as Float)

	local ret as float
	
	ret = (x2 - x) * (x2 - x) + (y2 - y) * (y2 - y)
	
Endfunction ret

//-----------------------------------------------------
// Check if the panel was moved, or left the area that was original touched.
//
Function coDist(x as Float, y as Float, x2 as Float, y2 as Float)

	local ret as float
	
	ret = sqrt((x2 - x) * (x2 - x) + (y2 - y) * (y2 - y))
	
Endfunction ret

//-----------------------------------------------------
// Copy a file.
//
function coCopyFile(src as string, dest as string)

	local inId as integer
	local outId as integer
	local ret as integer
	local b as integer

	ret = false
	inId = OpenToRead(src)
	outId = OpenToWrite(dest)		

	if inId and outId

		while not FileEOF(inId)

			b = ReadInteger(inId)
			WriteInteger(outId, b)

		endwhile

		closefile(inId)
		closefile(outId)

		ret = true
		
	endif

endfunction ret

//-----------------------------------------------------
// Split a string by 'd'elim.
// Returns a string[]/
//
function coSplitString(toks ref as string[], s as string, d as string)

/*
	local tok as string 
	local pos1 as integer
	local pos2 as integer
	local dlen as integer

	pos1 = 1
	dlen = len(d)
	pos2 = FindString(s, d, 1, pos1)

	while pos2 > 0
		
		tok = mid(s, pos1, pos2 - pos1)
		toks.insert(tok)
		pos1 = pos2 + dlen
		pos2 = FindString(s, d, 1, pos1)

	endwhile

	if pos1 < len(s)

		tok = mid(s, pos1, -1)
		toks.insert(tok)

	endif
*/

	local count as integer
	local i as integer

	count = CountStringTokens2(s, d)
	
	for i = 1 to count		
		toks.insert(GetStringToken2(s, d, i))
	next
	
endfunction

//-----------------------------------------------------
// Find the paired tokens, e.g. toks = {}, find { and }.
//
function coFindPair(s as string, toks as string, idx ref as integer[])

	local c as string 
	local c1 as String
	local c2 as string
	local ln as integer
	local i as integer
	local depth as integer

	c1 = left(toks, 1)
	c2 = right(toks, 1)
	depth = 0
	idx.length = -1
	
	for i = 1 to len(s)

		c = mid(s, i, 1)
		
		if c = c1

			if depth = 0
				idx.insert(i)
			endif
			
			inc depth
			
		elseif c = c2
			
			dec depth
			
			if depth = 0

				idx.insert(i)
				exit
				
			endif
			
		endif
		
	next
	
endfunction idx

//-----------------------------------------------------
// Draw a fake sprite-based line, using a single pixel.
// If spr is non-zero, it reuses that spr, otherwise it creates a new one.
// The spr drawn is returned.
//
function coDrawFakeSprLine(sprs ref as integer[], x1 as float, y1 as float, x2 as float, y2 as float, col as integer, size as float)

	local mix as float
	local miy as float
	local mihx as float
	local mihy as float
	local mia as float
	local mil as float
	local spr as integer

	spr = CreateSprite(co.pixImg)
	sprs.insert(spr)
	
	mix = (x2 - x1)
	miy = (y2 - y1)
	mihx = mix / 2
	mihy = miy / 2
	mia = atanfull(-miy, mix)
	mil = sqrt(abs(mix * mix) + abs(miy * miy))
	SetSpriteScale(spr, mil, size)
	SetSpriteOffset(spr, mil / 2, size / 2)
	SetSpritePositionByOffset(spr, x1 + mihx, y1 + mihy)
	SetSpriteAngle(spr, mia)
	coSetSpriteColor(spr, col)
	SetSpriteVisible(spr, true)

	spr = coDrawDot(x1, y1, col, size)
	sprs.insert(spr)
	spr = coDrawDot(x2, y2, col, size)
	sprs.insert(spr)
	
endfunction

//-----------------------------------------------------
// Bresenham line algorithm
// size >= 1
//
Function coDrawSprLine(sprs ref as integer[], x0 as integer, y0 as integer, x1 as integer, y1 as integer, col as integer, size as integer)

	Local dx as integer
	Local dy as integer
	Local sx as integer
	Local sy as integer
	Local err as integer
	local e2 as integer
	local a0 as integer
	local b0 as integer
	local a1 as integer
	local b1 as integer
	local t as integer
	local baseSpr as integer
	local spr as integer

	//baseSpr = coDrawDot(x0, y0, col, size)
	baseSpr = CreateSprite(co.pixImg)
	
	dx = Abs(x1 - x0)
	dy = Abs(y1 - y0) 
	
	If x0 < x1 Then sx = 1 Else sx = -1
	If y0 < y1 Then sy = 1 Else sy = -1

	err = dx - dy
	
	While True
	
		a0 = x0 - size / 2
		b0 = y0 - size / 2
		a1 = x0 + size / 2
		b1 = y0 + size / 2

		if a0 < x0 then a0 = x0
		if b0 < y0 then b0 = y0
		if a1 > x1 then a1 = x1
		if b1 > y1 then b1 = y1
		
		//coMemSetPoint(mb, x0, y0, col)
		//coMemDrawRectInt(mb, a0, b0, abs(a1 - a0), abs(b1 - b0), col)
		spr = CloneSprite(baseSpr)
		SetSpritePositionByOffset(spr, x0, y0)
		sprs.insert(spr)
		
		If x0 = x1 And y0 = y1 Then Exit
		e2 = 2 * err
		
		If e2 > -dy
		 
			err = err - dy
			x0 = x0 + sx
			
		EndIf
		
		If e2 < dx 
		
			err = err + dx
			y0 = y0 + sy 
			
		EndIf
		
	endwhile

	deletesprite(baseSpr)
	
EndFunction

//-----------------------------------------------------
// Bresenham line algorithm
// size >= 1
//
Function coDrawDotLine(x0 as integer, y0 as integer, x1 as integer, y1 as integer, col as integer, size as integer, typ as integer)

	Local dx as integer
	Local dy as integer
	Local sx as integer
	Local sy as integer
	Local err as integer
	local e2 as integer
	local a0 as integer
	local b0 as integer
	local a1 as integer
	local b1 as integer
	local t as integer
	local s2 as integer
	
	s2 = size / 2
	
	dx = Abs(x1 - x0)
	dy = Abs(y1 - y0) 
	
	If x0 < x1 Then sx = 1 Else sx = -1
	If y0 < y1 Then sy = 1 Else sy = -1

	if typ = CO_LINE_END_CIRC or typ = CO_LINE_END_SQR

		x0 = x0 + (sx * s2)
		y0 = y0 + (sy * s2)
		x1 = x1 - (sx * s2)
		y1 = y1 - (sy * s2)

		if typ = CO_LINE_END_CIRC
			typ = CO_LINE_MID_CIRC
		elseif typ = CO_LINE_END_SQR
			typ = CO_LINE_MID_SQR
		endif

		dx = Abs(x1 - x0)
		dy = Abs(y1 - y0) 
		
		If x0 < x1 Then sx = 1 Else sx = -1
		If y0 < y1 Then sy = 1 Else sy = -1

	endif

	err = dx - dy
	
	While True
	
		if typ = CO_LINE_MID_CIRC
			DrawEllipse(x0, y0, s2, s2, col, col, true)
		elseif typ = CO_LINE_MID_SQR
			DrawBox(x0 - s2, y0 - s2, x0 - s2 + size - 1, y0 - s2 + size - 1, col, col, col, col, true)
		endif

		If x0 = x1 And y0 = y1 Then Exit
		
		e2 = 2 * err
		
		If e2 > -dy
		 
			err = err - dy
			x0 = x0 + sx
			
		EndIf
		
		If e2 < dx 
		
			err = err + dx
			y0 = y0 + sy 
			
		EndIf
		
	endwhile
	
EndFunction

//-----------------------------------------------------
// Bresenham line algorithm
// size >= 1
//
Function coCreateLinePoints(pts ref as Point[], x0 as integer, y0 as integer, x1 as integer, y1 as integer)

	Local dx as integer
	Local dy as integer
	Local sx as integer
	Local sy as integer
	Local err as integer
	local e2 as integer
	local a0 as integer
	local b0 as integer
	local a1 as integer
	local b1 as integer
	local t as integer
	local pt as Point
	
	dx = Abs(x1 - x0)
	dy = Abs(y1 - y0) 
	
	If x0 < x1 Then sx = 1 Else sx = -1
	If y0 < y1 Then sy = 1 Else sy = -1

	err = dx - dy
	
	While True
	
		pt.x = x0
		pt.y = y0
		pts.insert(pt)
		
		If x0 = x1 And y0 = y1 Then Exit
		e2 = 2 * err
		
		If e2 > -dy
		 
			err = err - dy
			x0 = x0 + sx
			
		EndIf
		
		If e2 < dx 
		
			err = err + dx
			y0 = y0 + sy 
			
		EndIf
		
	endwhile
	
EndFunction

//-----------------------------------------------------
// Draw a fake sprite-based line, using a single pixel.
// If spr is non-zero, it reuses that spr, otherwise it creates a new one.
// The spr drawn is returned.
//
function coDrawDot(x as float, y as float, col as integer, size as float)

	local spr as integer
	local idx as integer
	local i as integer
	local s as float

	idx = -1
	
	for i = 0 to co.circleSize.length
		
		if size < co.circleSize[i]
			
			idx = i
			exit
			
		endif
		
	next

	// If bigger that the biggest, then select it.
	if idx = -1
		idx = co.circleSize.length
	endif

	spr = CreateSprite(co.circleImg[idx])
	SetSpritePositionByOffset(spr, x, y)
	s = size / co.circleSize[idx]
	SetSpriteScaleByOffset(spr, s, s)
	coSetSpriteColor(spr, col)
	
endfunction spr

//-----------------------------------------------------
// Convert an image to a mb.
//
Function coMemFromImage(img as integer, mb ref as MemBlock)

	coMemDelete(mb)
	
	mb.id = CreateMemblockFromImage(img)
	mb.w = GetImageWidth(img)
	mb.h = GetImageHeight(img)
	
endfunction

//-----------------------------------------------------
// Resize the passed image (assume to be at scale 1.0) up to s.
//
Function coResizeImageUp(img as integer, s as integer)

	local srcMb as MemBlock
	local destMb as MemBlock

	if s > 1.0

		coMemFromImage(img, srcMb)
		deleteimage(img)
		coMemResizeUp(srcMb, destMb, s)
		img = coMemToImage(destMb)

	endif
	
endfunction img

//-----------------------------------------------------
// Resize the passed image (assume to be at scale s) down to 1.0.
//
Function coResizeImageDown(img as integer, s as integer)

	local srcMb as MemBlock
	local destMb as MemBlock

	if s > 1.0
		
		coMemFromImage(img, srcMb)
		deleteimage(img)
		coMemResizeDown(srcMb, destMb, s)
		img = coMemToImage(destMb)

	endif

endfunction img

//-----------------------------------------------------
// Convert an image to a mb.
//
Function coMemCreate(mb ref as MemBlock, w as integer, h as integer)

	local count as integer
	local destOff as integer
	
	coMemDelete(mb)
	
	mb.w = w
	mb.h = h
	count = w * h
	mb.id = CreateMemblock(12 + count * 4)

	// Save the dest size.
	destOff = 0
	SetMemblockInt(mb.id, destOff, mb.w)	
	destOff = destOff + 4	
	SetMemblockInt(mb.id, destOff, mb.h)	
	destOff = destOff + 4
	SetMemblockInt(mb.id, destOff, 32) // Depth.
	
endfunction

//-----------------------------------------------------
// Convert a mb to an image.
//
Function coMemToImage(mb ref as MemBlock)

	local img as integer
	
	img = CreateImageFromMemblock(mb.id)
	
endfunction img

//-----------------------------------------------------
// Convert a mb to an image.
//
Function coMemInToImage(mb ref as MemBlock, img as integer)
	
	CreateImageFromMemblock(img, mb.id)
	
endfunction

//-----------------------------------------------------
// Convert an image to a mb.
//
Function coMemResizeUp(srcMb ref as MemBlock, destMb ref as MemBlock, s as integer)

	local srcOff as integer
	local destOff as integer
	local firstDestOff as integer
	local x as integer
	local y as integer
	local xx as integer
	local yy as integer
	local pix as integer
	local size as integer

	coMemCreate(destMb, srcMb.w * s, srcMb.h * s)

	srcOff = coMemOffset(srcMb, 0, 0)
	size = destMb.w * 4 // For copying first row to subsequent roles.

	for y = 0 to srcMb.h - 1

		destOff = coMemOffset(destMb, 0, y * s)
		firstDestOff = destOff
		
		for x = 0 to srcMb.w - 1

			pix = GetMemblockInt(srcMb.id, srcOff)
			srcOff = srcOff + 4

			// Draw s pix's into the destMb.
			for xx = 1 to s
				
				SetMemblockInt(destMb.id, destOff, pix)
				destOff = destOff + 4

			next
						 
		next

		// Copy the lines down to speed it up.
		for yy = 2 to s
			
			CopyMemblock(destMb.id, destMb.id, firstDestOff, destOff, size)
			destOff = destOff + size
			
		next
		
	next

endfunction

//-----------------------------------------------------
// Convert an image to a mb.
//
Function coMemResizeDown(srcMb ref as MemBlock, destMb ref as MemBlock, s as integer)

	local srcOff as integer
	local destOff as integer
	local x as integer
	local y as integer
	local z as integer
	local pix as integer

	coMemCreate(destMb, srcMb.w / s, srcMb.h / s)

	for y = 0 to srcMb.h - 1

		srcOff = coMemOffset(srcMb, 0, y * s)
		destOff = coMemOffset(destMb, 0, y)
		
		for x = 0 to srcMb.w - 1

			pix = GetMemblockInt(srcMb.id, srcOff)
			srcOff = srcOff + (4 * s)
			SetMemblockInt(destMb.id, destOff, pix)
			destOff = destOff + 4
						 
		next
		
	next

endfunction

//-----------------------------------------------------
// Extract a rect from  an image to a mb.
//
function coMemCompare(mb1 ref as MemBlock, mb2 ref as MemBlock)
	
	local o1 as integer
	local o2 as integer
	local c1 as integer
	local c2 as integer
	local x as integer
	local y as integer
	
	if mb1.w <> mb2.w or mb1.h <> mb2.h
		exitfunction false
	endif
	
	for y = 0 to mb1.h - 1
		for x = 0 to mb1.w - 1
			
			o1 = coMemOffset(mb1, x, y)
			c1 = getMemblockInt(mb1.id, o1)
			o2 = coMemOffset(mb2, x, y)
			c2 = getMemblockInt(mb2.id, o2)

			if c1 <> c2
				exitfunction false
			endif
		next
	next
	
endfunction true

//-----------------------------------------------------
// Extract a rect from  an image to a mb.
//
Function coMemGrab(srcMb ref as MemBlock, destMb ref as MemBlock, sx as integer, sy as integer, sw as integer, sh as integer)

	local srcOff as integer
	local destOff as integer
	local size as integer
	local pix as integer
	local xx as integer
	local yy as integer

	// Nothing to grab.
	if sx >= srcMb.w or sy >= srcMb.h
		
		coMemCreate(destMb, 0, 0)
		exitfunction

	endif

	if sx < 0		
		sx = 0
	endif
	
	if sx + sw > srcMb.w
		sw = srcMb.w - sx
	endif

	if sy < 0
		sy = 0
	endif
	
	if sy + sh > srcMb.h
		sh = srcMb.h - sy
	endif
	
	coMemCreate(destMb, sw, sh)

	size = sw * 4
	destOff = coMemOffset(destMb, 0, 0)

	for yy = 0 to sh - 1

		srcOff = coMemOffset(srcMb, sx, yy + sy)
		CopyMemblock(srcMb.id, destMb.id, srcOff, destOff, size)
		destOff = destOff + size
		
	next
			
endfunction

//-----------------------------------------------------
// Extract a rect from  an image to a mb.
//
Function coMemFindGrab(mb ref as MemBlock, b ref as Line)
	
	local pix as integer
	local x as integer
	local y as integer
	
	b.x0 = -1
	b.y0 = -1
	b.x1 = -1
	b.y1 = -1
	
	for y = 0 to mb.h - 1
		
		for x = 0 to mb.w - 1
			
			pix = coMemGetPoint(mb, x, y)
				
			if GetColorAlpha(pix) = 0
				pix = 0
			endif
			
			if pix
				
				b.y0 = y
				exit
				
			endif
			
		next
		
		if b.y0 > -1
			exit
		endif
		
	next
	
	for y = mb.h - 1 to 0 step -1
		
		for x = 0 to mb.w - 1
			
			pix = coMemGetPoint(mb, x, y)
				
			if GetColorAlpha(pix) = 0
				pix = 0
			endif
			
			if pix
				
				b.y1 = y
				exit
				
			endif
			
		next
		
		if b.y1 > -1
			exit
		endif
		
	next
	
	for x = 0 to mb.w - 1
		
		for y = 0 to mb.h - 1
			
			pix = coMemGetPoint(mb, x, y)
				
			if GetColorAlpha(pix) = 0
				pix = 0
			endif
			
			if pix
				
				b.x0 = x
				exit
				
			endif
			
		next
		
		if b.x0 > -1
			exit
		endif
		
	next

	for x = mb.w - 1 to 0 step -1
		
		for y = 0 to mb.h - 1
			
			pix = coMemGetPoint(mb, x, y)
				
			if GetColorAlpha(pix) = 0
				pix = 0
			endif
			
			if pix
				
				b.x1 = x
				exit
				
			endif
			
		next
		
		if b.x1 > -1
			exit
		endif
		
	next
				
endfunction

//-----------------------------------------------------
// Draw a rect section of the memblock.
//
Function coMemClear(mb ref as MemBlock)

	coMemDrawRectInt(mb, 0, 0, mb.w, mb.h, 0)
	
endfunction

//-----------------------------------------------------
// Paste srcMb to destMb at x,y
//
Function coMemPaste(srcMb ref as MemBlock, destMb ref as MemBlock, dx as integer, dy as integer)

	local srcOff as integer
	local destOff as integer
	local xx as integer
	local yy as integer
	local pix as integer
	local size as integer
	local sx as integer
	local sy as integer
	local sw as integer
	local sh as integer

	if dx >= destMb.w or dy >= destMb.h
		exitfunction
	endif

	sx = 0
	sy = 0
	sw = srcMb.w
	sh = srcMb.h 
	
	if dx < 0
		
		sx = -dx
		dx = 0
		sw = sw + dx
		
	endif

	if dy < 0
		
		sy = -dy
		dy = 0
		sh = sh + dy
		
	endif
		
	srcOff = coMemOffset(srcMb, sx, sy)
	size = (sw * 4)
	
	for yy = 0 to sh - 1

		destOff = coMemOffset(destMb, dx, dy + yy)
		CopyMemblock(srcMb.id, destMb.id, srcOff, destOff, size)
		srcOff = srcOff + size
		
	next
		
endfunction

//-----------------------------------------------------
// Paste srcMb to destMb at x,y, but not Col
// SLower.
//
Function coMemPasteSpecial(srcMb ref as MemBlock, destMb ref as MemBlock, dx as integer, dy as integer, notCol as integer)

	local srcOff as integer
	local destOff as integer
	local xx as integer
	local yy as integer
	local pix as integer
	local sx as integer
	local sy as integer
	local sw as integer
	local sh as integer

	if dx >= destMb.w or dy >= destMb.h
		exitfunction
	endif

	sx = 0
	sy = 0
	sw = srcMb.w
	sh = srcMb.h 
	
	if dx < 0
		
		sx = -dx
		dx = 0
		sw = sw + dx
		
	endif

	if dy < 0
		
		sy = -dy
		dy = 0
		sh = sh + dy
		
	endif
	
	srcOff = coMemOffset(srcMb, sx, sy)

	for yy = 0 to sh - 1

		destOff = coMemOffset(destMb, dx, dy + yy)
		
		for xx = 0 to sw - 1

			pix = GetMemblockInt(srcMb.id, srcOff)
			srcOff = srcOff + 4

			if pix <> notCol
				SetMemblockInt(destMb.id, destOff, pix)
			endif
			
			destOff = destOff + 4
			 
		next
		
	next
		
endfunction

//-----------------------------------------------------
// Unpaste srcMb from destMb at x,y
//
Function coMemUnpaste(srcMb ref as MemBlock, destMb ref as MemBlock, dx as integer, dy as integer, col as integer)

	local srcOff as integer
	local destOff as integer
	local xx as integer
	local yy as integer
	local pix as integer
	local sx as integer
	local sy as integer
	local sw as integer
	local sh as integer

	if dx >= destMb.w or dy >= destMb.h
		exitfunction
	endif

	sx = 0
	sy = 0
	sw = srcMb.w
	sh = srcMb.h 
	
	if dx < 0
		
		sx = -dx
		dx = 0
		sw = sw + dx
		
	endif

	if dy < 0
		
		sy = -dy
		dy = 0
		sh = sh + dy
		
	endif
	
	srcOff = coMemOffset(srcMb, sx, sy)

	for yy = 0 to sh - 1

		destOff = coMemOffset(destMb, dx, dy + yy)
		
		for xx = 0 to sw - 1

			pix = GetMemblockInt(srcMb.id, srcOff)
			srcOff = srcOff + 4

			if pix = col
				SetMemblockInt(destMb.id, destOff, 0)
			endif
			
			destOff = destOff + 4
			 
		next
		
	next
		
endfunction

//-----------------------------------------------------
// Paste srcMb to destMb at x,y, but not Col
// SLower.
//
Function coMemReplaceColor(mb ref as MemBlock, fromCol as integer, toCol as integer)

	local off as integer
	local pix as integer
	local size as integer
	local i as integer

	size = coMemSize(mb)
	off = coMemOffset(mb, 0, 0)

	for i = off to size step 4
		
		pix = GetMemblockInt(mb.id, i)

		if pix = fromCol
			SetMemblockInt(mb.id, i, toCol)
		endif

	next
		
endfunction

//-----------------------------------------------------
// Bresenham line algorithm
// size >= 1
//
Function coMemDrawLine(mb ref as MemBlock, x0 as float, y0 as float, x1 as float, y1 as float, col as integer, size as integer)

	local r as integer
	local g as integer
	local b as integer
	local s as float
	local ang as float
	local aa as float
	local bb as float
	local st as float

	st = 0.05

	// up=0, right=90, down=180, left=270
	ang = atanfull(x1 - x0, y1 - y0)

	aa = ang + 180
	bb = aa
			
	for ang = 0.0 to 180.0 step st
		
		coMemDrawLineOne(mb, x0 + cos(aa) * s, y0 + sin(aa) * s, x1 + cos(bb) * s, y1 + sin(bb) * s, col)
		aa = aa - st
		bb = bb + st

	next

endfunction

//-----------------------------------------------------
// Bresenham line algorithm
// size >= 1
//
Function coMemDrawLineOne(mb ref as MemBlock, x0 as integer, y0 as integer, x1 as integer, y1 as integer, col as integer)

	Local dx as integer
	Local dy as integer
	Local sx as integer
	Local sy as integer
	Local err as integer
	local e2 as integer
	local t as integer

	dx = Abs(x1 - x0)
	dy = Abs(y1 - y0) 
	
	If x0 < x1 Then sx = 1 Else sx = -1
	If y0 < y1 Then sy = 1 Else sy = -1

	err = dx - dy
	
	While True
			
		coMemSetPoint(mb, x0, y0, col)
		
		If x0 = x1 And y0 = y1 Then Exit
		e2 = 2 * err
		
		If e2 > -dy
		 
			err = err - dy
			x0 = x0 + sx
			
		EndIf
		
		If e2 < dx 
		
			err = err + dx
			y0 = y0 + sy 
			
		EndIf
		
	endwhile
	
EndFunction

//-----------------------------------------------------
// Draw a rect section of the memblock.
// size<=0 for filled, otherwise rect thickness is size > 1
//
Function coMemDrawRect(mb ref as MemBlock, x as float, y as float, w as float, h as float, col as integer, size as integer)

	local off as integer
	local xx as float
	local yy as float

	if size > 0 and size < w / 2 and size < h / 2

		for yy = 0 to h - 1

			off = coMemOffset(mb, x, y + yy)

			if yy < size or yy > h - size
				
				for xx = 0 to w - 1
						
					SetMemblockInt(mb.id, off, col)
					off = off + 4
					 
				next

			else

				for xx = 0 to w - 1

					if xx < size or xx > w - size						
						SetMemblockInt(mb.id, off, col)
					endif

					off = off + 4
					
				next
				
			endif
			
		next

	else

		coMemDrawRectInt(mb, x, y, w, h, col)
		
	endif
	
endfunction

//-----------------------------------------------------
// Draw a rect section of the memblock.
// size<=0 for filled, otherwise size > 1
//
Function coMemDrawRectInt(mb ref as MemBlock, x as float, y as float, w as float, h as float, col as integer)

	local off as integer
	local topOff as integer
	local size as integer
	local xx as float
	local yy as float

	size = w * 4
		
	for yy = 0 to h - 1

		off = coMemOffset(mb, x, y + yy)

		if yy = 0

			// Keep as the source offset for the copy.
			topOff = off
			
			// Do one pass for the first row, then...
			for xx = 0 to w - 1

				SetMemblockInt(mb.id, off, col)
				off = off + 4
				 
			next

		else

			// Copy the row to all the others for speed.
			CopyMemblock(mb.id, mb.id, topOff, off, size)

		endif
		
	next
	
endfunction

//-----------------------------------------------------
// Draw a line.
// x,y = top-left
//
function coDrawLine(x0 as float, y0 as float, x1 as float, y1 as float, col as integer, size as integer)

	local r as integer
	local g as integer
	local b as integer
	local s as float
	local ang as float
	local aa as float
	local bb as float
	local st as float
	
	s = size / 2
	r = GetColorRed(col)
	g = GetColorGreen(col)
	b = GetColorBlue(col)
	st = 0.05

	// up=0, right=90, down=180, left=270
	ang = atanfull(x1 - x0, y1 - y0)

	aa = ang + 180
	bb = aa
			
	for ang = 0.0 to 180.0 step st
		
		drawline(x0 + cos(aa) * s, y0 + sin(aa) * s, x1 + cos(bb) * s, y1 + sin(bb) * s, r, g, b)
		aa = aa - st
		bb = bb + st

	next

endfunction

//-----------------------------------------------------
// Draw a rect like the DrawRect function.
// x,y = top-left
//
function coDrawRect(x as float, y as float, w as float, h as float, col as integer, size as integer)

	local i as integer

	for i = 0 to size

		DrawBox(x, y, x + w - 1, y + h - 1, col, col, col, col, false)
		inc x
		inc y
		w = w - 2
		h = h - 2

		if w < 0 or h < 0
			exit
		endif
		
	next

endfunction

//-----------------------------------------------------
// Draw an elipse like the DrawElispse function, but using lines.
// x,y = top-left
//
function coDrawEllipse(x as float, y as float, w as float, h as float, col as integer, size as integer)

	local w2 as float
	local h2 as float
	local a as float
	local xx as float
	local yy as float
	local r as integer
	local g as integer
	local b as integer
	local st as float
	local i as integer
	
	r = GetColorRed(col)
	g = GetColorGreen(col)
	b = GetColorBlue(col)
	st = 1.0

	for i = 0 to size step st

		w2 = w / 2
		h2 = h / 2
			
		for a = -90.0 to 270.0 step 0.1
					
			xx = x + w2 + cos(a) * w2
			yy = y + h2 + sin(a) * h2
			drawline(xx, yy, xx, yy, r, g, b)

		next
				
		x = x + st
		y = y + st
		w = w - st * 2 
		h = h - st * 2

		if w < 0 or h < 0
			exit
		endif
		
	next

endfunction

//-----------------------------------------------------
// Draw a mem oval.
// size<=0 to fill, otherwise size > 1
//
function coMemDrawOval(mb ref as MemBlock, x as integer, y as integer, w as integer, h as integer, col as integer, size as integer)

	local w2 as float
	local h2 as float
	local wr as float
	local hr as float
	local a as float
	local b as float
	local xx as float
	local yy as float
	local x0 as float
	local x1 as float
	local off as integer
	
	w2 = w / 2
	h2 = h / 2
	wr = w2
	hr = h2

	// Now we need to fill a centre blank.
	if size > 1 and size < w2 and size < h2

		while size > 0
			
			for a = -90.0 to 270.0 step 0.1
						
				xx = x + w2 + cos(a) * wr
				yy = y + h2 + sin(a) * hr

				coMemSetPoint(mb, xx, yy, col)

			next

			wr = wr - 1
			hr = hr - 1
			size = size - 1

		endwhile

	else

		b = -90.0
		
		// Draw a single line oval.
		for a = -90.0 to 90 step 0.1

			x0 = x + w2 + cos(b) * wr
			x1 = x + w2 + cos(a) * wr
			yy = y + h2 + sin(a) * hr

			coMemSetPoint(mb, x0, yy, co.red[5])
			coMemSetPoint(mb, x1, yy, co.blue[5])

			off = coMemOffset(mb, x0, yy)
			
			for xx = x0 to x1

				//coMemSetPoint(mb, xx, yy, col)
				SetMemblockInt(mb.id, off, col)
				off = off + 4

			next

			b = b - 0.1
			
		next

	endif
		
endfunction

//-----------------------------------------------------
// Set a point.
//
Function coMemSetPoint(mb ref as MemBlock, x as integer, y as integer, col as integer)

	local off as integer
	
	off = coMemOffset(mb, x, y)

	//if off > 0 and off < mb.size
		SetMemblockInt(mb.id, off, col)
	//endif
		
endfunction

//-----------------------------------------------------
// Get a point.
//
Function coMemGetPoint(mb ref as MemBlock, x as integer, y as integer)

	local off as integer
	local col as integer
	
	off = coMemOffset(mb, x, y)

	if x < 0 or y < 0 or x > mb.w - 1 or y > mb.h - 1
		exitfunction 0
	endif
	
	col = getMemblockInt(mb.id, off)
		
endfunction col

//-----------------------------------------------------
// Get the offset of x and y into a memblock.
//
function coMemOffset(mb ref as MemBlock, x as integer, y as integer)

	local off as integer
	
	off = 12 + y * mb.w * 4 + x * 4

endfunction off

//-----------------------------------------------------
// Get the size of the memblock, excluding the first 3 bytes.
//
function coMemSize(mb ref as MemBlock)

	local size as integer
	
	size = GetMemblockSize(mb.id) - 12

endfunction size

//-----------------------------------------------------
// Paste srcMb to destMb at x,y
//
Function coMemDelete(mb ref as MemBlock)

	if mb.id
		
		DeleteMemblock(mb.id)
		mb.id = 0
		
	endif

	mb.w = 0
	mb.h = 0

endfunction

//-----------------------------------------------------
// Create a flood fill.
//
Function coMemInitFill(mb ref as MemBlock, ff ref as FloodFill)

	ff.x0 = 0
	ff.y0 = 0
	ff.x1 = mb.w - 1
	ff.y1 = mb.h - 1
	ff.pixCount = 0
	ff.stack.length = -1
	ff.col = co.black
	
Endfunction

//-----------------------------------------------------
// Do a flood fill.
//	
function coMemDrawFill(mb ref as MemBlock, ff ref as FloodFill, x as integer, y as integer)

	//local ff as FloodFill		
	Local l as integer
	Local x1 as integer
	Local x2 as integer
	Local dy as integer
	Local ov as integer	//  old pixel value
	local s as Segment
	Local skip as integer
	
	//coMemInitFill(mb, ff)
	
	ov = coMemGetPoint(mb, x, y)

	//If coMemSameColor(ov, nv) Or x < ff.x0 Or x > ff.x1 Or y < ff.y0 Or y > ff.y1
	If ov = ff.col Or x < ff.x0 Or x > ff.x1 Or y < ff.y0 Or y > ff.y1
		exitfunction
	endif

	coMemPushStack(ff, y, x, x, 1)	
	coMemPushStack(ff, y + 1, x, x, -1)
	
	While ff.stack.length > -1

		coMemPopStack(ff, s)
		dy = s.dy
		y = s.y + dy
		x1 = s.xl
		x2 = s.xr
		
		x = x1
		
		//While x >= ff.x0 And coMemSameColor(coMemGetPoint(mb, x, y), ov)
		While x >= ff.x0 And coMemGetPoint(mb, x, y) = ov
		
			coMemSetPoint(mb, x, y, ff.col)
			inc ff.pixCount
			dec x
			
		endwhile
		
		skip = False
		
		If x >= x1 Then skip = True
		
		If Not skip
		
			l = x + 1
			If l < x1 Then coMemPushStack(ff, y, l, x1 - 1, -dy)
			x = x1 + 1
			
		EndIf
		
		Repeat
		
			If Not skip
			
				//While x <= ff.x1 And coMemSameColor(coMemGetPoint(mb, x, y), ov)
				While x <= ff.x1 And coMemGetPoint(mb, x, y) = ov
				
					coMemSetPoint(mb, x, y, ff.col)
					inc ff.pixCount
					inc x
					
				endwhile
				
				coMemPushStack(ff, y, l, x - 1, dy)
				
				If x > x2 + 1 Then coMemPushStack(ff, y, x2 + 1, x - 1, -dy)
				
			EndIf
			
			skip = False
			
			inc x
			
			//While x <= x2 And Not coMemSameColor(coMemGetPoint(mb, x, y), ov)
			While x <= x2 And coMemGetPoint(mb, x, y) <> ov
				inc x
			endwhile
			
			l = x
			
		Until x > x2
		
	endwhile

endfunction

//-----------------------------------------------------
// #define PUSH(Y, XL, XR, DY)	/* push New segment on stack */ \
// If (sp<stack+MAX_STACK && Y+(DY)>=win->y0 && Y+(DY)<=win->y1) \
// {sp->y = Y; sp->xl = XL; sp->xr = XR; sp->dy = DY; sp++;}
//
function coMemPushStack(ff ref as FloodFill, Y as integer, XL as integer, XR as integer, DY as integer)	//  push New segment on stack

	local s as Segment
	
	If Y + DY >= ff.y0 And Y + DY <= ff.y1

		s.y = Y
		s.xl = XL
		s.xr = XR
		s.dy = DY

		if ff.stack.length > -1
			ff.stack.insert(s, 0)
		else
			ff.stack.insert(s) // Append.
		endif
		
		//inc ff.sp
		
	EndIf
	
Endfunction

//-----------------------------------------------------
//
function coMemPopStack(ff ref as FloodFill, s ref as Segment)

	if ff.stack.length > -1
		
		s.y = ff.stack[0].Y
		s.xl = ff.stack[0].XL
		s.xr = ff.stack[0].XR
		s.dy = ff.stack[0].DY

		ff.stack.remove(0)

	endif
	
Endfunction

//-----------------------------------------------------
//
function coMemSameColor(col1 as integer, col2 as integer)

	local ret as integer
	
	if col1 = col2
		ret = true
	else
		ret = false
	endif
	
/*
	Local a1 = (col1 Shr 24) & $ff
	Local r1 = (col1 Shr 16) & $ff
	Local g1 = (col1 Shr 8) & $ff
	Local b1 = col1 & $ff
	Local a2 = (col2 Shr 24) & $ff
	Local r2 = (col2 Shr 16) & $ff
	Local g2 = (col2 Shr 8) & $ff
	Local b2 = col2 & $ff

	// Print "r1=" + r1 + ", r2=" + r2 + ", g1=" + g1 + ", g2=" + g2 + ", b1=" + b1 + ", b2=" + b2 + ", a1=" + a1 + ", a2=" + a2
	Return r1 = r2 And g1 = g2 And b1 = b2 And a1 = a2
*/
	
Endfunction ret	

//-----------------------------------------------------
// Flip a memblock image.
//
function coMemFlipX(mb ref as MemBlock, x as integer, y as integer, w as integer, h as integer)

	local off as integer
	local off1 as integer
	local off2 as integer
	local xx as integer
	local yy as integer
	local a as integer
	local b as integer
	
	if x >= 0 and x < mb.w and y >= 0 and y < mb.h
		
		for yy = 0 to h / 2 - 1

			// Make sure we don't go off the end.
			if y + yy < h and y + h - 1 - yy < h
				
				off1 = coMemOffset(mb, x, y + yy)
				off2 = coMemOffset(mb, x, y + h - 1 - yy)

				for xx = 0 to w - 1

					if x + xx < w

						a = GetMemblockint(mb.id, off2)
						b = GetMemblockint(mb.id, off1)
						SetMemblockInt(mb.id, off2, b)
						SetMemblockInt(mb.id, off1, a)

						off1 = off1 + 4
						off2 = off2 + 4

					else

						exit

					endif
					
				next

			else

				exit
				
			endif
			
		next

	endif
	
endfunction

//-----------------------------------------------------
// Flip a memblock image.
//
function coMemFlipY(mb ref as MemBlock, x as integer, y as integer, w as integer, h as integer)

	local off as integer
	local off1 as integer
	local off2 as integer
	local xx as integer
	local yy as integer
	local a as integer
	local b as integer
	local size as integer

	size = w * 4
	
	if x >= 0 and x < mb.w and y >= 0 and y < mb.h
		
		//for yy = 0 to h / 2 - 1
		for xx = 0 to w / 2 - 1

			// Make sure we don't go off the end.
			//if y + yy < h and y + h - 1 - yy < h
			if x + xx < w and x + w - 1 - xx < w
				
				//off1 = coMemOffset(mb, x, y + yy)
				//off2 = coMemOffset(mb, x, y + h - 1 - yy)
				off1 = coMemOffset(mb, x + xx, y)
				off2 = coMemOffset(mb, x + w - 1 - xx, y)

				//for xx = 0 to w - 1
				for yy = 0 to h - 1

					//if x + xx < w
					if y + yy < h

						a = GetMemblockint(mb.id, off2)
						b = GetMemblockint(mb.id, off1)
						SetMemblockInt(mb.id, off2, b)
						SetMemblockInt(mb.id, off1, a)

						off1 = off1 + size
						off2 = off2 + size

					else

						exit

					endif
					
				next

			else

				exit
				
			endif
			
		next

	endif
	
endfunction

//-----------------------------------------------------
// Rotate a memblock left.
//
function coMemRotLeft(mb ref as MemBlock, x as integer, y as integer, w as integer, h as integer)

//TODO

	local off as integer
	local off1 as integer
	local off2 as integer
	local xx as integer
	local yy as integer
	local a as integer
	local b as integer
	
	if x >= 0 and x < mb.w and y >= 0 and y < mb.h
		
		for yy = 0 to h / 2 - 1

			// Make sure we don't go off the end.
			if y + yy < h and y + h - 1 - yy < h
				
				off1 = coMemOffset(mb, x, y + yy)
				off2 = coMemOffset(mb, x, y + h - 1 - yy)

				for xx = 0 to w - 1

					if x + xx < w

						a = GetMemblockint(mb.id, off2)
						b = GetMemblockint(mb.id, off1)
						SetMemblockInt(mb.id, off2, b)
						SetMemblockInt(mb.id, off1, a)

						off1 = off1 + 4
						off2 = off2 + 4

					else

						exit

					endif
					
				next

			else

				exit
				
			endif
			
		next

	endif
	
endfunction

//-----------------------------------------------------
// Rotate a memblock left.
//
function coMemRotRight(mb ref as MemBlock, x as integer, y as integer, w as integer, h as integer)

//TODO

	local off as integer
	local off1 as integer
	local off2 as integer
	local xx as integer
	local yy as integer
	local a as integer
	local b as integer
	
	if x >= 0 and x < mb.w and y >= 0 and y < mb.h
		
		for yy = 0 to h / 2 - 1

			// Make sure we don't go off the end.
			if y + yy < h and y + h - 1 - yy < h
				
				off1 = coMemOffset(mb, x, y + yy)
				off2 = coMemOffset(mb, x, y + h - 1 - yy)

				for xx = 0 to w - 1

					if x + xx < w

						a = GetMemblockint(mb.id, off2)
						b = GetMemblockint(mb.id, off1)
						SetMemblockInt(mb.id, off2, b)
						SetMemblockInt(mb.id, off1, a)

						off1 = off1 + 4
						off2 = off2 + 4

					else

						exit

					endif
					
				next

			else

				exit
				
			endif
			
		next

	endif
	
endfunction

//-----------------------------------------------------
// Flip an image.
//
function coFlipImageX(img as integer)

	local mb as MemBlock
	local ret as integer
	
	coMemFromImage(img, mb)
	coMemFlipX(mb, 0, 0, mb.w, mb.h)
	ret = coMemToImage(mb)
	coMemDelete(mb)

endfunction ret

//-----------------------------------------------------
// Flip an image.
//
function coFlipImageY(img as integer)

	local mb as MemBlock
	local ret as integer
	
	coMemFromImage(img, mb)
	coMemFlipY(mb, 0, 0, mb.w, mb.h)
	ret = coMemToImage(mb)
	coMemDelete(mb)

endfunction ret

//-----------------------------------------------------
// Rot an image left.
//
function coRotImageLeft(img as integer)

	local mb as MemBlock
	local ret as integer
	
	coMemFromImage(img, mb)
	coMemRotLeft(mb, 0, 0, mb.w, mb.h)
	ret = coMemToImage(mb)
	coMemDelete(mb)

endfunction ret

//-----------------------------------------------------
// Rot an image right.
//
function coRotImageRight(img as integer)

	local mb as MemBlock
	local ret as integer
	
	coMemFromImage(img, mb)
	coMemRotRight(mb, 0, 0, mb.w, mb.h)
	ret = coMemToImage(mb)
	coMemDelete(mb)

endfunction ret

//-----------------------------------------------------
// Get the bounds of a rotated spr.
//
function coGetRotSprBounds(rotSpr as integer, bounds ref as Line)

	local sx as float
	local sy as float
	local sx0 as float
	local sy0 as float
	local sx1 as float
	local sy1 as float	
	local dx as float
	local dy as float
	local r as float
	local xx as float
	local yy as float
	local ang as float

	sx = GetSpriteXByOffset(rotSpr)
	sy = GetSpriteyByOffset(rotSpr)
	sx0 = getspritex(rotSpr)
	sy0 = getspritey(rotSpr)
	sx1 = sx0 + GetSpriteWidth(rotSpr) - 1
	sy1 = sy0 + GetSpriteHeight(rotSpr) - 1
	
	dx = sx - sx0
	dy = sy - sy0
	r = sqrt(abs(dx * dx) + abs(dy * dy))
	
	// Top-left
	ang = atanfull(-dy, dx)
	ang = ang + GetSpriteAngle(rotSpr)
	xx = sx + cos(ang) * r
	yy = sy + sin(ang) * r
	//spr = CreateSprite(co.pixImg)
	//SetSpriteScaleByOffset(spr, 20, 20)
	//coSetSpriteColor(spr, co.red[5])
	//SetSpriteDepth(spr, FRONT_DEPTH)
	//SetSpritePositionByOffset(spr, xx, yy)

	if xx < sx0
		sx0 = xx
	elseif xx > sx1
		sx1 = xx
	endif
	
	if yy < sy0
		sy0 = yy
	elseif yy > sy1
		sy1 = yy
	endif
	
	// Bottom-left
	ang = atanfull(dy, dx)
	ang = ang + GetSpriteAngle(rotSpr)
	xx = sx + cos(ang) * r
	yy = sy + sin(ang) * r
	//spr = CreateSprite(co.pixImg)
	//SetSpriteScaleByOffset(spr, 20, 20)
	//coSetSpriteColor(spr, co.red[5])
	//SetSpriteDepth(spr, FRONT_DEPTH)
	//SetSpritePositionByOffset(spr, xx, yy)

	if xx < sx0
		sx0 = xx
	elseif xx > sx1
		sx1 = xx
	endif
	
	if yy < sy0
		sy0 = yy
	elseif yy > sy1
		sy1 = yy
	endif

	// Top-right
	ang = atanfull(-dy, -dx)
	ang = ang + GetSpriteAngle(rotSpr)
	xx = sx + cos(ang) * r
	yy = sy + sin(ang) * r
	//spr = CreateSprite(co.pixImg)
	//SetSpriteScaleByOffset(spr, 20, 20)
	//coSetSpriteColor(spr, co.red[5])
	//SetSpriteDepth(spr, FRONT_DEPTH)
	//SetSpritePositionByOffset(spr, xx, yy)

	if xx < sx0
		sx0 = xx
	elseif xx > sx1
		sx1 = xx
	endif
	
	if yy < sy0
		sy0 = yy
	elseif yy > sy1
		sy1 = yy
	endif

	// Bottom-right
	ang = atanfull(dy, -dx)
	ang = ang + GetSpriteAngle(rotSpr)
	xx = sx + cos(ang) * r
	yy = sy + sin(ang) * r
	//spr = CreateSprite(co.pixImg)
	//SetSpriteScaleByOffset(spr, 20, 20)
	//coSetSpriteColor(spr, co.red[5])
	//SetSpriteDepth(spr, FRONT_DEPTH)
	//SetSpritePositionByOffset(spr, xx, yy)

	if xx < sx0
		sx0 = xx
	elseif xx > sx1
		sx1 = xx
	endif
	
	if yy < sy0
		sy0 = yy
	elseif yy > sy1
		sy1 = yy
	endif

	bounds.x0 = sx0
	bounds.y0 = sy0
	bounds.x1 = sx1
	bounds.y1 = sy1
	
endfunction

//-----------------------------------------------------
// Get a unique name from the passed name and suffix.
//
function coGetUniqueName(nu ref as NameUnique)

	local pos as integer
	local s as string 
	local t as string 

	s = nu.name	
	pos = FindStringReverse(s, "-")

	if pos > 0
		
		t = mid(s, pos + 1, -1)

		if coIsValidNbr(t, false, false)

			s = mid(s, 1, pos - 1)
			nu.suffix = val(t)
			
		endif

	endif
	
	inc nu.suffix
	nu.name = s + "-" + str(nu.suffix)
	nu.unique = false

endfunction

//-----------------------------------------------------
// Resize an img to a specific scale.
// ms = maxsize
//
function coResizeImage(img as integer, ms as float)

	local w as float
	local h as float
	local s as float
	
	w = GetImageWidth(img)
	h = GetImageHeight(img)
	s = 1.0

	if h > w
		if h > ms
			s = ms / h
		endif
	else //if w > h
		if w > ms
			s = ms / w
		endif
	endif

	ResizeImage(img, w * s, h * s)

endfunction s

//-----------------------------------------------------
// Resize an img to a specific scale.
// ms = maxsize
//
function coResizeSprite(spr as integer, ms as float)

	local w as float
	local h as float
	local s as float

	w = GetSpriteWidth(spr)
	h = GetSpriteHeight(spr)
	s = 1.0

	if h > w
		if h > ms
			s = ms / h
		endif
	else //if w > h
		if w > ms
			s = ms / w
		endif
	endif

	SetSpriteScaleByOffset(spr, s, s)

endfunction s

//-----------------------------------------------------
// Get the start time for the dateScale.
//
function coGetStartTime(time as integer, dateScale as integer)
	
	local d as integer
	local dow as integer

	if time = 0
		time = coCurrentTime()
	endif
		
	if dateScale <= DATE_SCALE_WEEK7
	
		dow = coGetDayOfWeek(time)
		
		if dateScale = DATE_SCALE_WEEK5
			
			if coGetDayOfWeek(time) = 0 // If we are on sunday, go to the monday, otherwise go backwards.
				
				time = time + DAY_SECS
			
			else
				
				while dow > 1 // 1 = mon.
					
					time = time - DAY_SECS
					dow = coGetDayOfWeek(time)
					
				endwhile
				
			endif
			
		elseif dateScale = DATE_SCALE_WEEK7
			
			while dow > 0
				
				time = time - DAY_SECS
				dow = coGetDayOfWeek(time)
				
			endwhile
			
		endif
			
	else // Set all month ones to first of the month.

		d = GetDaysFromUnix(time)
		time = time - DAY_SECS * (d - 1)

	endif
	
	// Reset to midnight (start of the day).
	time = GetUnixFromDate(GetYearFromUnix(time), GetMonthFromUnix(time), GetDaysFromUnix(time), 0, 0, 0)
	
endfunction time

//-----------------------------------------------------
// Get the end time for the passed dateScale starting at time.
// Note end time is exclusive, i.e. at the same time on the next day.
//
function coGetEndTime(time as integer, dateScale as integer)
	
	local y as integer
	local mon as integer
	local d as integer
	local count as integer
	local i as integer
	
	if dateScale = DATE_SCALE_WEEK5

		time = time + DAY_SECS * 5
				
	elseif dateScale = DATE_SCALE_WEEK7

		time = time + DAY_SECS * 7
		
	else 
		
		y = GetYearFromUnix(time)
		mon = GetMonthFromUnix(time)
		d = GetDaysFromUnix(time)
		
		if dateScale = DATE_SCALE_1MONTH
			count = 1
		elseif dateScale = DATE_SCALE_3MONTHS
			count = 3
		elseif dateScale = DATE_SCALE_6MONTHS
			count = 6
		elseif dateScale = DATE_SCALE_12MONTHS
			count = 12
		endif
		
		for i = 1 to count
			
			time = time + DAY_SECS * (coMonthDays(mon, y) - d + 1)
			
			inc mon
			
			if mon > 12
				
				mon = 1
				inc y
				
			endif
			
			d = 1
			
		next
		
	endif
		
endfunction time

//-----------------------------------------------------
// Get the unix date, but convert for timezone.
//
function coGetUnixFromDate(yy as integer, mm as integer, dd as integer, h as integer, m as integer, s as integer, tz as integer)
	
	local time as integer
	
	time = GetUnixFromDate(yy, mm, dd, h, m, s)
	//log("time=" + coFormatDateTime(time, "{YYYY}-{MM}-{DD} {HH}:{mm}:{ss}"))
	//time = coAdjustTimeZone(time, tz)
	//log("adjusted time=" + coFormatDateTime(time, "{YYYY}-{MM}-{DD} {HH}:{mm}:{ss}"))
	
endfunction time

//-----------------------------------------------------
// Parsed the passed date.
// ret will contain yy, mm, dd
//
function coParseDate(s as string, d ref as Date)
	
	local time as integer
	local count as integer
	local delim as string
	local pos as integer
	
	d.y = 0
	d.m = 0
	d.d = 0
	
	if s = ""
		exitfunction
	endif
	
	pos = findstring(s, " ")
	
	if pos
		s = mid(s, 1, pos - 1)
	endif
	
	delim = "-"
	count = CountStringTokens2(s, delim)
	
	if count = 1 // Has date and time.

		delim = "/"
		count = CountStringTokens2(s, delim)
		
		if count = 1
						
			if len(s) > 4
				
				s = left(s, 4) + delim + mid(s, 5, -1)
				
				if len(s) > 7				
					s = left(s, 7) + delim + mid(s, 8, -1)
				endif
				
			endif
			
		endif
		
	endif
	
	if count > 0
		d.y = val(GetStringToken2(s, delim, 1))
	else
		d.y = GetYearFromUnix(GetUnixTime())
	endif

	if count > 1
		d.m = val(GetStringToken2(s, delim, 2))
	else
		d.m = 1
	endif

	if count > 2
		d.d = val(GetStringToken2(s, delim, 3))
	else
		d.d = 1
	endif
	
endfunction

//-----------------------------------------------------
// Parsed the passed time in the format hh:mm:ss.
// It will find a :, go back until it hits the start of the string or a space.
// ret will contain hh, mm, ss.
//
function coParseTime(s as string, t ref as Time)
	
	local time as integer
	local count as integer
	local delim as string
	local pos as integer
	local c as string
	
	t.h = 0
	t.m = 0
	t.s = 0
	
	if s = ""
		exitfunction
	endif
	
	pos = findstring(s, " ") // Eliminate date.
	
	if pos
		s = mid(s, pos + 1, -1)
	endif
	
	delim = ":"
	count = CountStringTokens2(s, delim)
	
	if count = 1
		
		if len(s) > 2
			
			s = left(s, 2) + delim + mid(s, 3, -1)
			
			if len(s) > 5		
				s = left(s, 5) + delim + mid(s, 6, -1)
			endif
			
		endif
		
	endif
	
	if count > 0
		t.h = val(GetStringToken2(s, delim, 1))
	else
		t.h = GethoursFromUnix(GetUnixTime())
	endif

	if count > 1
		t.m =val(GetStringToken2(s, delim, 2))
	else
		t.m = 0
	endif

	if count > 2
		t.s = val(GetStringToken2(s, delim, 3))
	else
		t.s = 0
	endif
	
endfunction

//-----------------------------------------------------
// Parsed the passed duration in the format d[d] h[h] m[m] s[s],
// where [d], [h], [m] and [d] are actual optional letters.
// It will split on ' ' (space).
// dur will contain hh, mm, ss.
// Returns the duration in seconds.
//
function coParseDuration(s as string, dur ref as Duration)
	
	local count as integer
	local delim as string
	local tok as string
	local v as integer
	local i as integer
	local c as string
	
	if s = ""
		exitfunction 0
	endif
	
	dur.d = 0
	dur.h = 0
	dur.m = 0
	dur.s = 0
	delim = " "
	count = CountStringTokens2(s, delim)
	
	for i = 1 to count
				
		tok = GetStringToken2(s, delim, i)
		c = lower(right(tok, 1))
		
		if findstring("0123456789", c)
			
			v = val(tok)

			if i = 1
				if count > 3
					dur.d = v
				else
					dur.h = v
				endif
			elseif i = 2
				if count > 3
					dur.h = v
				else
					dur.m = v
				endif
			elseif i = 3
				if count > 3
					dur.m = v
				else
					dur.s = v
				endif
			elseif i = 4
				dur.s = v
			endif
			
		else
			
			v = val(mid(tok, 1, len(tok) - 1))
			
			if c = "d"
				dur.d = v
			elseif c = "h"
				dur.h = v
			elseif c = "m"
				dur.m = v
			elseif c = "s"
				dur.s = v
			endif
			
		endif
		
	next
	
	v = dur.d * DAY_SECS + dur.h * HOUR_SECS + dur.m * 60 + dur.s
	
endfunction v

//-----------------------------------------------------
// Get the current local date/time as a unix time.
//
function coCurrentTime()
	
	local s as string
	local d as Date
	local t as Time
	local u as integer
	
	s = getcurrentdate() + " " + GetCurrentTime()
	coParseDate(s, d)
	coParseTime(s, t)
	u = GetUnixFromDate(d.y, d.m, d.d, t.h, t.m, t.s)

endfunction u

//-----------------------------------------------------
// Get the date for the passed time.
//
function coGetDate(time as integer, d ref as Date)
	
	if time < -WRAP_SECS
		time = time + WRAP_SECS
	endif

	d.y = GetYearFromUnix(time)
	d.m = GetMonthFromUnix(time)
	d.d = GetDaysFromUnix(time)

	if time < 0
		d.y = d.y + WRAP_YEARS
	endif
			
endfunction

//-----------------------------------------------------
// Get the time for the passed time.
//
function coGetTime(time as integer, t ref as Time)

	if time < -WRAP_SECS
		time = time + WRAP_SECS
	endif
	
	t.h = GetHoursFromUnix(time)
	t.m = GetMinutesFromUnix(time)
	t.s = GetSecondsFromUnix(time)
	
endfunction

//-----------------------------------------------------
// Get the day of the week from a unix time.
// Uses Zeller's Alhorithm.
//
function coGetDayOfWeek(time as integer)
	
	local k as integer
	local j as integer
	local f as integer
	local h as integer
	local d as integer
	local date as Date
	
	coGetDate(time, date)

	if date.m < 3
		
		date.m = date.m + 12
		dec date.y
		
	endif
	
	k = mod(date.y, 100)
	j = floor(date.y / 100)
	//h = date.d + floor((13 * (date.m + 1)) / 5) + k + floor(k / 4) + floor(j / 4) - 2 * j
	h = date.d + floor((13 * (date.m + 1)) / 5) + k + floor(k / 4) + floor(j / 4) + 5 * j
	d = mod(h + 6, 7)
	
endfunction d

//-----------------------------------------------------
// Format a unix time to the passed s format.
//
function coFormatDateTime(time as integer, s as string)
	
	local ret as string
	
	ret = coFormatDateTimeZone(time, s, 0)
	
endfunction ret

//-----------------------------------------------------
// Adjust the passed time by timezone.
// tz = +/- hours.
//
function coAdjustTimeZone(time as integer, tz as integer)
	
	time = time + (tz * HOUR_SECS) // Hack, later fix with tz = idx.

endfunction time

//-----------------------------------------------------
// Format a unix time to the passed s format with time zone.
// tz = +/- hours.
//
function coFormatDateTimeZone(time as integer, s as string, tz as integer)

	local pos as integer
	local i as integer
	local dddd as string
	local mmmm as string
	local dow as integer
	local h12 as integer
	local tt as string 
	local d as Date
	local t as Time

	time = coAdjustTimeZone(time, tz) // time + (tz * HOUR_SECS) // Hack, later fix with tz = idx.
/*
	d.y = GetYearFromUnix(time)
	d.m = GetMonthFromUnix(time)
	d.d = GetDaysFromUnix(time)
	t.h = GetHoursFromUnix(time)
	t.m = GetMinutesFromUnix(time)
	t.s = GetSecondsFromUnix(time)
*/	
	coGetDate(time, d)
	coGetTime(time, t)

	//log("date/time=" + str(yy) + "-" + str(mon) + "-" + str(dd) + "T" + str(hh) + ":" + str(mm) + ":" + str(ss))

	dow = coGetDayOfWeek(time)
	dddd = co.days[dow]
	mmmm = co.months[d.m] // "August"
	
	for i = 0 to co.dateFmt.length

		pos = FindString(s, co.dateFmt[i])

		if pos > 0
		
			if co.dateFmt[i] = "{DDDD}"
				s = ReplaceString(s, co.dateFmt[i], upper(dddd), -1)				
			elseif co.dateFmt[i] = "{Dddd}"
				s = ReplaceString(s, co.dateFmt[i], dddd, -1)				
			elseif co.dateFmt[i] = "{dddd}"
				s = ReplaceString(s, co.dateFmt[i], lower(dddd), -1)				
			elseif co.dateFmt[i] = "{DDD}"
				s = ReplaceString(s, co.dateFmt[i], upper(left(dddd, 3)), -1)				
			elseif co.dateFmt[i] = "{Ddd}"
				s = ReplaceString(s, co.dateFmt[i], left(dddd, 3), -1)				
			elseif co.dateFmt[i] = "{ddd}"
				s = ReplaceString(s, co.dateFmt[i], lower(left(dddd, 3)), -1)				
			elseif co.dateFmt[i] = "{DD}"
				s = ReplaceString(s, co.dateFmt[i], right("00" + str(d.d), 2), -1)		
			elseif co.dateFmt[i] = "{D}"
				s = ReplaceString(s, co.dateFmt[i], str(d.d), -1)				
			elseif co.dateFmt[i] = "{MMMM}"
				s = ReplaceString(s, co.dateFmt[i], upper(mmmm), -1)				
			elseif co.dateFmt[i] = "{Mmmm}"
				s = ReplaceString(s, co.dateFmt[i], mmmm, -1)				
			elseif co.dateFmt[i] = "{mmmm}"
				s = ReplaceString(s, co.dateFmt[i], lower(mmmm), -1)				
			elseif co.dateFmt[i] = "{MMM}"
				s = ReplaceString(s, co.dateFmt[i], upper(left(mmmm, 3)), -1)				
			elseif co.dateFmt[i] = "{Mmm}"
				s = ReplaceString(s, co.dateFmt[i], left(mmmm, 3), -1)				
			elseif co.dateFmt[i] = "{mmm}"
				s = ReplaceString(s, co.dateFmt[i], lower(left(mmmm, 3)), -1)				
			elseif co.dateFmt[i] = "{MM}"
				s = ReplaceString(s, co.dateFmt[i], right("00" + str(d.m), 2), -1)				
			elseif co.dateFmt[i] = "{M}"
				s = ReplaceString(s, co.dateFmt[i], str(d.m), -1)				
			elseif co.dateFmt[i] = "{YYYY}"
				s = ReplaceString(s, co.dateFmt[i], right(str(d.y), 4), -1)				
			elseif co.dateFmt[i] = "{YY}"
				s = ReplaceString(s, co.dateFmt[i], right(str(d.y), 2), -1)				
			endif
			
		endif
		
	next
		
	h12 = mod(t.h, 12)

	if t.h > 12
		tt = "Pm"
	else
		tt = "Am"
	endif
	
	for i = 0 to co.timeFmt.length

		pos = FindString(s, co.timeFmt[i])

		if pos > 0
		
			if co.timeFmt[i] = "{HH}"
				s = ReplaceString(s, co.timeFmt[i], right("00" + str(t.h), 2), -1)				
			elseif co.timeFmt[i] = "{H}"
				s = ReplaceString(s, co.timeFmt[i], str(t.h), -1)				
			elseif co.timeFmt[i] = "{hh}"
				s = ReplaceString(s, co.timeFmt[i], right("00" + str(h12), 2), -1)				
			elseif co.timeFmt[i] = "{h}"
				s = ReplaceString(s, co.timeFmt[i], str(h12), -1)				
			elseif co.timeFmt[i] = "{mm}"
				s = ReplaceString(s, co.timeFmt[i], right("00" + str(t.m), 2), -1)				
			elseif co.timeFmt[i] = "{m}"
				s = ReplaceString(s, co.timeFmt[i], str(t.m), -1)				
			elseif co.timeFmt[i] = "{ss}"
				s = ReplaceString(s, co.timeFmt[i], right("00" + str(t.s), 2), -1)				
			elseif co.timeFmt[i] = "{s}"
				s = ReplaceString(s, co.timeFmt[i], str(t.s), -1)				
			elseif co.timeFmt[i] = "{TT}"
				s = ReplaceString(s, co.timeFmt[i], upper(tt), -1)				
			elseif co.timeFmt[i] = "{Tt}"
				s = ReplaceString(s, co.timeFmt[i], tt, -1)				
			elseif co.timeFmt[i] = "{tt}"
				s = ReplaceString(s, co.timeFmt[i], lower(tt), -1)				
			elseif co.timeFmt[i] = "{T}"
				s = ReplaceString(s, co.timeFmt[i], left(tt, 1), -1)				
			elseif co.timeFmt[i] = "{t}"
				s = ReplaceString(s, co.timeFmt[i], left(lower(tt), 1), -1)				
			endif
			
		endif
		
	next

endfunction s

//-----------------------------------------------------
// Format a duration to: [{d}d [{h}h [{m}m [{s}s]]]] or 0
// Note: time is not a unix time, just a duration time in seconds.
//
function coFormatDuration(time as integer, dur ref as Duration)
	
	local s as string
	
	dur.d = time / DAY_SECS
	time = time - dur.d * DAY_SECS
	dur.h = time / HOUR_SECS
	time = time - dur.h * HOUR_SECS
	dur.m = time / 60
	time = time - dur.m * 60
	dur.s = time
	
	if dur.d > 0
		
		if s <> "" then s = s + " "
		s = s + str(dur.d) + "d"
		
	endif

	if dur.h > 0
		
		if s <> "" then s = s + " "
		s = s + str(dur.h) + "h"
		
	endif
	
	if dur.m > 0
		
		if s <> "" then s = s + " "
		s = s + str(dur.m) + "m"
		
	endif

	if dur.s > 0
		
		if s <> "" then s = s + " "
		s = s + str(dur.s) + "s"
		
	endif
	
	if s = "" // Nothing valid, return 0.
		s = "0"
	endif

endfunction s

//-----------------------------------------------------
// return "true" or "false" depending on value of v.
//
function coTrueFalse(v as integer)
	
	local ret as string
	
	if v
		ret = "true"
	else
		ret = "false"
	endif
	
endfunction ret

//-----------------------------------------------------
// Check if in win_mode that the left mouse is pressed.
//
function coLeftPress()

	if WIN_MODE
		if in.leftMousePressed
			exitfunction true
		endif
	else 
		if in.ptrPressed
			exitfunction true
		endif
	endif
	
endfunction false

//-----------------------------------------------------
// Check if in win_mode that the left mouse is down.
//
function coLeftDown2()

	if WIN_MODE
		if in.leftMouseDown
			exitfunction true
		endif
	else 
		if in.ptrDown
			exitfunction true
		endif
	endif
	
endfunction false

//-----------------------------------------------------
// Check if in win_mode that the left or right mouse is down.
//
function coAnyDown2()

	exitfunction true
	
	if WIN_MODE
		if in.leftMouseDown or in.rightMouseDown
			exitfunction true
		endif
	else 
		if in.ptrDown
			exitfunction true
		endif
	endif
	
endfunction false

//-----------------------------------------------------
// Check if in win_mode that the left mouse is down, otherwise if the cond is true.
//
function coLeftDown(cond)

	exitfunction cond
	
	if WIN_MODE
		if in.leftMouseDown
			//if cond
				exitfunction true
			//endif
		endif
	else 
		if cond
			exitfunction true
		endif
	endif
	
endfunction false

//-----------------------------------------------------
// Check if in win_mode that the right mouse is pressed.
//
function coRightPress()

	if WIN_MODE
		if in.rightMousePressed
			exitfunction true
		endif
	else 
		if in.ptrPressed
			exitfunction true
		endif
	endif
	
endfunction false

//-----------------------------------------------------
// Check if in win_mode that the right mouse is down, otherwise if the cond is true.
//
function coRightDown(cond)

	if WIN_MODE
		if in.rightMouseDown
			exitfunction true
		endif
	else 
		if cond
			exitfunction true
		endif
	endif
	
endfunction false

//-----------------------------------------------------
// If the value not 1, return "s".
//
function coIfPluralAddS(n as integer)
	
	if n = 1
		exitfunction ""
	endif
	
endfunction "s"

//-----------------------------------------------------
// If the value > 1, add the number followed by the suffix.
// Otherwise nothing.
//
function coIfPluralAddNbr(n as integer, suffix as string)
	
	if n > 1
		exitfunction str(n) + suffix
	endif
	
endfunction ""

//-----------------------------------------------------
// If the value > 1, add the number followed by the suffix.
// Otherwise nothing.
//
function coOrdinalPluralNbr(n as integer, suffix as string)
	
	if n > 1
		exitfunction coOrdinalNbr(n) + suffix
	endif
	
endfunction ""

//-----------------------------------------------------
// Convert the number to an ordinal number, e.g. 1st
//
function coOrdinalNbr(n as integer)
	
	local m as integer
	local ord as string
	
	m = mod(n, 10)
	
	if n > 10 and m < 14
		ord = "th"
	elseif m = 1
		ord = "st"
	elseif m = 2
		ord = "nd"
	elseif m = 3
		ord = "rd"
	else
		ord = "th"
	endif
	
	ord = str(n) + ord
	
endfunction ord

//-----------------------------------------------------
// Get an ordinal dom of month.
//
function coOrdinalDom(ord as integer)

	local s as string
	
	s = ""
	
	if ord > 0 and ord <= co.monthOrdinals.length
		s = co.monthOrdinals[ord]
	else
		s = co.monthOrdinals[0]
	endif
	
endfunction s

//-----------------------------------------------------
// Set a bit in an integer.
//
function coSetBit(v as integer, b as integer)
	
	//b = pow(2, b)
	v = v || (1 << b)
	
endfunction v

//-----------------------------------------------------
// Clear a bit in an integer.
//
function coClearBit(v as integer, b as integer)
	
	//b = pow(2, b)
	v = v && !(1 << b)
	
endfunction v

//-----------------------------------------------------
// Get a bit in an integer.
//
function coHasBit(v as integer, b as integer)
	
	local ret as integer
	
	//b = pow(2, b)
	//ret = v && b
	ret = (v >> b) && 1
	
endfunction ret

//-----------------------------------------------------
// Load all lines from a subimage file.
// file is the base path of the subimage, excluding .png or .txt.
// If file ends in "-", then it is a multi-file subimage, and iterates from 0 up.
//
function coLoadSubImage(file as string, subs ref as SubImage[])
	
	local i as integer
	local j as integer
	local fh as integer
	local line as string
	local tokCount as integer
	local fileCount as integer
	local sub as SubImage
	local img as integer
	
	if right(file, 1) = "-" // Multiple files starting with -0.
		
		file = left(file, len(file) - 1)
		i = 0
		
		while GetFileExists(file + "-" + str(i) + ".txt")
			
			inc fileCount
			inc i
			
		endwhile
		
	else
		
		fileCount = 1
		
	endif
	
	for j = 0 to fileCount - 1
	
		if fileCount > 1
			
			sub.ext = "-" + str(j)
			fh = OpenToRead(file + sub.ext + ".txt")
			
		else
			
			sub.ext = ""
			fh = OpenToRead(file + ".txt")
			
		endif

		sub.img = loadimage(file + sub.ext + ".png")
		
		if fh
			
			while not FileEOF(fh)
				
				line = ReadLine(fh)
				tokCount = CountStringTokens2(line, ":")
				
				if tokCount >= 5
					
					sub.name = GetStringToken2(line, ":", 1)
					sub.x = valfloat(GetStringToken2(line, ":", 2))
					sub.y = valfloat(GetStringToken2(line, ":", 3))
					sub.w = valfloat(GetStringToken2(line, ":", 4))
					sub.h = valfloat(GetStringToken2(line, ":", 5))
					sub.subImg = LoadSubImage(sub.img, sub.name)
					
					subs.insert(sub)
					
				endif
				
			endwhile
			
			CloseFile(fh)
			
		endif
		
	next
	
endfunction

// -------------------------------------------------------
// Check all textures to find the bounding box.
// path to folder of images.
//
function coCheckTextures(path as string, count as integer, b ref as Line)
	
	local i as integer
	local file as string
	local img as integer
	local smb as MemBlock
	local b2 as Line
	
	b.x0 = 999999
	b.y0 = 999999
	b.x1 = -999999
	b.y1 = -999999
	
	//coLogClear()
	
	for i = 1 to count
		
		file = path + right("0000" + str(i), 4) + ".png"
		img = loadimage(file)
		coMemFromImage(img, smb)			
		coMemFindGrab(smb, b2)
		
		if b2.x0 < b.x0 then b.x0 = b2.x0
		if b2.x1 > b.x1 then b.x1 = b2.x1
		if b2.y0 < b.y0 then b.y0 = b2.y0
		if b2.y1 > b.y1 then b.y1 = b2.y1		
		
		deleteimage(img)
		coMemDelete(smb)
		
	next
			
endfunction

// -------------------------------------------------------
// Pack texture files created by blender.
// path to folder of images.
//
function coPackTextures(path as string, dest as string, count as integer, x as float, y as float, w as float, h as float)
	
	local i as integer
	local j as integer
	local pix as integer
	local file as string
	local cols as integer
	local rows as integer
	local img as integer
	local iw as float
	local ih as float
	local col as integer
	local row as integer
	local spr as integer
	local smb as MemBlock
	local dmb as MemBlock
	local fmb as MemBlock
	local b as Line
	
	//path = "gifs/ErikaImgs/Run"
	//count = 20
	coLogClear()
	
	for i = 1 to count
		
		file = path + right("0000" + str(i), 4) + ".png"
		//file = "gifs2/ErikaRun2.png"
		img = loadimage(file)
		
		if i = 1
		
			cols = count // 2 // Start with half.
			rows = ceil(count / cols)
			
			iw = GetImageWidth(img)
			ih = GetImageHeight(img)
			log("inage width=" + str(iw) + ", height=" + str(ih))
					
			while iw * cols > ih * rows
				
				dec cols
				rows = ceil(count / cols)
				
			endwhile
			
			inc cols // We want width to be > height, just seems better.

			coMemCreate(fmb, cols * w, rows * h)
			coMemClear(fmb)
					
			col = 0 // top-left.
			row = 0
			
		endif

		coMemFromImage(img, smb)			
		//coMemFindGrab(smb, b)
		coMemGrab(smb, dmb, x, y, w, h)		
		coMemPaste(dmb, fmb, col * w, row * h)
		
		DeleteImage(img)
		coMemDelete(smb)
		coMemDelete(dmb)
			
		inc col
		
		if col >= cols
			
			col = 0
			inc row
			
		endif
		
	next
	
	coLogPrint("xxx.txt")
	
	log("write folder=" + GetWritePath())
	img = coMemToImage(fmb)
	SaveImage(img, dest) // "gifs2/ErikaRun2.png")
	coMemDelete(fmb)
	deleteimage(img)
	
endfunction

//-----------------------------------------------------
/// Linearly interpolates a value between two floats
/// </summary>
/// <param name="start_value">Start value</param>
/// <param name="end_value">End value</param>
/// <param name="pct">Our progress or percentage. [0,1]</param>
/// <returns>Interpolated value between two floats</returns>
//
function coLerp(startValue as float, endValue as float, pct as float)
	
	local ret as float
	
    ret = (startValue + (endValue - startValue) * pct)

endfunction ret

//-----------------------------------------------------
// EaseIn.
//
function coEaseIn(t as float)

	local ret as float
    
    ret = t * t

endfunction ret

//-----------------------------------------------------
// EaseOut.
//
function coEaseOut(t as float)

	local ret as float
	
    ret = coFlip(pow(coFlip(t), 2))

endfunction ret

//-----------------------------------------------------
// Ease in and out.
//
function coEaseInOut(t as float)

	local ret as float
	
    ret = coLerp(coEaseIn(t), coEaseOut(t), t)

endfunction ret

//-----------------------------------------------------
// Flip the value sign.
//
function coFlip(x as float)

	local ret as float
	
    ret = 1 - x

endfunction ret

//-----------------------------------------------------
// End.
//
