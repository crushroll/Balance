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

#constant MA_DEPTH_DTX = 1600
#constant MA_DEPTH_DIALOG = 1700
#constant MA_DEPTH_SHAPE = 1800
#constant MA_DEPTH_SEL = 1900
#constant MA_DEPTH_EDIT = 2000

#constant MA_SHP_X = 0
#constant MA_SHP_I = 1
#constant MA_SHP_J = 2
#constant MA_SHP_L = 3
#constant MA_SHP_O = 4
#constant MA_SHP_S = 5
#constant MA_SHP_T = 6
#constant MA_SHP_Z = 7

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
	addBut as Button
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
	local gap as float
	local sc as float
	
	ma.s = 64
	ma.w = 21
	ma.h = 21
	ma.ox = 0
	ma.oy = 3
	ma.pw = (ma.w + ma.ox) * ma.s
	ma.ph = (ma.h + ma.oy) * ma.s
	ma.shape = 3
	ma.editAct = false
	
	setVirtualResolution(ma.pw, ma.ph)
	h = GetDeviceHeight()
	h = h * 0.95
	w = h / (ma.ph / ma.pw)
	SetWindowSize(w, h, false)
	//SetWindowPosition(GetDeviceWidth() / 2 - GetWindowWidth() / 2, GetDeviceHeight() / 2 - GetWindowHeight() / 2)
	
	coInit()

	ma.selCol1 = co.blue[5]
	ma.selCol2 = co.blue[7]
	ma.playCol1 = co.grey[5]
	ma.playCol2 = co.grey[7]

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
	gap = 8
	
	ma.selY = y + ma.s
	ma.butCol = makecolor(127, 127, 127)
	ma.selButCol = co.blue[5]
	
	for i = 0 to ma.sels.length
				
		buCreateBut(but, ma.sButImg, 0)
		if i = 0 then x = GetSpriteWidth(but.bg) / 2 + gap * 22
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

		inc x, GetSpriteWidth(but.bg) + gap
		
	next
	
	x = co.w - gap * 11
	y = (ma.s * ma.oy) / 2
	yy = y
	buCreateBut(ma.startBut, ma.sButImg, ma.playImg)
	coSetSpriteColor(ma.startBut.bg, ma.butCol)
	buSetButPos(ma.startBut, x, y)

	//y = y - ma.s + gap * 2
	
	sc = 0.3
	buCreateBut(ma.levBut, ma.xlButImg, 0)
	buSetButScale(ma.levBut, sc, sc)
	x = x - GetSpriteWidth(ma.startBut.bg) / 2 - GetSpriteWidth(ma.levBut.bg) / 2 - gap * 3
	y = y - GetSpriteHeight(ma.startBut.bg) / 2 + GetSpriteHeight(ma.levBut.bg) / 2
	coSetSpriteColor(ma.levBut.bg, ma.butCol)
	buSetButTx(ma.levBut, DIR_C, "Level: 1", 0, 40)
	buSetButPos(ma.levBut, x, y)
	inc y, GetSpriteHeight(ma.levBut.bg) + gap
	buSetButVis(ma.levBut, false)

	buCreateBut(ma.timeBut, ma.xlButImg, 0)
	buSetButScale(ma.timeBut, sc, sc)
	coSetSpriteColor(ma.timeBut.bg, ma.butCol)
	buSetButTx(ma.timeBut, DIR_C, "Time: 0", 0, 40)
	buSetButPos(ma.timeBut, x, y)
	inc y, GetSpriteHeight(ma.levBut.bg) + gap
	buSetButVis(ma.timeBut, false)

	buCreateBut(ma.scoreBut, ma.xlButImg, 0)
	buSetButScale(ma.scoreBut, sc, sc)
	coSetSpriteColor(ma.scoreBut.bg, ma.butCol)
	buSetButTx(ma.scoreBut, DIR_C, "Score: 0", 0, 40)
	buSetButPos(ma.scoreBut, x, y)
	inc y, GetSpriteHeight(ma.levBut.bg) + gap
	buSetButVis(ma.scoreBut, false)

	buCreateBut(ma.backBut, 0, ma.backImg)
	//buSetButScale(ma.backBut, 0.5, 0.5)
	buSetButPos(ma.backBut, GetSpriteWidth(ma.backBut.fg) / 2, GetSpriteHeight(ma.backBut.fg) / 2)

	buCreateBut(ma.saveBut, ma.sButImg, ma.saveImg)
	buSetButScale(ma.saveBut, 0.5, 0.5)
	coSetSpriteColor(ma.saveBut.bg, ma.butCol)
	buSetButPos(ma.saveBut, GetSpriteWidth(ma.saveBut.bg) / 2 + gap * 2, getspritey(ma.backBut.fg) + GetSpriteHeight(ma.backBut.fg) + gap * 5)
	buSetButVis(ma.saveBut, false)

	buCreateBut(ma.editBut, ma.sButImg, ma.editImg)
	buSetButScale(ma.editBut, 0.5, 0.5)
	coSetSpriteColor(ma.editBut.bg, ma.butCol)
	buSetButPos(ma.editBut, GetSpriteWidth(ma.editBut.bg) / 2 + gap * 2, getspritey(ma.backBut.fg) + GetSpriteHeight(ma.backBut.fg) + gap * 5)
	buSetButVis(ma.editBut, false)
	inc y, h + gap * 3

	// Main menu.
		
	x = co.w / 2
	y = yy
	h = GetSpriteWidth(ma.startBut.bg)

	ma.title = coCreateText("Balance", 0, 200)
	SetTextAlignment(ma.title, 1)
	SetTextPosition(ma.title, x, y - GetTextTotalHeight(ma.title) / 2)

	ma.selTyp = 0
	ma.selShp.typ = MA_SHP_X
	ma.phys = false
		
