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
	//tx as integer
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
	
endtype

type StoredShape
	
	typ as integer
	x as integer
	y as integer
	rot as integer
	
endtype

type Level
	
	nbr as integer
	time as integer
	shps as StoredShape[] // String shape.
	parts as integer[MA_SHP_Z] // Space for the number of each shape avail to unbuild the level.
	
endtype

type LevelState
	
	nbr as integer
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
	typNam as string[8]
	typCol as integer[]
	typImg as integer[8]
	tickImg as integer
	playImg as integer
	stopImg as integer
	backImg as integer
	editImg as integer
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
	butCol as integer
	selButCol as integer
	lev as integer
	time as integer
	score as integer
	shape as integer
	
endtype

global ma as Main

maInit()
maTitle()
//maPlay()
SetPhysicsDebugOn()

do
	
	maUpdate()
	maCheckColl()
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
	ma.w = 20
	ma.h = 20
	ma.ox = 0
	ma.oy = 3
	ma.pw = (ma.w + ma.ox) * ma.s
	ma.ph = (ma.h + ma.oy) * ma.s
	ma.shape = 3
	
	setVirtualResolution(ma.pw, ma.ph)
	h = GetDeviceHeight()
	h = h * 0.95
	w = h / (ma.ph / ma.pw)
	SetWindowSize(w, h, false)
	//SetWindowPosition(GetDeviceWidth() / 2 - GetWindowWidth() / 2, GetDeviceHeight() / 2 - GetWindowHeight() / 2)
	
	coInit()

	ma.readPath = GetReadPath()
	ma.writePath = GetWritePath()
	//message("readpath=" + ma.readpath + ", writepath=" + ma.writepath)
	
	maLoadLevels()
	
	ma.typNam = [ "X", "I", "J", "L", "O", "S", "T", "Z" ]
	
	ma.typCol.insert(makecolor(255, 255, 255))
	ma.typCol.insert(makecolor(0, 255, 255))
	ma.typCol.insert(makecolor(0, 0, 255))
	ma.typCol.insert(makecolor(255, 127, 0))
	ma.typCol.insert(makecolor(255, 255, 0))
	ma.typCol.insert(makecolor(0, 255, 0))
	ma.typCol.insert(makecolor(255, 0, 255))
	ma.typCol.insert(makecolor(255, 0, 0))
	
	for i = 0 to ma.typNam.length
		ma.typImg[i] = loadimage("shps/" + ma.typNam[i] + ".png")		
	next

	ma.tickImg = loadimage("gfx/tick.png")
	ma.playImg = loadimage("gfx/play.png")
	ma.stopImg = loadimage("gfx/stop.png")
	ma.backImg = loadimage("gfx/back.png")
	ma.editImg = loadimage("gfx/edit.png")
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
	maCreateShape(shp, MA_SHP_T, 0, 0)
	ma.sels.insert(shp)
	maCreateShape(shp, MA_SHP_Z, 0, 0)
	ma.sels.insert(shp)
	
	maGrid()

	y = (ma.s * ma.oy) / 2
	gap = 8
	
	ma.selY = y + ma.s
	ma.butCol = makecolor(127, 127, 127)
	ma.selButCol = co.blue[5]
	
	for i = 0 to ma.sels.length
				
		buCreateBut(but, ma.sButImg, 0)
		if i = 0 then x = GetSpriteWidth(but.bg) / 2 + gap
		but.fg = ma.sels[i].spr
		buSetButScale(but, 0.7, 0.7)
		
		if i = MA_SHP_X or i = MA_SHP_O
			buFitFg(but, 0, 32)
		else
			buFitFg(but, 0, 0)
		endif
		
		coSetSpriteColor(but.bg, ma.butCol)
		buSetButPos(but, x, y)
		ma.buts.insert(but)

		inc x, GetSpriteWidth(but.bg) + gap
		
	next
	
	y = y - ma.s + gap * 2
	sc = 0.3
	buCreateBut(ma.levBut, ma.xlButImg, 0)
	inc x, ma.s + gap * 5
	buSetButScale(ma.levBut, sc, sc)
	coSetSpriteColor(ma.levBut.bg, ma.butCol)
	buSetButTx(ma.levBut, DIR_C, "Level: 1", 0, 40)
	buSetButPos(ma.levBut, x, y)
	inc y, GetSpriteHeight(ma.levBut.bg) + gap
	buSetButVis(ma.levBut, false)

	buCreateBut(ma.timeBut, ma.xlButImg, 0)
	buSetButScale(ma.timeBut, sc, sc)
	coSetSpriteColor(ma.timeBut.bg, ma.butCol)
	buSetButTx(ma.timeBut, DIR_C, "Time: 30", 0, 40)
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

	y = (ma.s * ma.oy) / 2
	buCreateBut(ma.startBut, ma.sButImg, ma.playImg)
	coSetSpriteColor(ma.startBut.bg, ma.butCol)
	buSetButPos(ma.startBut, co.w - GetSpriteWidth(ma.startBut.bg) / 2 - gap * 4, y)

	buCreateBut(ma.saveBut, ma.sButImg, 0)
	coSetSpriteColor(ma.saveBut.bg, co.grey[7])
	buSetButScale(ma.saveBut, 0.25, 0)
	buSetButTx(ma.saveBut, DIR_C, "S", 0, 32)
	buSetButPos(ma.saveBut, co.w - ma.s / 4, ma.s / 4)
	buSetButVis(ma.saveBut, false)

	// Main menu.
		
	buCreateBut(ma.backBut, 0, ma.backImg)
	buSetButScale(ma.backBut, 0.5, 0.5)
	buSetButPos(ma.backBut, GetSpriteWidth(ma.backBut.fg) / 2, GetSpriteHeight(ma.backBut.fg) / 2)

	x = co.w / 2
	y = co.h / 8
	h = GetSpriteWidth(ma.startBut.bg)

	ma.title = coCreateText("Balance", 0, 200)
	SetTextAlignment(ma.title, 1)
	SetTextPosition(ma.title, x, y)
	inc y, GetTextTotalHeight(ma.title) + gap + h / 2

	buCreateBut(ma.editBut, ma.sButImg, ma.editImg)
	//buSetButTx(ma.editBut, DIR_C, "Edit", 0, 0)
	coSetSpriteColor(ma.editBut.bg, ma.butCol)
	buSetButPos(ma.editBut, x, y)
	inc y, h + gap * 3
	
	w = 4
	x = co.w / 2 - (w * h + (w - 1) * gap) / 2 + h / 2
	xx = x

	for i = 0 to ma.levs.length
	
		buCreateBut(but, ma.sButImg, 0)
		buSetButTx(but, DIR_C, str(ma.levs[i].nbr), 0, 0)
		coSetSpriteColor(but.bg, ma.butCol)
		buSetButPos(but, x, y)
		ma.levButs.insert(but)
		
		if w > 0
			
			inc x, h + gap
			dec w
			
		else
			 
			inc y, h + gap
			x = xx
			w = 4
			
		endif
		
	next
	
	ma.selTyp = 0
	ma.selShp.typ = MA_SHP_X
	ma.phys = false
		
