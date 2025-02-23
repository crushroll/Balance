// --------------------------
// Maintain the stability of the structure.
//

#option_explicit

#include "common.agc"
#include "input.agc"
#include "but.agc"

#constant MA_STATE_NONE = 0
#constant MA_STATE_TITLE = 1
#constant MA_STATE_EDIT = 2
#constant MA_STATE_PLAY = 3
#constant MA_STATE_WAIT = 4 // Want for the timer to determine if we have a successful physics!
#constant MA_STATE_FAIL = 5
#constant MA_STATE_SUCC = 6
#constant MA_STATE_EDITTIME = 7

#constant MA_DEPTH_EDITBOX = 50
#constant MA_DEPTH_DTX = 1600
#constant MA_DEPTH_DIALOG = 1700
#constant MA_DEPTH_SHAPE = 1800
#constant MA_DEPTH_SEL = 1900
#constant MA_DEPTH_EDIT = 2000

#constant MA_MIN_TIME = 1000
#constant MA_MAX_TIME = 10000

#constant MA_TITLE_HELP_MAX = 3
#constant MA_EDIT_HELP_MAX = 6
#constant MA_PLAY_HELP_MAX = 6

#constant MA_SHP_X = 0
#constant MA_SHP_I = 1
#constant MA_SHP_J = 2
#constant MA_SHP_L = 3
#constant MA_SHP_O = 4
#constant MA_SHP_S = 5
#constant MA_SHP_T = 6
#constant MA_SHP_Z = 7

#constant MA_BUILTIN_LEVELS = 16

type Cell
	
	x as integer
	y as integer
	rect as Rect
	spr as integer
	col as integer
	
endtype

type Shape
	
	typ as integer
	x as integer
	y as integer
	rot as integer // 0, 1, 2, 3
	spr as integer
	phys as integer // Determines whether physics is on.
	rect as Rect
	sol as integer
	
endtype

type StoredShape
	
	typ as integer
	x as integer
	y as integer
	rot as integer
	sol as integer // solution shape. Don't show, use to check.
	
endtype

type Level
	
	nbr as integer // For sorting.
	time as integer
	shps as Shape[] // String shape.
	
endtype

type StoredLevel
	
	time as integer
	shps as StoredShape[] // String shape.
	
endtype

type LevelState
	
	dt as string
	time as integer
	score as integer
	
endtype

type Main
	
	state as integer
	w as integer
	h as integer
	s as float
	pw as float
	ph as float
	ox as integer
	oy as integer
	base as integer
	cells as Cell[]
	shps as Shape[]
	typNam as string[MA_SHP_Z]
	typCol as integer[]
	typImg as integer[MA_SHP_Z]
	tickImg as integer
	playImg as integer
	stopImg as integer
	backImg as integer
	editImg as integer
	nextImg as integer
	retryImg as integer
	helpImg as integer
	saveImg as integer
	addImg as integer
	prevImg as integer
	cancelImg as integer
	buts as Button[]
	sels as Shape[] // The selector shapes.
	selTyp as integer // The selected typ.
	selShp as Shape // The selected sprite to drop based on typ.
	selY as float
	phys as integer
	readpath as string
	writepath as string
	levs as Level[]
	levStates as LevelState[]
	levButs as Button[]
	title as integer
	sbutImg as integer
	mButImg as integer
	lButImg as integer
	xlButImg as integer
	startBut as Button
	saveBut as Button
	levBut as Button
	timeBut as Button
	scoreBut as Button
	backBut as Button
	editBut as Button
	helpBut as Button
	addBut as Button
	retryBut as Button
	butCol as integer
	selButCol as integer
	lev as integer
	time as integer
	score as integer
	shape as integer
	starttime as integer
	failtime as integer
	dialogTxs as string[]
	nextBut as Button	
	dialogTx as integer
	dlog as integer
	selCol1 as integer
	selCol2 as integer
	editAct as integer
	playCol1 as integer
	playCol2 as integer
	help as integer // dialogr
	helpTx as integer
	helpPrevBut as Button
	helpNextBut as Button
	helpQuitBut as Button
	gap as float
	helpIdx as integer
	helpAct as integer
	font as integer
	edittime as integer
	edittitle as integer
	best as integer // Text.
	bestscore as integer // score value.
	dirsfont as integer
	subtitle as integer
	levtitle as integer
	gridy0 as float
	gridy1 as float
	
endtype

global ma as Main

maInit()
maTitle()
//SetPhysicsDebugOn()

do
	
	maUpdate()
	Sync()
	
loop

end

