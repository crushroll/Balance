// --------------------------
// Maintain the stability of the structure.
//

#option_explicit

#include "common.agc"
#include "input.agc"
#include "but.agc"

#constant MA_STATE_NONE = 0
#constant MA_STATE_EDIT = 1
#constant MA_STATE_PLAY = 2

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
#constant MA_SHP_B = 8 // Bar, static.

type Cell
	
	x as integer
	y as integer
	rect as Rect
	spr as integer
	tx as integer
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
	shps as StoredShape[] // String shape.
	
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
	buts as Button[]
	sels as Shape[] // The selector shapes.
	//selSpr as integer
	selTyp as integer // The selected typ.
	selShp as Shape // The selected sprite to drop based on typ.
	selY as float
	phys as integer
	readpath as string
	writepath as string
	levs as Level[]
	smallbutImg as integer
	startBut as Button
	saveBut as Button
	
endtype

global ma as Main

maInit()
//maCreateLevel(1)
//SetPhysicsDebugOn()

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

	
	ma.s = 64
	ma.w = 20
	ma.h = 20
	ma.ox = 0
	ma.oy = 3
	ma.pw = (ma.w + ma.ox) * ma.s
	ma.ph = (ma.h + ma.oy) * ma.s
	
	setVirtualResolution(ma.pw, ma.ph)
	h = GetDeviceHeight()
	h = h * 0.95
	w = h / (ma.ph / ma.pw)
	SetWindowSize(w, h, false)
	//SetWindowPosition(GetDeviceWidth() / 2 - GetWindowWidth() / 2, GetDeviceHeight() / 2 - GetWindowHeight() / 2)
	
	ma.readPath = GetReadPath()
	ma.writePath = GetWritePath()
	log("readpath=" + ma.readpath + ", writepath=" + ma.writepath)
	
	maLoadLevels()
	
	coInit()

	ma.typNam = [ "X", "I", "J", "L", "O", "S", "T", "Z", "B" ]
	
	ma.typCol.insert(makecolor(255, 255, 255))
	ma.typCol.insert(makecolor(0, 255, 255))
	ma.typCol.insert(makecolor(0, 0, 255))
	ma.typCol.insert(makecolor(255, 127, 0))
	ma.typCol.insert(makecolor(255, 255, 0))
	ma.typCol.insert(makecolor(0, 255, 0))
	ma.typCol.insert(makecolor(255, 0, 255))
	ma.typCol.insert(makecolor(255, 0, 0))
	ma.typCol.insert(makecolor(255, 255, 255))
	
	for i = 0 to ma.typNam.length
		ma.typImg[i] = loadimage("gfx/" + ma.typNam[i] + ".png")		
	next

	ma.tickImg = loadimage("gfx/tick.png")
	ma.playImg = loadimage("gfx/play.png")
	ma.stopImg = loadimage("gfx/stop.png")
	ma.smallButImg = loadimage("gfx/smallbut.png")
	
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
	maCreateShape(shp, MA_SHP_B, 0, 0)
	ma.sels.insert(shp)
	
	maGrid()

	x = ma.s + 8
	y = (ma.s * ma.oy) / 2
	w = ma.s * 2
	h = ma.s * 2
	
	ma.selY = y + ma.s
	
	for i = 0 to ma.sels.length
				
		buCreateBut(but, ma.smallButImg, 0)
		but.fg = ma.sels[i].spr
		buSetButScale(but, 0.9, 0.9)
		
		if i = MA_SHP_X or i = MA_SHP_O
			buFitFg(but, 0, 32)
		else
			buFitFg(but, 0, 0)
		endif
		
		coSetSpriteColor(but.bg, co.grey[5])
		buSetButPos(but, x, y)
		ma.buts.insert(but)

		inc x, ma.s * 1.9
		
	next
	
	buCreateBut(ma.startBut, ma.smallButImg, ma.playImg)
	coSetSpriteColor(ma.startBut.bg, co.grey[5])
	buSetButPos(ma.startBut, co.w - GetSpriteWidth(ma.startBut.bg) / 2 - 16, y)

	buCreateBut(ma.saveBut, ma.smallButImg, 0)
	coSetSpriteColor(ma.saveBut.bg, co.grey[7])
	buSetButScale(ma.saveBut, 0.25, 0)
	buSetButTx(ma.saveBut, DIR_C, "S", 0, 32)
	buSetButPos(ma.saveBut, co.w - ma.s / 4, ma.s / 4)

	//ma.selSpr = createsprite(ma.tickImg)
	//SetSpriteScale(ma.selSpr, 0.5, 0.5)
	//SetSpriteVisible(ma.selSpr, false)
	
	ma.selTyp = 0
	ma.selShp.typ = MA_SHP_X
	ma.phys = false
	
	maEdit(true)
	maSelectShape()
		
	ma.state = MA_STATE_EDIT
	
endfunction