endfunction

// ---------------------------
// Load levels.
//
function maLoadLevels()
	
	local file as string
	local s as string
	local lev as Level
	local levState as LevelState
	local a as integer
	
	setfolder("levs")
	
	file = GetFirstFile()
	ma.levs.length = -1
	
	while file <> ""
		
		log("lev file=" + file)
		a = asc(left(file, 1))
		
		if a >= 48 and a <= 57 // If starts with a digit, it's a level.

			s = maLoadFile(file)
			lev.fromjson(s)
			ma.levs.insertsorted(lev)
			
		endif
		
		file = getnextfile()
		
	endwhile
	
	setfolder("/media")

	setfolder("states")
	
	file = GetFirstFile()
	ma.levstates.length = -1
	
	while file <> ""
		
		log("state file=" + file)
		
		s = maLoadFile(file)
		levstate.fromjson(s)
		ma.levstates.insertsorted(levstate)
		
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
	
	local lev as Level
	local ss as StoredShape
	local nbr as integer
	local name as string
	local i as integer
	local fh as integer
	local s as string
		
	for i = 0 to ma.shps.length
		
		ss.typ = ma.shps[i].typ
		ss.x = ma.shps[i].x
		ss.y = ma.shps[i].y
		ss.rot = ma.shps[i].rot
		
		lev.shps.insert(ss)
		
	next
	
	for i = 0 to lev.parts.length
		lev.parts[i] = 0
	next
		
	SetFolder("levs")
	
	name = "newlevel.txt"
	fh = OpenToWrite(name)
	s = lev.tojson()
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
	
	lev.nbr = ma.lev
	lev.time = ma.time
	lev.score = ma.score
	lev.dt = GetCurrentDate() + " " + GetCurrentTime()
	
	name = str(ma.levs[ma.lev].nbr) + ".txt"
	
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
		if ma.shps[i].spr
			deletesprite(ma.shps[i].spr)
		endif
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
	
	maclean()
	
	for i = 0 to ma.buts.length	
		buSetButVis(ma.buts[i], false)
	next

	buSetButVis(ma.levBut, false)
	buSetButVis(ma.timeBut, false)
	buSetButVis(ma.scoreBut, false)	
	buSetButVis(ma.startBut, false)
	buSetButVis(ma.saveBut, false)
	
	for i = 0 to ma.cells.length
		SetSpriteVisible(ma.cells[i].spr, false)
	next
	
	buSetButVis(ma.backBut, true)
	buSetButVis(ma.editBut, true)

	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], true)
	next
	
	SetTextVisible(ma.title, true)
	
	ma.state = MA_STATE_TITLE