// ---------------------------
// Init.
//
function maInit()
			
	local i as integer
	local x as float
	local y as float
	local shp as Shape
	local xx as float
	local yy as float
	local w as float
	local h as float
	local but as Button
	local sc as float
	local n as integer
	
	ma.s = 64
	ma.w = 20
	ma.h = 20
	ma.ox = 0
	ma.oy = 3
	ma.pw = (ma.w + ma.ox) * ma.s
	ma.ph = (ma.h + ma.oy) * ma.s
	ma.shape = 3
	ma.editAct = false
	ma.gap = 8
	ma.helpAct = false
	
	setVirtualResolution(ma.pw, ma.ph)
	sc = 1.75
	h = GetDeviceHeight() * sc
	h = h * 0.95
	w = h / (ma.ph / ma.pw)
	SetWindowSize(w, h, false)
	//SetWindowPosition((GetDeviceWidth() * sc) / 2 - GetWindowWidth() / 2, h / 2 - GetWindowHeight() / 2)
	SetWindowPosition(0, 0)
	
	coInit()

	ma.selCol1 = co.blue[5]
	ma.selCol2 = co.blue[8]
	ma.playCol1 = co.grey[5]
	ma.playCol2 = co.grey[7]
	ma.font = 2
	ma.dirsfont = 30

	ma.readPath = GetReadPath()
	ma.writePath = GetWritePath()
	//message("readpath=" + ma.readpath + ", writepath=" + ma.writepath)
		
	//ma.typNam = [ "X", "I", "J", "L", "O", "S", "T", "Z" ]
	ma.typNam = [ "X", "A", "B", "C", "D", "W" ]
	
	//ma.typCol.insert(makecolor(255, 255, 255))
	//ma.typCol.insert(makecolor(0, 255, 255))
	//ma.typCol.insert(makecolor(0, 0, 255))
	//ma.typCol.insert(makecolor(255, 127, 0))
	//ma.typCol.insert(makecolor(255, 255, 0))
	//ma.typCol.insert(makecolor(0, 255, 0))
	//ma.typCol.insert(makecolor(255, 0, 255))
	//ma.typCol.insert(makecolor(255, 0, 0))

	ma.typCol.insert(makecolor(255, 255, 255))
	ma.typCol.insert(makecolor(255, 0, 0))
	ma.typCol.insert(makecolor(0, 255, 0))
	ma.typCol.insert(makecolor(0, 0, 255))
	ma.typCol.insert(makecolor(255, 255, 0))
	ma.typCol.insert(makecolor(255, 255, 255))

	for i = 0 to ma.typNam.length
		ma.typImg[i] = loadimage("shps/" + ma.typNam[i] + ".png")		
	next

	ma.tickImg = loadimage("gfx/tick.png")
	ma.playImg = loadimage("gfx/play.png")
	ma.stopImg = loadimage("gfx/stop.png")
	ma.backImg = loadimage("gfx/back.png")
	ma.editImg = loadimage("gfx/edit.png")
	ma.nextImg = loadimage("gfx/next.png")
	ma.retryImg = loadimage("gfx/retry.png")
	ma.helpImg = loadimage("gfx/help.png")
	ma.saveImg = loadimage("gfx/save.png")
	ma.addImg = loadimage("gfx/add.png")
	ma.prevImg = loadimage("gfx/prev.png")
	ma.cancelImg = loadimage("gfx/cancel.png")
	
	ma.sButImg = loadimage("gfx/sbut.png")
	ma.mbutImg = loadimage("gfx/mbut.png")
	ma.lButImg = loadimage("gfx/lbut.png")
	ma.xlButImg = loadimage("gfx/xlbut.png")
	
	// Play and editor.
	
	maCreateShape(shp, MA_SHP_X, 0, 0)
	ma.sels.insert(shp)
	maCreateShape(shp, MA_SHP_I, 0, 0)
	ma.sels.insert(shp)
	maCreateShape(shp, MA_SHP_J, 0, 0)
	ma.sels.insert(shp)
	maCreateShape(shp, MA_SHP_L, 0, 0)
	ma.sels.insert(shp)
	maCreateShape(shp, MA_SHP_O, 0, 0)
	ma.sels.insert(shp)
	maCreateShape(shp, MA_SHP_S, 0, 0)
	ma.sels.insert(shp)
	//maCreateShape(shp, MA_SHP_T, 0, 0)
	//ma.sels.insert(shp)
	//maCreateShape(shp, MA_SHP_Z, 0, 0)
	//ma.sels.insert(shp)
	
	ma.base = createsprite(co.pixImg)
	SetSpriteScale(ma.base, ma.s * ma.pw, ma.s)
	SetSpritePosition(ma.base, 0, co.h - ma.s)
	SetSpriteVisible(ma.base, false)
	
	//maTestWelds()		
	maGrid()

	y = (ma.s * ma.oy) / 2
	
	ma.selY = y + ma.s
	ma.butCol = makecolor(127, 127, 127)
	ma.selButCol = co.blue[5]
	
	for i = 0 to ma.sels.length
				
		buCreateBut(but, ma.sButImg, 0)
		if i = 0 then x = GetSpriteWidth(but.bg) / 2 + ma.gap * 26 
		but.fg = ma.sels[i].spr
		buSetButScale(but, 0.7, 0.7)
		
		//if i = MA_SHP_X or i = MA_SHP_O
		if i = MA_SHP_I
			buFitFg(but, 0, 32)
		elseif i = MA_SHP_J
			buFitFg(but, 0, 24)
		elseif i = MA_SHP_L
			buFitFg(but, 0, 16)			
		elseif i = MA_SHP_O
			buFitFg(but, 0, 64)
		else
			buFitFg(but, 0, 0)
		endif
		
		coSetSpriteColor(but.bg, ma.butCol)
		buSetButPos(but, x, y)
		ma.buts.insert(but)

		inc x, GetSpriteWidth(but.bg) + ma.gap
		
	next
	
	x = co.w - ma.gap * 11
	y = (ma.s * ma.oy) / 2
	yy = y
	buCreateBut(ma.startBut, ma.sButImg, ma.playImg)
	coSetSpriteColor(ma.startBut.bg, ma.butCol)
	buSetButPos(ma.startBut, x, y)

	//y = y - ma.s + gap * 2
	
	sc = 0.3
	buCreateBut(ma.levBut, ma.xlButImg, 0)
	buSetButScale(ma.levBut, sc, sc)
	x = x - GetSpriteWidth(ma.startBut.bg) / 2 - GetSpriteWidth(ma.levBut.bg) / 2 - ma.gap * 3
	y = y - GetSpriteHeight(ma.startBut.bg) / 2 + GetSpriteHeight(ma.levBut.bg) / 2
	coSetSpriteColor(ma.levBut.bg, ma.butCol)
	buSetButTx(ma.levBut, DIR_C, "Level: 1", ma.font, ma.dirsfont)
	buSetButPos(ma.levBut, x, y)
	inc y, GetSpriteHeight(ma.levBut.bg) + ma.gap
	buSetButVis(ma.levBut, false)

	buCreateBut(ma.timeBut, ma.xlButImg, 0)
	buSetButScale(ma.timeBut, sc, sc)
	coSetSpriteColor(ma.timeBut.bg, ma.butCol)
	buSetButTx(ma.timeBut, DIR_C, "Time: 0", ma.font, ma.dirsfont)
	buSetButPos(ma.timeBut, x, y)
	inc y, GetSpriteHeight(ma.levBut.bg) + ma.gap
	buSetButVis(ma.timeBut, false)

	buCreateBut(ma.scoreBut, ma.xlButImg, 0)
	buSetButScale(ma.scoreBut, sc, sc)
	coSetSpriteColor(ma.scoreBut.bg, ma.butCol)
	buSetButTx(ma.scoreBut, DIR_C, "Score: 0", ma.font, ma.dirsfont)
	buSetButPos(ma.scoreBut, x, y)
	inc y, GetSpriteHeight(ma.levBut.bg) + ma.gap
	buSetButVis(ma.scoreBut, false)

	buCreateBut(ma.backBut, 0, ma.backImg)
	//buSetButScale(ma.backBut, 0.5, 0.5)
	buSetButPos(ma.backBut, GetSpriteWidth(ma.backBut.fg) / 2, GetSpriteHeight(ma.backBut.fg) / 2)

	buCreateBut(ma.helpbut, ma.sButImg, ma.helpImg)
	buSetButScale(ma.helpbut, 0.5, 0.5)
	coSetSpriteColor(ma.helpbut.bg, ma.butCol)
	buSetButPos(ma.helpbut, GetSpriteWidth(ma.backbut.fg) / 2, getspritey(ma.backBut.fg) + GetSpriteHeight(ma.backBut.fg) + ma.gap * 5)
	buSetButVis(ma.helpbut, false)

	buCreateBut(ma.editBut, ma.sButImg, ma.editImg)
	buSetButScale(ma.editBut, 0.5, 0.5)
	coSetSpriteColor(ma.editBut.bg, ma.butCol)
	buSetButPos(ma.editBut, GetSpriteWidth(ma.editBut.bg) * 2, getspritey(ma.backBut.fg) + GetSpriteHeight(ma.backBut.fg) + ma.gap * 5)
	buSetButVis(ma.editBut, false)

	buCreateBut(ma.retryBut, ma.sButImg, ma.retryImg)
	buSetButScale(ma.retryBut, 0.5, 0.5)
	coSetSpriteColor(ma.retryBut.bg, ma.butCol)
	buSetButPos(ma.retryBut, GetSpriteWidth(ma.editBut.bg) * 2, getspritey(ma.backBut.fg) + GetSpriteHeight(ma.backBut.fg) + ma.gap * 5)
	buSetButVis(ma.retryBut, false)
	
	inc x, GetSpriteWidth(ma.editbut.bg) + ma.gap * 3

	buCreateBut(ma.saveBut, ma.sButImg, ma.saveImg)
	buSetButScale(ma.saveBut, 0.5, 0.5)
	coSetSpriteColor(ma.saveBut.bg, ma.butCol)
	buSetButPos(ma.saveBut, GetSpriteWidth(ma.editBut.bg) * 2, getspritey(ma.backBut.fg) + GetSpriteHeight(ma.backBut.fg) + ma.gap * 5)
	buSetButVis(ma.saveBut, false)

	// Main menu.
		
	x = co.w / 2
	y = 0
	h = GetSpriteWidth(ma.startBut.bg)

	ma.subtitle = coCreateText("Nothing can go wrong ... if you maintain your", ma.font, 40)
	SetTextAlignment(ma.subtitle, 1)
	SetTextPosition(ma.subtitle, x, GetTextTotalHeight(ma.subtitle) / 2 - ma.gap * 1)

	ma.title = coCreateText("Balance", ma.font, 160)
	SetTextAlignment(ma.title, 1)
	SetTextPosition(ma.title, x, GetTextTotalHeight(ma.title) / 2 - ma.gap * 5)
	
	n = 1
	
	for i = 0 to len("Balance") - 1
	
		coSetTextCharColor(ma.title, i, ma.typCol[n])
		inc n
		if n = 4 then n = 1
		
	next

	ma.best = coCreateText("", ma.font, 40)
	SetTextAlignment(ma.best, 2)
	SetTextPosition(ma.best, co.w - ma.gap * 3, gettexty(ma.title) + ma.gap * 2)

	ma.levtitle = coCreateText("Select a level", ma.font, 40)
	SetTextAlignment(ma.levtitle, 1)
	//SetTextPosition(ma.levtitle, x, GetTextTotalHeight(ma.subtitle) / 2 - ma.gap * 1)

	ma.selTyp = 0
	ma.selShp.typ = MA_SHP_X
	ma.phys = false
		
endfunction

// ---------------------------
// Load best score.
//
function maLoadScore()

	local s as string
	local v as integer
	local file as string
	
	setfolder("/media")
	setfolder("score")
	
	file = "score.txt"
	
	if not GetFileExists(file)
		maSaveScore()
	endif
		
	s = maLoadFile(file)
	v = val(s)
	ma.bestscore = v

	setfolder("/media")

endfunction

// ---------------------------
// Save best score.
//
function maSaveScore()
	
	local file as string
	
	setfolder("/media")
	setfolder("score")
	
	file = "score.txt"

	maSaveFile(file, str(ma.bestscore))
	
	setfolder("/media")

endfunction

// ---------------------------
// Load levels.
//
function maLoadLevels()
	
	local file as string
	local s as string
	local sl as StoredLevel
	local lev as Level
	local levState as LevelState
	local a as integer
	local shp as Shape
	local i as integer
	local j as integer
	local pos as integer
	local nbr as integer
	local nbrs as integer[]
	
	setfolder("/media")
	setfolder("levs")

	ma.levs.length = -1
	
	file = GetFirstFile()

	while file <> ""
		
		pos = findstring(file, ".")
		nbr = val(mid(file, 1, pos - 1)) // sl.nbr
		
		for j = 0 to nbrs.length
			if nbrs[j] = nbr
				//log("existing level=" + str(j))
				continue // Ignore previously loaded levels to ensure we don't load twice.
			endif
		next
		
		nbrs.insert(nbr)
				
		//log("folder=" + getfolder() + ", file=" + file)
		s = maLoadFile(file)
		
		sl.fromjson(s)
		
		lev.nbr = nbr
		lev.time = sl.time
		
		if lev.time < MA_MIN_TIME
			lev.time = MA_MIN_TIME
		elseif lev.time > MA_MAX_TIME
			lev.time = MA_MAX_TIME
		endif
		
		lev.shps.length = -1 // Clear for reuse.
			
		for i = 0 to sl.shps.length
			
			shp.typ = sl.shps[i].typ
			shp.x = sl.shps[i].x
			shp.y = sl.shps[i].y
			shp.rot = sl.shps[i].rot
			shp.sol = sl.shps[i].sol
			shp.phys = false
			lev.shps.insert(shp)
			
		next
		
		ma.levs.insert(lev)
		
		file = getnextfile()
		
	endwhile
	
	setfolder("/media")
	
	ma.levs.sort()
				