endfunction

function maTestWelds()

	local sprs as integer[]
	local spr as integer
	local x as float
	local y as float
	local i as integer
	
	y = 300
	
	for i = 0 to 3
		
		spr = createsprite(co.pixImg)
		SetSpriteScale(spr, ma.s, ma.s)
		SetSpritePosition(spr, 100, y)
		SetSpritePhysicsGravityScale(spr, 10)
		SetSpritePhysicsOn(spr, 2)
		
		if i > 1
			CreateWeldJoint(sprs[i - 1], spr, getspritex(spr), getspritey(spr) + GetSpriteHeight(spr) / 2, 0)
		endif
		
		sprs.insert(spr)
		inc y, GetSpriteHeight(spr)
				
	next
	
	x = 100
	
	for i = 0 to 3
		
		spr = createsprite(co.pixImg)
		SetSpriteScale(spr, ma.s, ma.s)
		SetSpritePosition(spr, x, 100)
		SetSpritePhysicsGravityScale(spr, 10)
		SetSpritePhysicsOn(spr, 2)
		
		if i > 1
			CreateWeldJoint(sprs[i - 1], spr, getspritex(spr), getspritey(spr) + GetSpriteHeight(spr) / 2, 0)
		endif
		
		sprs.insert(spr)
		inc x, GetSpriteWidth(spr)
				
	next
	
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
	
	setfolder("/media")
	setfolder("levs")

	ma.levs.length = -1
	
	file = GetFirstFile()

	while file <> ""
		
		pos = findstring(file, ".")
		nbr = val(mid(file, 1, pos - 1)) // sl.nbr
		
		for j = 0 to ma.levs.length
			log("existing level=" + str(j))
			if j = nbr
				continue // Ignore previously loaded levels to ensure we don't load twice.
			endif
		next
		
		log("folder=" + getfolder() + ", file=" + file)
		s = maLoadFile(file)
		sl.fromjson(s)
		
		lev.time = sl.time
		//lev.parts = sl.parts
		
		for i = 0 to sl.shps.length
			
			shp.typ = sl.shps[i].typ
			shp.x = sl.shps[i].x
			shp.y = sl.shps[i].y
			shp.rot = sl.shps[i].rot
			shp.sol = sl.shps[i].sol
			shp.phys = false
			lev.shps.insert(shp)
			
		next
		
		ma.levs.insertsorted(lev)
		
		file = getnextfile()
		
	endwhile
	
	setfolder("/media")
				
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
	
	fh = OpenToWrite(name)
	s = sl.tojson()
	s = ReplaceString(s, chr(10), " ", -1)
	s = ReplaceString(s, " ", "", -1)
	WriteLine(fh, s)
	CloseFile(fh)
	
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
	
	
	if ma.editAct
		
		col = ma.selCol1
		coSetSpriteColor(ma.editBut.bg, ma.selCol1)
		buSetButTx(ma.editBut, DIR_S, "Edit level", 0, 24)

	else 
		
		col = ma.playCol1
		coSetSpriteColor(ma.editBut.bg, ma.butCol)
		buSetButTx(ma.editBut, DIR_S, "Play level", 0, 24)
		
	endif

	buUpdateButPos(ma.editBut)
	
	maclean()
	magrid()
	maLoadLevels()
	
	for i = 0 to ma.levbuts.length
		buDeleteBut(ma.levbuts[i])
	next 
	
	ma.levbuts.length = -1
	
	count = ma.levs.length + 1 // for add
	w = count / 2
	h = w
	
	if w * h < count
		inc w, count - (w * h)
	endif
	
	xx = ma.ox + 10 - w / 2
	yy = ma.oy + 10 - h / 2
	x = xx
	y = yy
	ww = w

	for i = 0 to ma.levs.length
	
		buCreateBut(but, ma.sButImg, 0)
		buSetButTx(but, DIR_C, str(i + 1), 0, 0)
		sc = ma.s / GetSpriteWidth(but.bg)
		buSetButScale(but, sc, 0)
		coSetSpriteColor(but.bg, col)
		buSetButPos(but, x * ma.s + ma.s / 2, y * ma.s + ma.s / 2)
		ma.levButs.insert(but)
		
		dec ww
		
		if ww = 0
			
			inc y
			x = xx
			
		else
			 
			inc x
			
		endif
		
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
		
	next
	
	if not ma.addbut.bg
				
		buCreateBut(ma.addBut, ma.sButImg, ma.addImg)
		buSetButTx(ma.addBut, DIR_S, "Add level", 0, 0)
		sc = ma.s / GetSpriteWidth(ma.addBut.bg)
		buSetButScale(ma.addBut, sc, 0.5)
		
	endif

	coSetSpriteColor(ma.addBut.bg, col)
	
	if ma.levs.length > -1
		
		x = GetSpriteXByOffset(ma.levbuts[ma.levbuts.length].bg) + ma.s
		y = GetSpriteYByOffset(ma.levbuts[ma.levbuts.length].bg)
	
	else 
		
		x = xx
		y = xx
		
	endif

	buSetButPos(ma.addBut, x, y)
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

	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], true)
	next
	
	SetTextVisible(ma.title, true)
	
	maDialog(false)
	
	ma.state = MA_STATE_TITLE