endfunction

// ---------------------------
// Make edit sprites visible.
//
function maEdit()
	
	local i as integer

	for i = 0 to ma.buts.length	
		buSetButVis(ma.buts[i], true)
	next

	buSetButVis(ma.levBut, false)
	buSetButVis(ma.timeBut, false)
	buSetButVis(ma.scoreBut, false)	
	buSetButVis(ma.startBut, true)
	buSetButVis(ma.saveBut, true)
	
	maSelectShape()

	for i = 0 to ma.cells.length
		SetSpriteVisible(ma.cells[i].spr, true)
	next
	
	buSetButVis(ma.backBut, true)
	buSetButVis(ma.editBut, false)

	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], false)
	next

	SetTextVisible(ma.title, false)

	ma.state = MA_STATE_EDIT

endfunction

// ---------------------------
// Play mode.
//
function maPlay()
	
	local i as integer
	
	for i = 0 to ma.buts.length	
		buSetButVis(ma.buts[i], true)			
	next
	
	buSetButVis(ma.levBut, true)
	buSetButVis(ma.timeBut, true)
	buSetButVis(ma.scoreBut, true)
	buSetButVis(ma.startBut, true)
	buSetButVis(ma.saveBut, false)

	for i = 0 to ma.cells.length
		SetSpriteVisible(ma.cells[i].spr, true)
	next
	
	buSetButVis(ma.backBut, true)
	buSetButVis(ma.editBut, false)
	
	for i = 0 to ma.levbuts.length	
		buSetButVis(ma.levbuts[i], false)
	next

	SetTextVisible(ma.title, false)
		
	maDrawLevel()
	maDrawScores()

	ma.phys = false
	ma.state = MA_STATE_PLAY

endfunction

// ---------------------------
// Draw the score buttons.
//
function maDrawScores()
	
	buSetButTx(ma.levBut, DIR_C, "Level: " + str(ma.lev), -1, -1)
	buSetButTx(ma.timeBut, DIR_C, "Time: " + str(ma.time), -1, -1)
	buSetButTx(ma.scoreBut, DIR_C, "Score: " + str(ma.score), -1, -1)

endfunction

// ---------------------------
// Draw the current level.
//
function maDrawLevel()
			
	local shp as Shape
	local i as integer
	local lev as integer
	
	maClean()
	
	if ma.lev <= ma.levs.length + 1
		
		lev = ma.lev - 1
		
		for i = 0 to ma.levs[lev].shps.length
			
			maCreateShape(shp, ma.levs[lev].shps[i].typ, ma.levs[lev].shps[i].x, ma.levs[lev].shps[i].y)
			shp.rot = ma.levs[lev].shps[i].rot
			maSetRotateShape(shp)
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
	SetSpriteShape(spr, ma.shape)
		
	shp.spr = spr