endfunction

// ---------------------------
// Load a level or state file.
//
function maLoadFile(file as string)
	
	local fh as integer
	local s as string
	
	fh = OpenToRead(file)
	s = ReadLine(fh)
	closefile(fh)
	
endfunction s

// ---------------------------
// Save file.
//
function maSaveFile(file as string, s as string)
	
	local fh as integer
	
	fh = OpenToWrite(file)
	WriteLine(fh, s)
	CloseFile(fh)
	
endfunction

// ---------------------------
// Save level.
//
function maSaveLevel()
	
	local sl as StoredLevel
	local ss as StoredShape
	local nbr as integer
	local name as string
	local i as integer
	local fh as integer
	local s as string
	local lev as integer
	
	sl.time = ma.time
		
	for i = 0 to ma.shps.length
		
		ss.typ = ma.shps[i].typ
		ss.x = ma.shps[i].x
		ss.y = ma.shps[i].y
		ss.rot = ma.shps[i].rot
		ss.sol = ma.shps[i].sol
		
		sl.shps.insert(ss)
		
	next
			
	setfolder("/media")
	SetFolder("levs")
	
	lev = ma.lev
	if lev = -1 then lev = ma.levs.length + 1
	
	name = str(lev) + ".txt"
	s = sl.tojson()
	s = ReplaceString(s, chr(10), " ", -1)
	s = ReplaceString(s, " ", "", -1)
	//fh = OpenToWrite(name)
	//WriteLine(fh, s)
	//CloseFile(fh)
	maSaveFile(name, s)
	
	setfolder("/media")
	
endfunction

// ---------------------------
// Save level state.
//
function maSaveLevelState()
	
	local lev as LevelState
	local nbr as integer
	local name as string
	local i as integer
	local fh as integer
	local s as string
				
	SetFolder("states")
	
	lev.time = ma.time
	lev.score = ma.score
	lev.dt = GetCurrentDate() + " " + GetCurrentTime()
	
	name = str(ma.lev) + ".txt"
	
	fh = OpenToWrite(name)
	s = lev.tojson()
	s = ReplaceString(s, chr(10), " ", -1)
	s = ReplaceString(s, " ", "", -1)
	WriteLine(fh, s)
	CloseFile(fh)
	
	setfolder("/media")
	
endfunction

// ---------------------------
// Clean up.
//
function maClean()
	
	local i as integer
	
	for i = 0 to ma.shps.length
		madeleteshape(ma.shps[i])
	next
		
	ma.shps.length = -1
	
	maDeleteShape(ma.selShp)
	
endfunction

// ---------------------------
// Allow editing a level and save.
//
function maGrid()
	
	local x as integer
	local y as integer
	local px as float
	local py as float
	local col as integer
	local col1 as integer
	local col2 as integer
	local spr as integer
	local cell as Cell
	local idx as integer
	
	//col1 = makecolor(47, 47, 47) 
	//col2 = makecolor(31, 31, 31) 
	col1 = co.grey[8]
	col2 = co.grey[9]
	py = ma.oy * ma.s
	
	for y = 0 to ma.h - 1
		
		if mod(y, 2) = 0 then col = col2 else col = col1
		px = ma.ox * ma.s
			
		for x = 0 to ma.w - 1
			
			spr = CreateSprite(co.pixImg)
			setspritescale(spr, ma.s, ma.s)
			SetSpritePositionByOffset(spr, px + ma.s / 2, py + ma.s / 2)
			coSetSpriteColor(spr, col)
			SetSpriteDepth(spr, MA_DEPTH_EDIT)
				
			cell.x = x
			cell.y = y
			cell.rect.x = px
			cell.rect.y = py
			cell.rect.w = ma.s
			cell.rect.h = ma.s
			cell.spr = spr
			cell.col = col
			ma.cells.insert(cell)
			
			if col = col1 then col = col2 else col = col1	
			inc px, ma.s
				
		next
		
		inc py, ma.s
		
	next
	
	idx = maGetCell(0, 0)
	ma.gridy0 = ma.cells[idx].rect.y
	idx = maGetCell(0, ma.h - 1)
	ma.gridy1 = ma.cells[idx].rect.y - 1
		
endfunction

// ---------------------------
// Show the menu.
//
function maTitle()
	
	local i as integer
	local w as integer
	local h as integer
	local x as integer
	local y as integer
	local xx as integer
	local yy as integer
	local but as Button
	local count as integer
	local sc as float
	local idx as integer
	local ww as integer
	local col as integer
	local n as integer
	local ts as integer
	local ox as integer
	local oy as integer
	local cy as integer
	local edit as integer
	
	if ma.editAct
		coSetSpriteColor(ma.editBut.bg, ma.selCol1)
	else 
		coSetSpriteColor(ma.editBut.bg, ma.butCol)
	endif

	ma.phys = false
	//maStop()
	
	buUpdateButPos(ma.editBut)
	
	maclean()
	magrid()
	maLoadLevels()
	maLoadScore()
	
	for i = 0 to ma.levbuts.length
		buDeleteBut(ma.levbuts[i])
	next 
	
	ma.levbuts.length = -1
	//ma.levs.length = 200
	
	count = ma.levs.length + 1	
	w = Sqrt(count)
	h = w
	
	while w * h < count
		inc h //, count - (w * h)
	endwhile
	
	if (w * 2) > ma.w
		
		ox = ma.ox + 10
		oy = ma.oy + 10
		xx = ox - w / 2
		yy = oy - h / 2
		n = 1
		
	else 
		
		ox = ma.ox + 11
		oy = ma.oy + 11
		xx = ox - w
		yy = oy - h
		n = 2
		
	endif
	
	x = xx
	y = yy
	ww = w
	cy = 0

	edit = ma.editact
	ma.editact = false
	
	for i = 0 to ma.levs.length
	
		if x = xx // Start of each line.
			if mod(cy, 2) = 0 // Alternate starting color.
				col = maFlipCol(2, 0)
			else 
				col = maFlipCol(1, 0)
			endif
		endif

		buCreateBut(but, ma.sButImg, 0)
		
		if n = 1
			
			sc = ma.s / GetSpriteWidth(but.bg)
			buSetButScale(but, sc, 0)
			
		endif

		if i = 0
			
			buSetButTx(but, DIR_C, str(count), ma.font, 0)
			ts = gettextsize(but.txs[0].tx) - 6
			
		endif
		
		buSetButTx(but, DIR_C, str(i + 1), ma.font, ts)
				
		coSetSpriteColor(but.bg, col)
		
		if n = 1
			buSetButPos(but, x * ma.s + ma.s / 2, y * ma.s + ma.s / 2)
		else
			buSetButPos(but, x * ma.s, y * ma.s)
		endif
		
		ma.levButs.insert(but)
		
		dec ww
		
		if ww = 0
			
			inc y, n
			x = xx
			
			inc cy
			
			ww = w
																							
		else
			 
			inc x, n		
				
			col = maFlipCol(0, col)
												
		endif
								
	next
		
	if not ma.addbut.bg
				
		buCreateBut(ma.addBut, ma.sButImg, ma.addImg)
		buSetButTx(ma.addBut, DIR_S, "Add", ma.font, n * ma.dirsfont)
		//sc = ma.s / GetSpriteWidth(ma.addBut.bg)
		//buSetButScale(ma.addBut, sc, 0.5)
		if n = 1
			
			sc = ma.s / GetSpriteWidth(ma.addBut.bg)
			buSetButScale(ma.addbut, sc, sc)	
			
		endif
		
	endif

	if n = 1
		buSetButPos(ma.addbut, x * ma.s + ma.s / 2, y * ma.s + ma.s / 2)
	else
		buSetButPos(ma.addbut, x * ma.s, y * ma.s)
	endif
	
	// Now color levels for editing.
	ma.editact = edit
	
	for i = 0 to ma.levs.length
	
		if x = xx // Start of each line.
			if mod(cy, 2) = 0 // Alternate starting color.
				col = maFlipCol(2, 0)
			else 
				col = maFlipCol(1, 0)
			endif
		endif
		
		if i > MA_BUILTIN_LEVELS - 1		
			coSetSpriteColor(ma.levbuts[i].bg, col)
		endif
		
		dec ww
		
		if ww = 0
			
			inc y, n
			x = xx
			
			inc cy
			
			ww = w
																							
		else
			 
			inc x, n		
				
			col = maFlipCol(0, col)
												
		endif
								
	next
	
	if x = xx // Start of each line.
		if mod(cy, 2) = 0 // Alternate starting color.
			col = maFlipCol(2, 0)
		else 
			col = maFlipCol(1, 0)
		endif
	endif

	coSetSpriteColor(ma.addBut.bg, col)

	//buSetButPos(ma.addBut, xx, yy)
	buSetButVis(ma.addbut, ma.editAct)

	for i = 0 to ma.buts.length	
		buSetButVis(ma.buts[i], false)
	next

	SetSpriteVisible(ma.base, false)
	SetSpritePhysicsOff(ma.base)

	buSetButVis(ma.levBut, false)
	buSetButVis(ma.timeBut, false)
	buSetButVis(ma.scoreBut, false)	
	buSetButVis(ma.startBut, false)
	buUpdateButPos(ma.startBut)
	buSetButVis(ma.saveBut, false)
	
	//for i = 0 to ma.cells.length
	//	SetSpriteVisible(ma.cells[i].spr, false)
	//next
	
	buSetButVis(ma.backBut, true)
	buSetButVis(ma.editBut, true)
	buSetButVis(ma.helpbut, true)
	buSetButVis(ma.retryBut, false)

	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], true)
	next
	
	SetTextVisible(ma.subtitle, true)
	SetTextVisible(ma.title, true)
	
	if ma.levbuts.length > -1
		
		SetTextPosition(ma.levtitle, co.w / 2, GetSpriteYByOffset(ma.levbuts[0].bg) - GetSpriteHeight(ma.levbuts[0].bg) - ma.s / n + ma.gap)
		SetTextVisible(ma.levtitle, true)
		
	else
		 
		SetTextVisible(ma.levtitle, false)

	endif
	
	SetTextString(ma.best, "Best" + chr(10) + "score" + chr(10) + str(ma.bestscore))
	SetTextVisible(ma.best, true)
	
	ma.state = MA_STATE_TITLE

	maDialog(false)
	maHelp(false, 0)
	