endfunction

// ---------------------------
// Make edit sprites visible.
//
function maEdit()
	
	local i as integer

	buSetButVis(ma.levBut, false)
	buSetButVis(ma.timeBut, false)
	buSetButVis(ma.scoreBut, false)	
	buSetButVis(ma.startBut, true)
	buUpdateButPos(ma.startBut)
	
	buSetButVis(ma.backBut, true)
	buSetButVis(ma.saveBut, true)
	buSetButVis(ma.editBut, false)
	buSetButVis(ma.addBut, false)

	SetSpriteVisible(ma.base, true)
	SetSpritePhysicsOn(ma.base, 1)
	
	for i = 0 to ma.cells.length
		SetSpriteVisible(ma.cells[i].spr, true)
	next
	
	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], false)
	next

	SetTextVisible(ma.title, false)
	
	ma.state = MA_STATE_EDIT

	maDialog(false)
	maDrawButtons()
	maDrawLevel()
	maDrawScores()

endfunction

// ---------------------------
// Play mode.
//
function maPlay()
	
	local i as integer
			
	buSetButFg(ma.startBut, ma.playImg)

	buSetButVis(ma.levBut, true)
	buSetButVis(ma.timeBut, true)
	buSetButVis(ma.scoreBut, true)
	buSetButVis(ma.startBut, true)
	buUpdateButPos(ma.startBut)
	
	buSetButVis(ma.saveBut, false)
	buSetButVis(ma.editBut, false)
	buSetButVis(ma.addBut, false)

	SetSpriteVisible(ma.base, true)
	SetSpritePhysicsOn(ma.base, 1)

	for i = 0 to ma.cells.length
		SetSpriteVisible(ma.cells[i].spr, true)
	next
	
	buSetButVis(ma.backBut, true)
	buSetButVis(ma.editBut, false)
	
	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], false)
	next

	SetTextVisible(ma.title, false)	

	ma.phys = false
	ma.state = MA_STATE_PLAY

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
		
		for i = 0 to ma.shps.length
			if ma.shps[i].sol
				
				inc counts[ma.shps[i].typ]
				inc count
				
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
					
					buSetButTx(ma.buts[i], DIR_S, str(counts[i]), 0, 32)	
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

		buSetButAct(ma.startBut, true)
		buSetButVis(ma.startBut, true)
		
	endif
	