endfunction

// ---------------------------
// Delete a shape.
//
function maDeleteShape(shp ref as Shape)

	if shp.spr
		deletesprite(shp.spr)
	endif
	
	shp.typ = MA_SHP_X // Delete.
	shp.spr = 0
	
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
	SetSpriteShape(clone.spr, ma.shape)
	SetSpriteVisible(clone.spr, false)
	
endfunction

// ---------------------------
// Check if there's been a collsion between a sprite and the ground.
//
function maCheckColl()

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
			maEdit()
		else
			for i = 0 to ma.levButs.length
				if buButPressed(ma.levButs[i])
					
					ma.lev = ma.levs[i].nbr
					maPlay()
					
				endif
			next
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
			
			//SetSpritePhysicsVelocity(ma.shps[i].spr, 0, 0)
			//SetSpritePhysicsGravityScale(ma.shps[i].spr, 10)
			SetSpritePhysicsOn(ma.shps[i].spr, 2)

		next
		
	else
				
		for i = 0 to ma.shps.length
			SetSpritePhysicsOff(ma.shps[i].spr)
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
	
	idx = -1
	
	for i = 0 to ma.buts.length
		
		if buButPressed(ma.buts[i])
			
			if i = ma.selTyp
				if i > 0				
					maRotateShape(ma.sels[ma.selTyp])					
				endif
			else
				ma.selTyp = i
			endif
				
			if ma.selTyp
				maCloneShape(ma.sels[ma.selTyp], ma.selShp)
			endif
			
			idx = i
			
			exit
			
		endif
		
	next
		
	for i = 0 to ma.buts.length
		coSetSpriteColor(ma.buts[i].bg, ma.butCol)
	next
	
	coSetSpriteColor(ma.buts[ma.selTyp].bg, ma.selButCol)
		
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
	endif
	
	maSetRotateShape(shp)
	SetSpriteShape(shp.spr, ma.shape)
		
endfunction

// ---------------------------
// Rotate selected shape.
//
function maSetRotateShape(shp ref as Shape)
	
	if shp.rot = 0		
		SetSpriteAngle(shp.spr, 0)
	elseif shp.rot = 1		
		SetSpriteAngle(shp.spr, 90)		
	elseif shp.rot = 2		
		SetSpriteAngle(shp.spr, 180)		
	elseif shp.rot = 3	
		SetSpriteAngle(shp.spr, 270)		
	endif
						
endfunction

// ---------------------------
// Drop a dragged shape.
//
function maDropShape()
	
	local i as integer
	
	if ma.selTyp // Not deleting.
		
		ma.shps.insert(ma.selShp)
		
		// Clear for next.
		//ma.selShp.typ = MA_SHP_X
		ma.selShp.spr = 0
		maCloneShape(ma.sels[ma.selTyp], ma.selShp)
				
	else // Delete?
		
		for i = 0 to ma.shps.length
			if coGetSpriteHitTest4(ma.shps[i].spr, in.ptrX, in.ptrY, 0)
				
				maDeleteShape(ma.shps[i])
				ma.shps.remove(i)
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

	if shp.rot = 1 or shp.rot = 3	
		
		h = getspritewidth(shp.spr)
		w = GetSpriteHeight(shp.spr)
		SetSpritePositionByOffset(shp.spr, (ma.ox + shp.x) * ma.s + w / 2, (ma.oy + shp.y) * ma.s + h / 2)	
		
	else	
				
		w = getspritewidth(shp.spr)
		h = GetSpriteHeight(shp.spr)
		SetSpritePositionByOffset(shp.spr, (ma.ox + shp.x) * ma.s + w / 2, (ma.oy + shp.y) * ma.s + h / 2)	
		
	endif
	
endfunction

// ---------------------------
// Hover over a cell, with a shape color.
//
function maHoverCell()
	
	local idx as integer
	//local w as float
	//local h as float
	
	if ma.selTyp
		
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