endfunction

// ---------------------------
// Flip the color.
//
function maFlipCol(nbr as integer, col as integer)
	
	if nbr = 0
		if ma.editAct
			if col = ma.selCol1
				col = ma.selCol2
			else 
				col = ma.selCol1
			endif
		else 
			if col = ma.playCol1
				col = ma.playCol2
			else 
				col = ma.playCol1
			endif
		endif
	else
		if ma.editAct
			if nbr = 1
				col = ma.selCol1
			else 
				col = ma.selCol2
			endif
		else 
			if nbr = 1
				col = ma.playCol1
			else 
				col = ma.playCol2
			endif
		endif
	endif
		
endfunction col

// ---------------------------
// Make edit sprites visible.
//
function maEdit()
	
	local i as integer
	
	SetTextVisible(ma.subtitle, false)
	SetTextVisible(ma.title, false)
	SetTextVisible(ma.best, false)
	SetTextVisible(ma.levtitle, false)

	buSetButVis(ma.levBut, true)
	buSetButVis(ma.timeBut, true)
	buSetButVis(ma.scoreBut, false)	
	buSetButVis(ma.startBut, true)
	buUpdateButPos(ma.startBut)
	
	buSetButVis(ma.backBut, true)
	buSetButVis(ma.saveBut, true)
	buSetButVis(ma.editBut, false)
	buSetButVis(ma.retryBut, false)
	buSetButVis(ma.addBut, false)
	buSetButVis(ma.helpbut, true)
	coSetSpriteColor(ma.helpbut.bg, ma.butCol)

	SetSpriteVisible(ma.base, true)
	SetSpritePhysicsOn(ma.base, 1)
	
	for i = 0 to ma.cells.length
		SetSpriteVisible(ma.cells[i].spr, true)
	next
	
	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], false)
	next
	
	ma.state = MA_STATE_EDIT
	
	ma.selTyp = 0
	ma.selShp.typ = MA_SHP_X
	ma.phys = false

	maHelp(false, 0)
	maDialog(false)
	maDrawButtons()
	maDrawLevel()
	maDrawScores()

endfunction

// ---------------------------
// check edit time.
//
function maUpdateEditTime()
	
	local s as string
	local v as integer
	local c as integer
	
	if GetEditBoxVisible(ma.edittime)
		
		if GetEditBoxChanged(ma.edittime)
			
			c = GetRawLastKey()
			
			if c = 13 // Enter
				
				s = GetEditBoxText(ma.edittime)
				v = val(s)
								
				if v < MA_MIN_TIME
					v = MA_MIN_TIME
				elseif v > MA_MAX_TIME
					v = MA_MAX_TIME
				endif
				
				ma.time = v
				
			endif
			
			SetTextVisible(ma.edittitle, false)
			SetEditBoxVisible(ma.edittime, false)
			
			ma.state = MA_STATE_EDIT
			maDrawScores()
			
		elseif not GetEditBoxHasFocus(ma.edittime)
	
			SetTextVisible(ma.edittitle, false)
			SetEditBoxVisible(ma.edittime, false)
			
			ma.state = MA_STATE_EDIT
	
		endif
		
	endif
	
endfunction

// ---------------------------
// Play mode.
//
function maPlay()
	
	local i as integer
			
	buSetButFg(ma.startBut, ma.playImg)

	SetTextVisible(ma.subtitle, false)
	SetTextVisible(ma.title, false)		
	SetTextVisible(ma.best, false)
	SetTextVisible(ma.levtitle, false)

	buSetButVis(ma.levBut, true)
	buSetButVis(ma.timeBut, true)
	buSetButVis(ma.scoreBut, true)
	buSetButVis(ma.startBut, true)
	buUpdateButPos(ma.startBut)
	
	buSetButAct(ma.helpBut, true)
	buSetButAct(ma.retryBut, true)

	buSetButVis(ma.saveBut, false)
	buSetButVis(ma.editBut, false)
	buSetButVis(ma.retryBut, true)
	buSetButVis(ma.addBut, false)
	buSetButVis(ma.helpbut, true)
	
	buSetButVis(ma.backBut, true)
	buSetButVis(ma.editBut, false)
	coSetSpriteColor(ma.helpbut.bg, ma.butCol)

	SetSpriteVisible(ma.base, true)
	SetSpritePhysicsOn(ma.base, 1)

	for i = 0 to ma.cells.length
		SetSpriteVisible(ma.cells[i].spr, true)
	next
		
	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], false)
	next

	ma.state = MA_STATE_PLAY
	ma.phys = false
	
	maHelp(false, 0)
	maDialog(false)
	maDrawLevel()
	maDrawScores()
	maDrawButtons()

endfunction

// ---------------------------
// Draw the buttons.
//
function maDrawButtons()

	local i as integer
	local counts as integer[MA_SHP_Z]
	local count as integer
	
	count = 0
	
	if ma.state = MA_STATE_PLAY
		
		for i = 0 to ma.levs[ma.lev].shps.length
			if ma.levs[ma.lev].shps[i].sol
				
				inc counts[ma.levs[ma.lev].shps[i].typ]
				inc count
				
			endif
		next
		
		for i = 0 to ma.shps.length
			if ma.shps[i].sol
				
				dec counts[ma.shps[i].typ]
				dec count
				
			endif
		next
		
	endif
	
	for i = 0 to ma.buts.length
		
		coSetSpriteColor(ma.buts[i].bg, ma.butcol)

		if ma.state = MA_STATE_EDIT
			
			buSetButTx(ma.buts[i], DIR_S, "", -1, -1)
			buSetButAct(ma.buts[i], true)
			buSetButVis(ma.buts[i], true)
		
		elseif ma.state = MA_STATE_PLAY
			
			if i > 0 and i < MA_SHP_S // PLAY.
			
				if counts[i]
					
					buSetButTx(ma.buts[i], DIR_S, str(counts[i]), ma.font, ma.dirsfont)	
					buSetButAct(ma.buts[i], true)
	
				else
					 
					buSetButTx(ma.buts[i], DIR_S, "", -1, -1)
					buSetButAct(ma.buts[i], false)
					
				endif
	
				buSetButVis(ma.buts[i], true)	
				
			else
	
				buSetButVis(ma.buts[i], false)	
				
			endif
			
		else

			buSetButVis(ma.buts[i], false)	
			
		endif
		
		buUpdateButPos(ma.buts[i])
				
	next
	
	if ma.buts[ma.selTyp].act then coSetSpriteColor(ma.buts[ma.selTyp].bg, ma.selButCol)
	
	if ma.state = MA_STATE_PLAY
			
		if count = 0
			buSetButAct(ma.startBut, true)
		else
			buSetButAct(ma.startBut, false)
		endif
		
		buSetButVis(ma.startBut, true)
		
	elseif ma.state = MA_STATE_EDIT

		if ma.phys
			buSetButFg(ma.startBut, ma.stopImg)
		else 
			buSetButFg(ma.startBut, ma.playImg)
		endif
		
		buSetButAct(ma.startBut, true)
		buSetButVis(ma.startBut, true)
		buUpdateButPos(ma.startBut)
		
	endif
	
endfunction

// ---------------------------
// Draw the score buttons.
//
function maDrawScores()
	
	buSetButTx(ma.levBut, DIR_C, "Level: " + str(ma.lev + 1), -1, -1)
	buSetButTx(ma.timeBut, DIR_C, "Time: " + str(ma.time), -1, -1)
	buSetButTx(ma.scoreBut, DIR_C, "Score: " + str(ma.score), -1, -1)
	
	if ma.state = MA_STATE_FAIL
		coSetSpriteColor(ma.scoreBut.bg, co.red[5])
	elseif ma.state = MA_STATE_SUCC
		coSetSpriteColor(ma.scoreBut.bg, co.green[5])
	else
		coSetSpriteColor(ma.scoreBut.bg, ma.butcol)
	endif
	
endfunction