endfunction

// ---------------------------
// Draw the score buttons.
//
function maDrawScores()
	
	buSetButTx(ma.levBut, DIR_C, "Level: " + str(ma.lev), -1, -1)
	buSetButTx(ma.timeBut, DIR_C, "Time: " + str(ma.time), -1, -1)
	buSetButTx(ma.scoreBut, DIR_C, "Score: " + str(ma.score), -1, -1)
	
	if ma.state = MA_STATE_FAIL
		coSetSpriteColor(ma.scoreBut.bg, co.red[5])
	elseif ma.state = MA_STATE_SUCC
		coSetSpriteColor(ma.scoreBut.bg, co.green[5])
	else
		coSetSpriteColor(ma.scoreBut.bg, ma.butcol)
	endif
	
	if ma.state = MA_STATE_EDIT
		
		buSetButVis(ma.levBut, false)
		buSetButVis(ma.timeBut, true)
		buSetButVis(ma.scoreBut, false)
		
	else 
		
		buSetButVis(ma.levBut, true)
		buSetButVis(ma.timeBut, true)
		buSetButVis(ma.scoreBut, true)
		
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
					
				else
					
					shp.typ = ma.levs[lev].shps[i].typ
					shp.x = ma.levs[lev].shps[i].x
					shp.y = ma.levs[lev].shps[i].y
					shp.spr = 0
					
				endif
				
			elseif ma.state = MA_STATE_EDIT
				
				maCreateShape(shp, ma.levs[lev].shps[i].typ, ma.levs[lev].shps[i].x, ma.levs[lev].shps[i].y)
				
			endif
			
			shp.rot = ma.levs[lev].shps[i].rot
			shp.sol = ma.levs[lev].shps[i].sol

			if shp.spr
				
				maSetRotateShape(shp)
				if shp.sol then coSetSpriteAlpha(shp.spr, 127)
				
			endif
				
			ma.shps.insert(shp)
				
		next
				
		maResetShapes()
		ma.time = ma.levs[lev].time // Get time from 1.txt, need to save it.
		ma.score = 0
		
	endif
		
endfunction