// ---------------------------
// Load levels.
//
function maLoadLevels()
	
	local file as string
	local s as string
	local lev as Level
	
	setfolder("levs")
	
	file = GetFirstFile()
	ma.levs.length = -1
	
	while file <> ""
		
		log("file=" + file)
		
		s = maLoadLevel(file)
		lev.fromjson(s)
		ma.levs.insert(lev)
		
		file = getnextfile()
		
	endwhile
	
	setfolder("/media")
	
endfunction

// ---------------------------
// Load a level.
//
function maLoadLevel(file as string)
	
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
	
	maLoadLevels()

	lev.nbr = 0
	
	for i = 0 to ma.levs.length
		if ma.levs[i].nbr > lev.nbr
			lev.nbr = ma.levs[i].nbr
		endif
	next
	
	inc lev.nbr
	
	for i = 0 to ma.shps.length
		
		ss.typ = ma.shps[i].typ
		ss.x = ma.shps[i].x
		ss.y = ma.shps[i].y
		ss.rot = ma.shps[i].rot
		
		lev.shps.insert(ss)
		
	next
		
	SetFolder("levs")
	
	name = str(lev.nbr) + ".txt"
	fh = OpenToWrite(name)
	s = lev.tojson()
	s = ReplaceString(s, chr(10), " ", -1)
	s = ReplaceString(s, " ", "", -1)
	WriteLine(fh, s)
	CloseFile(fh)
	
	setfolder("/media")
	
	ma.levs.insert(lev) // Add to the list.

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
	
	col1 = makecolor(47, 47, 47) // co.grey[8]
	col2 = makecolor(31, 31, 31) // co.grey[9]
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
// Make edit sprites visible.
//
function maEdit(vis as integer)
	
	local i as integer
	
	for i = 0 to ma.buts.length	
		//SetSpriteVisible(ma.buts[i].spr, vis)
		buSetButVis(ma.buts[i], vis)
	next
	
	//SetSpritePositionByOffset(ma.selSpr, GetSpriteXByOffset(ma.buts[ma.selTyp].spr), GetSpriteYByOffset(ma.buts[ma.selTyp].spr))
	//SetSpriteVisible(ma.selSpr, true)

endfunction

// ---------------------------
// Create a level.
//
function maCreateLevel(nbr as integer)
		
	local shp as Shape
	
	maClean()
	
	if nbr = 1
							
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
	SetSpriteScale(spr, 0.5, 0.5)
	SetSpritePositionByOffset(spr, x * ma.s, y * ma.s)
	coSetSpriteColor(spr, ma.typCol[typ])
	SetSpriteDepth(spr, MA_DEPTH_SHAPE)
	SetSpriteShape(spr, 3)
		
	//setSpritePhysicsGravityScale(spr, 10)
	//SetSpritePhysicsOn(spr, 2)
	
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
	SetSpriteShape(clone.spr, 3)
	//SetSpritePhysicsGravityScale(clone.spr, 10)
	//SetSpritePhysicsOff(clone.spr)

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
	
	if ma.state = MA_STATE_EDIT
		maUpdateEdit()
	elseif ma.state = MA_STATE_PLAY
		maUpdatePlay()
	endif
	
endfunction

// ---------------------------
// Update edit state.
//
function maUpdateEdit()
	
	inUpdate()
	
	if in.ptrPressed
		
		if buButPressed(ma.startBut)
			maStart()
		elseif buButPressed(ma.saveBut)
			maSaveLevel()
		elseif maSelectShape() = -1
			maDropShape()
		endif

	elseif in.ptrDown
	elseif in.ptrReleased
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
			
			SetSpritePhysicsGravityScale(ma.shps[i].spr, 10)
			
			if ma.shps[i].typ = MA_SHP_B
				SetSpritePhysicsOn(ma.shps[i].spr, 1)
			else
				SetSpritePhysicsOn(ma.shps[i].spr, 2)
			endif

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
		
		//if coPointWithinRect2(in.ptrX, in.ptrY, ma.buts[i].rect)
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
	
	//SetSpritePositionByOffset(ma.selSpr, GetSpriteXByOffset(ma.sels[ma.selTyp].spr), ma.selY)
	//SetSpriteVisible(ma.selSpr, true)
	
	for i = 0 to ma.buts.length
		coSetSpriteColor(ma.buts[i].bg, co.grey[5])
	next
	
	coSetSpriteColor(ma.buts[ma.selTyp].bg, co.blue[5])
		
endfunction idx

// ---------------------------
// Rotate selected shape.
//
function maRotateShape(shp ref as Shape)
	
	if shp.typ = MA_SHP_I or shp.typ = MA_SHP_J or shp.typ = MA_SHP_S or shp.typ = MA_SHP_Z
		
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
	SetSpriteShape(shp.spr, 3)
		
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
		ma.selShp.typ = MA_SHP_X
		ma.selShp.spr = 0
		ma.selTyp = 0
		
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
// Update play state.
//
function maUpdatePlay()

endfunction

// ---------------------------
// END.
//