// ---------------------------
// Draw the current level.
//
function maDrawLevel()
			
	local shp as Shape
	local i as integer
	local lev as integer
	
	maClean()

	lev = ma.lev

	if lev > -1 and lev <= ma.levs.length
			
		for i = 0 to ma.levs[lev].shps.length
			
			if ma.state = MA_STATE_PLAY
				
				if not ma.levs[lev].shps[i].sol	
					
					maCreateShape(shp, ma.levs[lev].shps[i].typ, ma.levs[lev].shps[i].x, ma.levs[lev].shps[i].y)
					shp.rot = ma.levs[lev].shps[i].rot
					shp.sol = ma.levs[lev].shps[i].sol
					
					maSetRotateShape(shp)					
					ma.shps.insert(shp)
					
				endif
				
			elseif ma.state = MA_STATE_EDIT
				
				maCreateShape(shp, ma.levs[lev].shps[i].typ, ma.levs[lev].shps[i].x, ma.levs[lev].shps[i].y)
				shp.rot = ma.levs[lev].shps[i].rot
				shp.sol = ma.levs[lev].shps[i].sol
				
				maSetRotateShape(shp)
				if shp.sol then coSetSpriteAlpha(shp.spr, 127)
				
				ma.shps.insert(shp)
				
			endif
				
		next
				
		maResetShapes()
		ma.time = ma.levs[lev].time // Get time from 1.txt, need to save it.
		
	else
		
		ma.time = MA_MIN_TIME
		ma.score = 0
		
	endif
		
endfunction

// ---------------------------
// Create a shape.
// As x, y, with w, h, and col.
//
function maCreateShape(shp ref as Shape, typ as integer, x as integer, y as integer)
	
	local count as integer
	
	shp.typ = typ
	shp.x = x
	shp.y = y
	shp.rot = 0
		
	shp.spr = CreateSprite(ma.typImg[typ])
	//SetSpriteScale(spr, 0.5, 0.5)
	SetSpritePositionByOffset(shp.spr, x * ma.s, y * ma.s)
	coSetSpriteColor(shp.spr, ma.typCol[typ])
	SetSpriteDepth(shp.spr, MA_DEPTH_SHAPE)
	maAddShape(shp)
			
endfunction

// ---------------------------
// Adds a custom shape.
//
function maAddShape(shp ref as Shape)

	local x as float
	local y as float
	local spr as integer
	local n as integer
	local i as integer
	
	spr = shp.spr
	
	if not spr
		exitfunction
	endif
	
	SetSpriteShape(spr, ma.shape)
	exitfunction
	
	if not spr
		exitfunction
	endif
	
	x = 0 -getspriteoffsetx(spr) // getspritex(spr)
	y = 0 -getspriteoffsety(spr)
	
	if shp.typ = MA_SHP_J
	
		ClearSpriteShapes(spr)
		
		n = 7
		i = 0
		
		SetSpriteShapeChain(spr, n, i, 0, x, y, 0)
		inc x, ma.s
		inc i
		
		SetSpriteShapeChain(spr, n, i, 0, x, y, 0)
		inc y, ma.s
		inc i
		
		SetSpriteShapeChain(spr, n, i, 0, x, y, 0)
		inc x, ma.s * 2
		inc i
		
		SetSpriteShapeChain(spr, n, i, 0, x, y, 0)
		inc y, ma.s
		inc i
		
		SetSpriteShapeChain(spr, n, i, 0, x, y, 0)
		dec x, ma.s * 3
		inc i
		
		SetSpriteShapeChain(spr, n, i, 0, x, y, 0)
		dec y, ma.s * 2
		inc i
		
		SetSpriteShapeChain(spr, n, i, 1, x, y, 0)
		
	endif
	
endfunction

// ---------------------------
// Delete a shape.
//
function maDeleteShape(shp ref as Shape)

	if shp.spr
		
		deletesprite(shp.spr)
		shp.spr = 0

	endif
		
endfunction

// ---------------------------
// Clone a shape.
//
function maCloneShape(shp ref as Shape, clone ref as Shape)
	
	maDeleteShape(clone)
	
	clone.typ = shp.typ
	clone.x = shp.x
	clone.y = shp.y
	clone.rot = shp.rot
	
	clone.spr = CloneSprite(shp.spr)
	SetSpriteScale(clone.spr, 1, 1) // 0.5, 0.5)
	SetSpriteDepth(clone.spr, MA_DEPTH_SHAPE)
	//SetSpriteShape(clone.spr, ma.shape)
	maAddShape(clone)
	SetSpriteVisible(clone.spr, false)
	
endfunction

// ---------------------------
// Update depending on state.
//
function maUpdate()
	
	if ma.helpact
		maUpdateHelp()
	elseif ma.state = MA_STATE_TITLE
		maUpdateTitle()
	elseif ma.state = MA_STATE_EDIT
		maUpdateEdit()
	elseif ma.state = MA_STATE_EDITTIME
		maUpdateEditTime()
	elseif ma.state = MA_STATE_PLAY
		maUpdatePlay()
	elseif ma.state = MA_STATE_WAIT
		maUpdateWait()
	elseif ma.state = MA_STATE_SUCC or ma.state = MA_STATE_FAIL
		maUpdateSuccFail()
	endif
	
endfunction

// ---------------------------
// Update title state.
//
function maUpdateTitle()
	
	local i as integer
	
	inUpdate()
	
	if in.ptrPressed
		
		if buButPressed(ma.backBut)
			
			end

		elseif buButPressed(ma.helpBut)
			
			mahelp(true, 0)
			
		elseif buButPressed(ma.editBut)
			
			if ma.editAct
				ma.editAct = false
			else 
				ma.editAct = true
			endif
			
			matitle()
			
		else
			
			if ma.editAct
				
				if buButPressed(ma.addBut)
					
					ma.lev = ma.levs.length + 1 // New level.
					maEdit()
					
				else
						
					for i = 0 to ma.levButs.length
						
						if buButPressed(ma.levButs[i])
							
							if i > MA_BUILTIN_LEVELS - 1
							
								ma.lev = i
								maEdit()
								
							endif
							
						endif
					next
					
				endif
				
			else
				 
				for i = 0 to ma.levButs.length
					if buButPressed(ma.levButs[i])
						
						ma.lev = i
						maPlay()
						
					endif
				next
			
			endif
			
		endif
		
	endif

endfunction

// ---------------------------
// Update edit state.
//
function maUpdateEdit()
	
	inUpdate()
	
	if in.ptrPressed	
		
		if buButPressed(ma.backBut)

			maEditCleanup()			
			maTitle()
			
		elseif buButPressed(ma.helpBut)
			
			maEditCleanup()
			maHelp(true, 0)
			
		elseif buButPressed(ma.startBut)
			
			maDeleteShape(ma.selShp)
			ma.selTyp = 0
			maDrawButtons()
			
			if ma.phys
				maStop()
			else 
				maStart()
			endif
			
		elseif buButPressed(ma.timeBut)
			
			maEditCleanup()
			maEditTime()
			
		elseif buButPressed(ma.saveBut)
			
			maEditCleanup()
			maSaveLevel()
			
		elseif maSelectShape() = -1
			
			maDropShape()
			
		endif
		
	else
		
		maHoverCell()
		
	endif

endfunction

// ---------------------------
// Edit clean up.
//
function maEditCleanup()
	
	maStop()
	maDeleteShape(ma.selShp)
	ma.selTyp = 0
	ma.selShp.typ = MA_SHP_X
	maDrawButtons()

endfunction

// ---------------------------
// Edit time.
//
function maEditTime()
	
	if not ma.editTime
		
		ma.editTime = CreateEditBox()
		SetEditBoxSize(ma.editTime, GetSpriteWidth(ma.timeBut.bg) - ma.s * 2, GetSpriteHeight(ma.timebut.bg))
		SetEditBoxPosition(ma.editTime, getspritex(ma.timeBut.bg) + ma.s * 2, getspritey(ma.timeBut.bg) + ma.s - ma.gap * 2)
		SetEditBoxFont(ma.editTime, 0)
		SetEditBoxTextSize(ma.editTime, 48)
		SetEditBoxInputType(ma.edittime, 1)
		SetEditBoxDepth(ma.editTime, MA_DEPTH_EDITBOX)
		
		ma.edittitle = coCreateText("Edit time" + chr(10) + "Esc or Enter", ma.font, 24)
		SetTextAlignment(ma.edittitle, 2)
		SetTextPosition(ma.edittitle, geteditboxx(ma.edittime) - ma.gap, geteditboxy(ma.edittime) - ma.gap)
		
	endif

	ma.state = MA_STATE_EDITTIME
	SetEditBoxText(ma.editTime, str(ma.time))
	SetEditBoxVisible(ma.edittime, true)
	SetEditBoxFocus(ma.editTime, true)
	SetTextVisible(ma.edittitle, true)
		
endfunction

// ---------------------------
// Update play state.
//
function maUpdatePlay()

	inUpdate()
	
	if in.ptrPressed	
		if buButPressed(ma.backBut)
			maTitle()
		elseif buButPressed(ma.helpBut)
			maHelp(true, 0)
		elseif buButPressed(ma.retryBut)
			maNext()
		elseif buButPressed(ma.startBut)
			maStart()
		elseif maSelectShape() = -1
			maDropShape()
		endif
	else
		maHoverCell()
	endif

endfunction