// ---------------------------
// Create a shape.
// As x, y, with w, h, and col.
//
function maCreateShape(shp ref as Shape, typ as integer, x as integer, y as integer)
	
	local spr as integer
	local count as integer
	
	shp.typ = typ
	shp.x = x
	shp.y = y
	shp.rot = 0
		
	spr = CreateSprite(ma.typImg[typ])
	//SetSpriteScale(spr, 0.5, 0.5)
	SetSpritePositionByOffset(spr, x * ma.s, y * ma.s)
	coSetSpriteColor(spr, ma.typCol[typ])
	SetSpriteDepth(spr, MA_DEPTH_SHAPE)
	maAddShape(shp)
			
	shp.spr = spr

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
	
	if ma.state = MA_STATE_TITLE
		maUpdateTitle()
	elseif ma.state = MA_STATE_EDIT
		maUpdateEdit()
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
			
		elseif buButPressed(ma.editBut)
			
			if ma.editAct
				ma.editAct = false
			else 
				ma.editAct = true
			endif
			
			matitle()
			//maEdit()
			
		else
			
			if ma.editAct
				
				if buButPressed(ma.addBut)
					
					ma.lev = -1 // New level.
					maEdit()
					
				endif
						
				for i = 0 to ma.levButs.length
					if buButPressed(ma.levButs[i])
						
						ma.lev = i
						maEdit()
						
					endif
				next
				
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
			maTitle()
		elseif buButPressed(ma.startBut)
			maStart()
		elseif buButPressed(ma.saveBut)
			maSaveLevel()
		elseif maSelectShape() = -1
			maDropShape()
		endif
	else
		maHoverCell()
	endif

endfunction