// ---------------------------
// Update help state.
//
function maUpdateHelp()
	
	inUpdate()
	
	if in.ptrPressed	
		if buButPressed(ma.helpprevBut)
			maHelp(true, -1)
		elseif buButPressed(ma.helpnextBut)
			maHelp(true, 1)
		elseif buButPressed(ma.helpquitBut)
			maHelp(false, 0)
		endif
	endif
	
endfunction

// ---------------------------
// Update wait state.
//
function maUpdateWait()

	local t as integer
	local i as integer
	local lev as integer
	local rect as Rect
	local x as float
	local y as float
	local ox as float
	local oy as float
	local spr as integer
	
	inUpdate()
	
	if in.ptrPressed	
		if buButPressed(ma.backBut)
			maTitle()
		endif
	endif
	
	t = GetMilliseconds()
	ma.time = ma.levs[ma.lev].time - (t - ma.starttime) 
	if ma.time < 0 then ma.time = 0
	
	//if ma.time = 0
		
		lev = ma.lev
		
		for i = 0 to ma.shps.length
			
			if ma.shps[i].spr
				
				x = GetSpriteXByOffset(ma.shps[i].spr)
				y = GetSpriteYByOffset(ma.shps[i].spr)
				ox = GetSpriteOffsetX(ma.shps[i].spr)
				oy = GetSpriteOffsetY(ma.shps[i].spr)
				
				if mod(ma.shps[i].rot, 2) <> 0
					
					t = ox
					ox = oy
					oy = t
					
				endif
				
				rect.x = (ma.ox + ma.shps[i].x) * ma.s + ox - ma.s / 2
				rect.y = (ma.oy + ma.shps[i].y) * ma.s + oy - ma.s / 2
				rect.w = ma.s
				rect.h = ma.s
			
			/*
				log("x=" + str(x) + ", y=" + str(y) + ", rx=" + str(rect.x) + ", ry=" + str(rect.y) + ", rw=" + str(rect.w) + ", rh=" + str(rect.h))
				
				spr = createsprite(co.pixImg)
				SetSpriteScale(spr, 10, 10)
				coSetSpriteColor(spr, co.pink[3])
				SetSpritePositionByOffset(spr, x, y)
	
				spr = createsprite(co.pixImg)
				SetSpriteScale(spr, 10, 10)
				coSetSpriteColor(spr, co.blue[3])
				SetSpritePositionByOffset(spr, rect.x, rect.y)
				
				spr = createsprite(co.pixImg)
				SetSpriteScale(spr, 10, 10)
				coSetSpriteColor(spr, co.green[3])
				SetSpritePositionByOffset(spr, rect.x + rect.w, rect.y + rect.h)
			*/
			
				// Check.
				if not coPointWithinRect2(x, y, rect)
					
					if not ma.failtime
						
						ma.failtime = ma.time
						//log("failtime=" + str(ma.failtime))

					endif
		
					if ma.time = 0
						
						//log("T=0, fail")
						ma.phys = false
						maShowPhysics() // Stop physics.
						ma.state = MA_STATE_FAIL
						exit
						
					endif
								
				endif
				
			endif
			
		next
	
	if ma.time = 0
		
		if ma.state <> MA_STATE_FAIL
			
			ma.state = MA_STATE_SUCC
			ma.score = ma.score + ma.levs[ma.lev].time
			
			if ma.score > ma.bestscore
				
				ma.bestscore = ma.score
				maSaveScore()
				
			endif
			
		endif
		
	endif
		
		//log("state=" + str(ma.state))
		
	//endif

	maDrawScores()
				
endfunction

// ---------------------------
// Update succ/fail state.
//
function maUpdateSuccFail()

	maDialog(true)
		
	inUpdate()
	
	if in.ptrPressed	
		if buButPressed(ma.backBut)
			maTitle()
		elseif buButPressed(ma.nextBut)
			maNext()
		endif
	endif

endfunction

// ---------------------------
// Show the help
// vis shows/activates or not.
// Start restarted help.
//
function maHelp(vis as integer, delta as integer)
	
	local x as integer
	local y as integer
	local m as integer
	local s as string
	
	x = 5
	y = 5
	m = 0
	
	if ma.state = MA_STATE_TITLE
		m = MA_TITLE_HELP_MAX
	elseif ma.state = MA_STATE_EDIT
		m = MA_EDIT_HELP_MAX
	elseif ma.state = MA_STATE_PLAY
		m = MA_PLAY_HELP_MAX
	endif

	if delta = 0
		
		ma.helpidx = 0
		
	else
		 
		inc ma.helpidx, delta

		if ma.state = MA_STATE_TITLE
			if ma.helpidx > m
				ma.helpidx = 0
			elseif ma.helpidx < 0
				ma.helpIdx = m - 1
			endif	
		elseif ma.state = MA_STATE_EDIT
			if ma.helpidx > m
				ma.helpidx = 0
			elseif ma.helpidx < 0
				ma.helpIdx = m - 1
			endif
		elseif ma.state = MA_STATE_PLAY
			if ma.helpidx > m
				ma.helpidx = 0
			elseif ma.helpidx < 0
				ma.helpIdx = m - 1
			endif			
		endif
		
	endif

	if vis
		
		ma.helpact = true
				
		if not ma.help
			
			ma.help = createsprite(co.pixImg)
			SetSpriteScale(ma.help, ma.s * 6, ma.s * 5)
			coSetSpriteColor(ma.help, co.grey[4])
			coSetSpriteColor(ma.help, co.yellow[7])
			SetSpriteDepth(ma.help, MA_DEPTH_DIALOG)
			
			ma.helpTx = coCreateText("", ma.font, ma.dirsfont)
			SetTextAlignment(ma.helpTx, 1)
			SetTextDepth(ma.helpTx, MA_DEPTH_DTX)
			SetTextMaxWidth(ma.helpTx, GetSpriteWidth(ma.help) - ma.gap * 4)
			coSetTextColor(ma.helptx, co.grey[8])
		
			buCreateBut(ma.helpprevbut, ma.sbutImg, ma.previmg)
			coSetSpriteColor(ma.helpprevbut.bg, co.yellow[9])
			buSetButScale(ma.helpprevBut, 0.5, 0.5)

			buCreateBut(ma.helpnextbut, ma.sbutImg, ma.nextimg)
			coSetSpriteColor(ma.helpnextbut.bg, co.yellow[9])
			buSetButScale(ma.helpnextBut, 0.5, 0.5)

			buCreateBut(ma.helpquitbut, ma.sbutImg, ma.cancelimg)
			coSetSpriteColor(ma.helpquitbut.bg, co.yellow[9])
			buSetButScale(ma.helpquitBut, 0.5, 0.5)
			
		endif
		
	else 
		
		ma.helpact = false
	
	endif
	
	if vis
		
		SetSpriteVisible(ma.help, true)
		SetTextVisible(ma.helpTx, true)
		buSetButVis(ma.helpprevbut, true)
		buSetButVis(ma.helpnextbut, true)
		buSetButVis(ma.helpquitbut, true)
		
	elseif ma.help 

		SetSpriteVisible(ma.help, false)
		SetTextVisible(ma.helpTx, false)
		buSetButVis(ma.helpprevbut, false)
		buSetButVis(ma.helpnextbut, false)
		buSetButVis(ma.helpquitbut, false)
		
	endif
		
	if vis
	
		if ma.state = MA_STATE_TITLE
			
			s = str(ma.helpIdx + 1) + "/" + str(m + 1) + chr(10)
			
			if ma.helpIdx = 0
				
				x = 1
				y = 1
				s = s + "When the pencil button is grey, you are in play mode." + chr(10) + "Press a grey level number below to play."
			
			elseif ma.helpIdx = 1
				
				x = 1
				y = 1
				s = s + "Press the pencil button to toggle between play and edit modes."
				 							
			elseif ma.helpIdx = 2
				
				x = 1
				y = 1
				s = s + "When the pencil button is blue, you are in edit mode." + chr(10) + "Press a blue level number below to edit the level."

			elseif ma.helpIdx = 3

				x = 1
				y = 1
				s = s + "In edit mode, press the Add button to create a new level." + chr(10) + "Press <- to exit the game."
							
			endif
	
		elseif ma.state = MA_STATE_EDIT
			
			s = str(ma.helpIdx + 1) + "/" + str(m + 1) + chr(10)
			
			if ma.helpIdx = 0
				
				x = 5
				y = 1
				s = s + "Press and release a shape button to select a shape (the button will turn blue). If you want to rotate the shape, press an already selected shape button again."
		
			elseif ma.helpIdx = 1
				
				x = 5
				y = 1
				s = s + "Move the pointer to move the selected shape over the board to where you want it, then press to place it on the board."
		
			elseif ma.helpIdx = 2
				
				x = 3
				y = 1
				s = s + "Press the X button then click on a shape on the board to delete."

			elseif ma.helpIdx = 3

				x = 11
				y = 1
				s = s + "Press the -/+ button, then click on a shape to toggle hide/show." + chr(10) + "Transparent shapes (in the editor) are what player needs to place when playing."
							
			elseif ma.helpIdx = 4

				x = 13
				y = 1
				s = s + "Press the Time button to set the time limit for the level. You can edit the value and pressed ENTER. Press ESC to not change."
							
			elseif ma.helpIdx = 5

				x = 13
				y = 1
				s = s + "Press the play (>) button to test the level. You should aim for the balance of the level to not fall within the time limit. To reset testing, press stop."

			elseif ma.helpIdx = 6

				x = 1
				y = 1
				s = s + "Press the save button to save the level. The saved level will now be shown in the title screen."
							
			endif
	
		elseif ma.state = MA_STATE_PLAY
			
			s = str(ma.helpIdx + 1) + "/" + str(m + 1) + chr(10)

			if ma.helpIdx = 0
				
				x = 1
				y = 1
				s = s + "The level will show a structure, you must place the remaining shapes on the board and see if you can keep it balanced!"
						
			elseif ma.helpIdx = 1
				
				x = 5
				y = 1
				s = s + "Some shape buttons (red, green, blue, yellow) will show a number, this is how many of that shape you need to place on the board."
			
			elseif ma.helpIdx = 2
				
				x = 5
				y = 1
				s = s + "Press and release a shape button to select a shape (the button will turn blue). If you want to rotate the shape, press an already selected shape button again."
			
			elseif ma.helpIdx = 3
				
				x = 7
				y = 1
				s = s + "Move the pointer to move the selected shape over the board to where you want it, then press to place it on the board."

			elseif ma.helpIdx = 4
				
				x = 1
				y = 1
				s = s + "If you make a mistake placing a shape, press the retry button to restart the level."


			elseif ma.helpIdx = 5
				
				x = 13
				y = 1
				s = s + "Once all required shapes are in place, press the play button to test your layout."

			elseif ma.helpIdx = 6
				
				x = 11
				y = 1
				s = s + "If the structure remains balanced for the time limit, you will win the level."
			
			endif
					
		endif

		SetSpritePosition(ma.help, (ma.ox + x) * ma.s, (ma.oy + y) * ma.s)	
		SetTextString(ma.helptx, s)
		SetTextPosition(ma.helptx, GetSpriteXByOffset(ma.help), getspritey(ma.help))
		buSetButPos(ma.helpnextbut, GetSpriteXByOffset(ma.help), getspritey(ma.help) + GetSpriteHeight(ma.help) - GetSpriteHeight(ma.helpnextbut.bg) / 2 - ma.gap)
		buSetButPos(ma.helpprevbut, GetSpriteXByOffset(ma.helpnextbut.bg) - GetSpriteWidth(ma.helpnextbut.bg) - ma.gap * 2, GetSpriteYByOffset(ma.helpnextbut.bg)) 
		buSetButPos(ma.helpquitbut, GetSpriteXByOffset(ma.helpnextbut.bg) + GetSpriteWidth(ma.helpnextbut.bg) + ma.gap * 2, GetSpriteYByOffset(ma.helpnextbut.bg)) 
											
	endif
	
endfunction

// ---------------------------
// Show the dialog
//
function maDialog(vis as integer)
	
	local r as integer
	local score as integer
	local time as integer
	local lev as integer
		
	if vis
		
		if not ma.dlog
			
			ma.dlog = createsprite(co.pixImg)
			SetSpriteScale(ma.dlog, ma.s * 10, ma.s * 5)
			coSetSpriteColor(ma.dlog, co.grey[4])
			SetSpritePosition(ma.dlog, (ma.ox + 5) * ma.s, (ma.oy + 7) * ma.s)
			SetSpriteDepth(ma.dlog, MA_DEPTH_DIALOG)
			
			ma.dialogTx = coCreateText("", ma.font, ma.dirsfont)
			SetTextAlignment(ma.dialogTx, 1)
			SetTextDepth(ma.dialogTx, MA_DEPTH_DTX)
		
			buCreateBut(ma.nextbut, ma.sbutImg, 0)
			coSetSpriteColor(ma.nextbut.bg, ma.butCol)
			buSetButScale(ma.nextBut, 0.5, 0.5)
	
		endif
		
		lev = ma.lev
				
		if ma.state = MA_STATE_SUCC
						
			if lev < ma.levs.length // Still more levels?
				
				coSetTextColor(ma.dialogTx, co.green[7])
				score = ma.levs[lev].time
				SetTextString(ma.dialogTx, "You balanced and won the level!" + chr(10) + "Points received: " + str(score) + chr(10) + chr(10) + "Move on to the next level...")
				buSetButFg(ma.nextBut, ma.nextImg)
				buSetButScale(ma.nextBut, 0.5, 0.5)

			else // No more levels.
				
				coSetTextColor(ma.dialogTx, co.green[7])
				score = ma.levs[lev].time
				SetTextString(ma.dialogTx, "You balanced and won this level!" + chr(10) + "Points received: " + str(score) + chr(10) + chr(10) + "You've completed the game!")
				buSetButFg(ma.nextBut, ma.stopImg)
				buSetButScale(ma.nextBut, 0.5, 0.5)
				
			endif

		elseif ma.state = MA_STATE_FAIL
			
			time = ma.levs[ma.lev].time - ma.failtime
			coSetTextColor(ma.dialogTx, co.red[7])
			SetTextString(ma.dialogTx, "You balanced for " + str(time) + " milliseconds, " + chr(10) + " not enough to win the level." + chr(10) + chr(10) + "Try again?")
			buSetButFg(ma.nextBut, ma.retryImg)
			buSetButScale(ma.nextBut, 0.5, 0.5)
			
		endif
							
		SetSpriteVisible(ma.dlog, true)
		SetTextPosition(ma.dialogTx, co.w / 2, getspritey(ma.dlog) + GetTextTotalHeight(ma.dialogTx) / 2)
		SetTextVisible(ma.dialogTx, true)
		buSetButPos(ma.nextBut, co.w / 2, getspritey(ma.dlog) + GetSpriteHeight(ma.dlog) - GetSpriteHeight(ma.nextBut.bg))
		buSetButVis(ma.nextBut, true)
		
	elseif ma.dlog
		
		SetSpriteVisible(ma.dlog, false)
		SetTextVisible(ma.dialogTx, false)
		buSetButVis(ma.nextBut, false)

	endif
		
endfunction

// ---------------------------
// Next level.
//
function maNext()

	local lev as integer
	
	if ma.state = MA_STATE_PLAY // Retry
		
		maPlay()

	elseif ma.state = MA_STATE_FAIL
		
		maPlay()
		
	elseif ma.state = MA_STATE_SUCC
		
		lev = ma.lev
		
		if ma.lev < ma.levs.length // Still more level.	
			
			inc ma.lev	
			maPlay()
			
		else
			 
			maTitle()
			
		endif
		
	endif
	
endfunction

// ---------------------------
// Stop physics.
//
function maStop()
	
	ma.phys = false
	buSetButFg(ma.startBut, ma.playImg)
	buSetButAct(ma.startBut, true)
	buUpdateButPos(ma.startBut)
	maShowPhysics()
	maResetShapes()
		
endfunction

// ---------------------------
// Check if start is prssed.
//
function maStart()
					
	ma.phys = true
	buSetButFg(ma.startBut, ma.stopImg)
	
	if ma.state = MA_STATE_PLAY
		
		buSetButAct(ma.helpBut, false)
		buSetButAct(ma.retryBut, false)
		buSetButAct(ma.startBut, false) // Make it not accessible.
		ma.state = MA_STATE_WAIT
		maDrawScores()
		ma.starttime = GetMilliseconds()
		ma.failtime = 0
		
	endif
	
	buUpdateButPos(ma.startBut)
	maShowPhysics()

endfunction

// ---------------------------
// Turn on or off physics.
//
function maShowPhysics()
	
	local i as integer
	
	if ma.phys
				
		for i = 0 to ma.shps.length
			
			if ma.shps[i].spr
				
				SetSpritePhysicsGravityScale(ma.shps[i].spr, 10)
				SetSpritePhysicsOn(ma.shps[i].spr, 2)
				
			endif

		next
		
	else
				
		for i = 0 to ma.shps.length
			if ma.shps[i].spr
				SetSpritePhysicsOff(ma.shps[i].spr)
			endif
		next
			
	endif
	
endfunction

// ---------------------------
// Check if selecting a shape at the top.
//
function maSelectShape()
	
	local i as integer
	local shp as Shape
	local idx as integer
	local butok as integer
	local count as integer
	local y as float
		
	idx = -1
	
	for i = 0 to ma.buts.length
	
		if buButPressed(ma.buts[i])
					
			butok = false
			
			if ma.state = MA_STATE_PLAY
					
				if i > 0 and i < MA_SHP_S
					if ma.buts[i].txs.length > -1
						butok = true
					endif
				endif
				
			elseif ma.state = MA_STATE_EDIT
				 
				butok = true
				
				if i = 0 or i = MA_SHP_S
					if ma.selShp.spr
						maDeleteShape(ma.selShp)
					endif
				endif
				
			endif
			
			if butok

				if i = ma.selTyp
					if i > 0 and i < MA_SHP_S			
						maRotateShape(ma.sels[ma.selTyp])					
					endif
				else
					ma.selTyp = i
				endif
					
				if ma.selTyp and ma.selTyp < MA_SHP_S
					maCloneShape(ma.sels[ma.selTyp], ma.selShp)
				endif
				
				idx = i
				
			endif
			
			exit
			
		endif
					
	next
	
	if idx = -1
		
		y = getspritey(ma.cells[0].spr)
				
		if in.ptry < y
			idx = -2
		endif
		
	endif
		
	maDrawButtons()	
		