// ---------------------------
// Update play state.
//
function maUpdatePlay()

	inUpdate()
	
	if in.ptrPressed	
		if buButPressed(ma.backBut)
			maTitle()
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
	
				// Check.
				if not coPointWithinRect2(x, y, rect)
					
					if not ma.failtime
						
						ma.failtime = ma.time
						log("failtime=" + str(ma.failtime))

					endif
		
					if ma.time = 0
						
						log("T=0, fail")
						ma.phys = false
						maShowPhysics() // Stop physics.
						ma.state = MA_STATE_FAIL
						
					endif
								
				endif
				
			endif
			
		next
	
	if ma.time = 0
		
		if ma.state <> MA_STATE_FAIL
			
			ma.state = MA_STATE_SUCC
			ma.score = ma.score + ma.levs[ma.lev].time
			
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
// Show the dialog
//
function maDialog(vis as integer)
	
	local r as integer
	local gap as float
	local score as integer
	local time as integer
	local lev as integer
	
	gap = 8
	
	if vis
		
		if not ma.dlog
			
			ma.dlog = createsprite(co.pixImg)
			SetSpriteScale(ma.dlog, co.w / 2, co.h / 4)
			coSetSpriteColor(ma.dlog, co.grey[4])
			SetSpritePositionByOffset(ma.dlog, co.w / 2, co.h / 2)
			SetSpriteDepth(ma.dlog, MA_DEPTH_DIALOG)
			
			ma.dialogTx = coCreateText("", 0, 48)
			SetTextAlignment(ma.dialogTx, 1)
			SetTextPosition(ma.dialogTx, co.w / 2, getspritey(ma.dlog) + gap)
			SetTextDepth(ma.dialogTx, MA_DEPTH_DTX)
		
			buCreateBut(ma.nextbut, ma.sbutImg, 0)
			coSetSpriteColor(ma.nextbut.bg, co.blue[8])
	
			lev = ma.lev
			
			if ma.state = MA_STATE_SUCC
				
				if lev < ma.levs.length // Still more levels?
					
					coSetTextColor(ma.dialogTx, co.green[8])
					score = ma.levs[lev].time
					SetTextString(ma.dialogTx, "You kept your balance!" + chr(10) + "You scored: " + str(score) + chr(10) + "Move on to the next level...")
					//buSetButTx(ma.nextBut, DIR_S, "Next level", 0, 48)
					buSetButFg(ma.nextBut, ma.nextImg)

				else 
					
					coSetTextColor(ma.dialogTx, co.green[8])
					score = ma.levs[lev].time
					SetTextString(ma.dialogTx, "You kept your balance!" + chr(10) + "You scored: " + str(score) + chr(10) + "You've completed the game!")
					//buSetButTx(ma.nextBut, DIR_S, "I'm done!", 0, 48)
					buSetButFg(ma.nextBut, ma.stopImg)
					
				endif

			elseif ma.state = MA_STATE_FAIL
				
				time = ma.levs[ma.lev].time - ma.failtime
				coSetTextColor(ma.dialogTx, co.red[8])
				SetTextString(ma.dialogTx, "You kept balance for" + chr(10) + str(time) + " milliseconds." + chr(10) + "But you failed, try again?")
				//buSetButTx(ma.nextBut, DIR_S, "Try again?", 0, 48)
				buSetButFg(ma.nextBut, ma.retryImg)
				
			endif
					
		endif
		
		SetSpriteVisible(ma.dlog, true)
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
	
	if ma.state = MA_STATE_FAIL
		
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
// Check if start is prssed.
//
function maStart()
					
	if ma.phys
		
		ma.phys = false
		buSetButFg(ma.startBut, ma.playImg)
		buUpdateButPos(ma.startBut)
		maShowPhysics()
		maResetShapes()
			
	else
		
		ma.phys = true
		buSetButFg(ma.startBut, ma.stopImg)
		
		if ma.state = MA_STATE_PLAY
			
			buSetButVis(ma.startBut, false) // Need to wait.
			ma.state = MA_STATE_WAIT
			maDrawScores()
			ma.starttime = GetMilliseconds()
			ma.failtime = 0
			
		endif
		
		buUpdateButPos(ma.startBut)
		maShowPhysics()

				
	endif

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
		
	idx = -1
	
	for i = 0 to ma.buts.length
	
		butok = true
		
		if ma.state = MA_STATE_PLAY	
			if ma.buts[i].txs.length = -1
				butok = false
			endif
		endif 
			
		if butok and buButPressed(ma.buts[i])
			
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
			
			exit
			
		endif
		
	next
	
	if idx = -1
		if in.ptry < ma.cells[0].y * ma.s
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
	//maAddShape(shp)
	//SetSpriteShape(shp.spr, ma.shape)
		
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
	local spr as integer
	
	if ma.selTyp and ma.selTyp < MA_SHP_S // Not deleting.
				
		if ma.state = MA_STATE_EDIT
			ma.shps.insert(ma.selShp)
		else
			for i = 0 to ma.shps.length
				if ma.shps[i].typ = ma.selTyp and ma.shps[i].sol
					
					ma.shps[i].spr = ma.selShp.spr
					ma.shps[i].sol = false
					
				endif
			next
			
		endif
		
		//dec ma.parts[ma.selTyp]
		
		// Clear for next.
		ma.selShp.typ = MA_SHP_X
		ma.selShp.spr = 0
		ma.selTyp = MA_SHP_X
		maSelectShape()
				
	elseif ma.selTyp = MA_SHP_S
		
		if ma.state = MA_STATE_EDIT
			
			spr = GetSpriteHit(in.ptrX, in.ptrY)
			
			for i = 0 to ma.shps.length
				if spr = ma.shps[i].spr
					
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

	else // Delete?

		spr = GetSpriteHit(in.ptrX, in.ptrY)
		
		for i = 0 to ma.shps.length
			
			if spr = ma.shps[i].spr
				
				maDeleteShape(ma.shps[i])
				ma.shps.remove(i)
				maSelectShape()

				exit
				
			endif
			
		next
		
	endif
	
endfunction

// ---------------------------
// Get the cell that is selected by mouse pos.
//
function maFindCell()
	
	local idx as integer
	local i as integer
	
	idx = -1
	
	for i = 0 to ma.cells.length
				
		if coPointWithinRect2(in.ptrX, in.ptrY, ma.cells[i].rect)
			
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
	//local w as float
	//local h as float
	
	if ma.selTyp and ma.selTyp < MA_SHP_S
		
		idx = maFindCell()
		
		if idx > -1
			
			ma.selShp.x = ma.cells[idx].x
			ma.selShp.y = ma.cells[idx].y

			maPosShape(ma.selShp)
			SetSpriteVisible(ma.selShp.spr, true)
			

		else
			
			SetSpriteVisible(ma.selShp.spr, false)
			
		endif
		
	endif
			
endfunction

// ---------------------------
// END.
//