endfunction idx

// ---------------------------
// Rotate selected shape.
//
function maRotateShape(shp ref as Shape)
	
	if shp.typ = MA_SHP_I or shp.typ = MA_SHP_S or shp.typ = MA_SHP_Z
		if shp.rot = 0
			shp.rot = 1	
		elseif shp.rot = 1
			shp.rot = 0			
		endif
	elseif shp.typ = MA_SHP_J or shp.typ = MA_SHP_L or shp.typ = MA_SHP_T
		if shp.rot = 0
			shp.rot = 1	
		elseif shp.rot = 1
			shp.rot = 2
		elseif shp.rot = 2
			shp.rot = 3
		elseif shp.rot = 3
			shp.rot = 0			
		endif	
	elseif shp.typ = MA_SHP_O // Hack for Sol
		if shp.rot = 0
			shp.rot = 1	
		elseif shp.rot = 1
			shp.rot = 0			
		endif
	endif
	
	maSetRotateShape(shp)
		
endfunction

// ---------------------------
// Rotate selected shape.
//
function maSetRotateShape(shp ref as Shape)
	
	if shp.spr	
		if shp.rot = 0		
			SetSpriteAngle(shp.spr, 0)
		elseif shp.rot = 1		
			SetSpriteAngle(shp.spr, 90)		
		elseif shp.rot = 2		
			SetSpriteAngle(shp.spr, 180)		
		elseif shp.rot = 3	
			SetSpriteAngle(shp.spr, 270)		
		endif
	endif
						
endfunction

// ---------------------------
// Drop a dragged shape.
//
function maDropShape()
	
	local i as integer
	local shpdel as integer
	
	if ma.selTyp and ma.selTyp < MA_SHP_S // Not deleting.
				
		if ma.state = MA_STATE_EDIT
			
			ma.selShp.sol = false
			ma.shps.insert(ma.selShp)
			
		elseif ma.state = MA_STATE_PLAY
			
			ma.selShp.sol = true
			ma.shps.insert(ma.selShp)
			
		endif
				
		// Clear for next.
		ma.selShp.typ = MA_SHP_X
		ma.selShp.spr = 0
		ma.selTyp = MA_SHP_X
		maSelectShape()
				
	elseif ma.selTyp = MA_SHP_S
		
		if ma.state = MA_STATE_EDIT
						
			for i = 0 to ma.shps.length
				//if coGetSpriteHitTest4(ma.shps[i].spr, in.ptrx, in.ptry, 0)
				if GetSpriteHitTest(ma.shps[i].spr, in.ptrx, in.ptry)
					
					if ma.shps[i].sol
						
						coSetSpriteAlpha(ma.shps[i].spr, 255)
						ma.shps[i].sol = false
						
					else 
						
						coSetSpriteAlpha(ma.shps[i].spr, 127)
						ma.shps[i].sol = true
						
					endif
					
					exit
					
				endif
			next
			
		endif

	elseif ma.state = MA_STATE_EDIT // Delete?

		for i = 0 to ma.shps.length
						
			//if coGetSpriteHitTest4(ma.shps[i].spr, in.ptrx, in.ptry, 0)
			if GetSpriteHitTest(ma.shps[i].spr, in.ptrx, in.ptry)
				
				maDeleteShape(ma.shps[i])
				ma.shps.remove(i)
				maSelectShape()

				exit
				
			endif
			
		next
		
	endif
	
endfunction

// ---------------------------
// Get the cell that has x and y.
//
function maGetCell(x as integer, y as integer)
	
	local idx as integer
	local i as integer
	
	idx = -1
	
	for i = 0 to ma.cells.length
		if ma.cells[i].x = x and ma.cells[i].y = y
			
			idx = i
			exit
			
		endif	
	next
	
endfunction idx

// ---------------------------
// Get the cell that is selected by mouse pos.
//
function maFindCell(x as float, y as float)
	
	local idx as integer
	local i as integer
	
	idx = -1
	
	for i = 0 to ma.cells.length
				
		if coPointWithinRect2(x, y, ma.cells[i].rect)
			
			idx = i
			exit
			
		endif
		
	next
	
endfunction idx

// ---------------------------
// Reposition all shapes.
//
function maResetShapes()
	
	local i as integer
	
	for i = 0 to ma.shps.length
		
		maSetRotateShape(ma.shps[i])
		maPosShape(ma.shps[i])
		
	next

endfunction

// ---------------------------
// Position the shape to it's x, y position.
//
function maPosShape(shp ref as Shape)
	
	local w as float
	local h as float

	if shp.spr
		
		if shp.rot = 1 or shp.rot = 3	
			
			h = getspritewidth(shp.spr)
			w = GetSpriteHeight(shp.spr)
			SetSpritePositionByOffset(shp.spr, (ma.ox + shp.x) * ma.s + w / 2, (ma.oy + shp.y) * ma.s + h / 2)	
			
		else	
					
			w = getspritewidth(shp.spr)
			h = GetSpriteHeight(shp.spr)
			SetSpritePositionByOffset(shp.spr, (ma.ox + shp.x) * ma.s + w / 2, (ma.oy + shp.y) * ma.s + h / 2)	
			
		endif
		
	endif
	
endfunction

// ---------------------------
// Hover over a cell, with a shape color.
//
function maHoverCell()
	
	local idx as integer
	local loc as Location
	local x as float
	local y as float
	local y0 as float
	local y1 as float
		
	if ma.selTyp and ma.selTyp < MA_SHP_S
		
		x = in.ptrX
		y = in.ptrY
				
		if y < ma.gridy0
			y = ma.gridy0	
		elseif y > ma.gridy1
			y = ma.gridy1
		endif
		
		idx = maFindCell(x, y)
						
		if idx > -1
			
			loc.x = ma.cells[idx].x
			loc.y = ma.cells[idx].y
			
			if not maShapesOverlap(ma.selShp, loc)	
				
				maForceFitShape(ma.selShp, loc)			
				ma.selShp.x = loc.x
				ma.selShp.y = loc.y
				
			endif

			maPosShape(ma.selShp)
			SetSpriteVisible(ma.selShp.spr, true)
							
		else
			
			SetSpriteVisible(ma.selShp.spr, false)
			
		endif
		
	endif
			
endfunction

// ---------------------------
// Check if the shape can fit here.
//
function maForceFitShape(shp ref as Shape, loc ref as Location)

	local n as integer
		
	if shp.typ = MA_SHP_I
		n = 3
	elseif shp.typ = MA_SHP_J
		n = 2
	elseif shp.typ = MA_SHP_L
		n = 1
	elseif shp.typ = MA_SHP_O
		n = 0
	endif
	
	if shp.rot = 1 or shp.rot = 3
				
		if loc.x < 0
			loc.x = 0
		elseif loc.x >= ma.w - 1
			loc.x = ma.w - 1
		endif
		
		if loc.y < 0
			loc.y = 0
		elseif loc.y + n >= ma.h - 2
			loc.y = ma.h - 2 - n
		endif
		
	else
		
		if loc.x < 0
			loc.x = 0
		elseif loc.x + n >= ma.w - 1
			loc.x = ma.w - 1 - n
		endif
				
		if loc.y < 0
			loc.y = 0
		elseif loc.y >= ma.h - 1
			loc.y = ma.h - 1
		endif
		
	endif
	
endfunction
// ---------------------------
// See if there's a shape here.
//
function maShapesOverlap(shp ref as Shape, loc ref as Location)
	
	local i as integer
	local j as integer
	local k as integer
	local cx as integer
	local cy as integer
	local dx as integer
	local dy as integer
	local m as integer
	local n as integer
	local ret as integer
	local mx as integer
	local my as integer
	local nx as integer
	local ny as integer
	
	ret = false
	
	for i = 0 to ma.shps.length
				
		if shp.typ = MA_SHP_I
			n = 3
		elseif shp.typ = MA_SHP_J
			n = 2
		elseif shp.typ = MA_SHP_L
			n = 1
		elseif shp.typ = MA_SHP_O
			n = 0
		endif

		if ma.shps[i].typ = MA_SHP_I
			m = 3
		elseif ma.shps[i].typ = MA_SHP_J
			m = 2
		elseif ma.shps[i].typ = MA_SHP_L
			m = 1
		elseif ma.shps[i].typ = MA_SHP_O
			m = 0
		endif

		if shp.rot = 1 or shp.rot = 3
			
			nx = 0
			ny = 1
			
		else 
			
			nx = 1
			ny = 0
			
		endif

		if ma.shps[i].rot = 1 or ma.shps[i].rot = 3
			
			mx = 0
			my = 1
			
		else 
			
			mx = 1
			my = 0
			
		endif
				
		for j = 0 to n // Scan through passed shape positions.
			
			cx = loc.x + (nx * j)
			cy = loc.y + (ny * j)

			for k = 0 to m // Scan through shape in list positions.
			
				dx = ma.shps[i].x + (mx * k)
				dy = ma.shps[i].y + (my * k) 

				if dx = cx and dy = cy // Shape positions in the same place?
					
					ret = true
					exit
					
				endif
								
			next
			
			if ret
				exit
			endif
			
		next 
		
		if ret
			exit
		endif
		
	next 
	
endfunction ret

// ---------------------------
// END.
//
