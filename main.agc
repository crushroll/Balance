// --------------------------
// Maintain the stability of the structure.
//

#option_explicit

#include "common.agc"
#include "input.agc"

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
	
endtype

type Main
	
	state as integer
	w as integer
	h as integer
	s as float
	pw as float
	ph as float
	base as integer
	cells as Cell[]
	shps as Shape[]
	typNam as string[8]
	typCol as integer[]
	typImg as integer[8]
	tickImg as integer
	buts as Shape[]
	selSpr as integer
	selTyp as integer // The selected typ.
	selShp as Shape // The selected sprite to drop based on typ.
	
endtype

global ma as Main

maInit()
//maCreateLevel(1)
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
	local shp as Shape
	
	ma.s = 32
	ma.w = 22
	ma.h = 22
	ma.pw = ma.s * ma.w
	ma.ph = ma.s * ma.h
	setVirtualResolution(ma.pw, ma.ph)
	SetWindowSize(ma.pw * 2, ma.ph * 2, false)
	SetWindowPosition(GetDeviceWidth() / 2 - GetWindowWidth() / 2, GetDeviceHeight() / 2 - GetWindowHeight() / 2)
	
	coInit()

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
		ma.typImg[i] = loadimage("gfx/" + ma.typNam[i] + ".png")		
	next
	
	maCreateShape(shp, MA_SHP_X, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_I, 5, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_J, 10, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_L, 15, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_O, 0, 5)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_S, 5, 5)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_T, 10, 5)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_Z, 15, 5)
	ma.buts.insert(shp)
	
	maGrid()

	x = ma.s
	
	for i = 0 to ma.buts.length
		
		SetSpriteScale(ma.buts[i].spr, 0.25, 0.25)
		SetSpritePosition(ma.buts[i].spr, x, 0)
		inc x, GetSpriteWidth(ma.buts[i].spr) + ma.s
		SetSpriteDepth(ma.buts[i].spr, MA_DEPTH_SEL)
		SetSpriteVisible(ma.buts[i].spr, false)
		
	next
	
	ma.tickImg = loadimage("gfx/tick.png")
	ma.selSpr = createsprite(ma.tickImg)
	SetSpriteScale(ma.selSpr, 0.5, 0.5)
	SetSpriteVisible(ma.selSpr, false)
	
	ma.selTyp = 0
	ma.selShp.typ = MA_SHP_X
	
	maEdit(true)
	ma.state = MA_STATE_EDIT
	
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
	
	col1 = co.grey[8]
	col2 = co.grey[9]
	py = ma.s
	
	for y = 1 to ma.h - 2
		
		if mod(y, 2) = 0 then col = col2 else col = col1
		px = ma.s
			
		for x = 1 to ma.w - 2
			
			spr = CreateSprite(co.pixImg)
			setspritescale(spr, ma.s, ma.s)
			SetSpritePosition(spr, px, py)
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
		SetSpriteVisible(ma.buts[i].spr, vis)
	next
	
	SetSpritePositionByOffset(ma.selSpr, GetSpriteXByOffset(ma.buts[ma.selTyp].spr), GetSpriteYByOffset(ma.buts[ma.selTyp].spr))
	SetSpriteVisible(ma.selSpr, true)

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
	SetSpritePosition(spr, x * ma.s, y * ma.s)
	coSetSpriteColor(spr, ma.typCol[typ])
	SetSpriteDepth(spr, MA_DEPTH_SHAPE)
	SetSpriteShape(spr, 3)
	SetSpritePhysicsGravityScale(spr, 10)
	
	if not shp.phys
		SetSpritePhysicsOn(spr, 1)
	else
		SetSpritePhysicsOn(spr, 2)
	endif
	
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
	SetSpriteScale(clone.spr, 0.5, 0.5)
	SetSpriteDepth(clone.spr, MA_DEPTH_SHAPE)
	SetSpriteShape(clone.spr, 3)
	SetSpritePhysicsGravityScale(clone.spr, 10)

	if not clone.phys
		SetSpritePhysicsOn(clone.spr, 1)
	else
		SetSpritePhysicsOn(clone.spr, 2)
	endif

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
		maSelectShape()
	elseif in.ptrDown
	elseif in.ptrReleased
		maDropShape()
	else
		maHoverCell()
	endif

endfunction

// ---------------------------
// Check if selecting a shape at the top.
//
function maSelectShape()
	
	local i as integer
	local shp as Shape
	
	for i = 0 to ma.buts.length
		if coGetSpriteHitTest4(ma.buts[i].spr, in.ptrX, in.ptrY, 0)
			
			if i = ma.selTyp
				if i > 0				
					maRotateShape(ma.buts[ma.selTyp])					
				endif
			else
				ma.selTyp = i
			endif
			
			exit
			
		endif
	next
	
	SetSpritePositionByOffset(ma.selSpr, GetSpriteXByOffset(ma.buts[ma.selTyp].spr), GetSpriteYByOffset(ma.buts[ma.selTyp].spr))
	
	if ma.selTyp
		maCloneShape(ma.buts[ma.selTyp], ma.selShp)
	endif
	
endfunction

// ---------------------------
// Rotate selected shape.
//
function maRotateShape(shp ref as Shape)
	
	if shp.typ = MA_SHP_I or shp.typ = MA_SHP_J or shp.typ = MA_SHP_S or shp.typ = MA_SHP_Z
		
		if shp.rot = 0
			
			shp.rot = 1
			SetSpriteAngle(shp.spr, 90)
	
		elseif shp.rot = 1
			
			shp.rot = 0
			SetSpriteAngle(shp.spr, 0)
			
		endif

	elseif shp.typ = MA_SHP_J or shp.typ = MA_SHP_L or shp.typ = MA_SHP_T
		
		if shp.rot = 0
			
			shp.rot = 1
			SetSpriteAngle(shp.spr, 90)
	
		elseif shp.rot = 1
			
			shp.rot = 2
			SetSpriteAngle(shp.spr, 180)
			
		elseif shp.rot = 2
			
			shp.rot = 3
			SetSpriteAngle(shp.spr, 270)
			
		elseif shp.rot = 3
		
			shp.rot = 0
			SetSpriteAngle(shp.spr, 0)
			
		endif
		
	endif
		
endfunction

// ---------------------------
// Drop a dragged shape.
//
function maDropShape()
endfunction

// ---------------------------
// Get the cell that is selected by mouse pos.
//
function maFindCell()
	
	local idx as integer
	local i as integer
	
	idx = -1
	
	for i = 0 to ma.cells.length
		
		//log("px=" + str(in.ptrx) + ", py=" + str(in.ptry) + ", cell.x=" + str(ma.cells[i].rect.x) + ", celly=" + str(ma.cells[i].rect.y))
		
		if coPointWithinRect2(in.ptrX, in.ptrY, ma.cells[i].rect)
			
			idx = i
			exit
			
		endif
	next
	
endfunction idx

// ---------------------------
// Hover over a cell, with a shape color.
//
function maHoverCell()
	
	local idx as integer
	
	if ma.selTyp
		
		idx = maFindCell()
		
		if idx > -1
			
			if ma.selShp.rot = 1 or ma.selShp.rot = 3
				setSpritePosition(ma.selShp.spr, ma.cells[idx].x * ma.s - ma.s / 2, ma.cells[idx].y * ma.s - ma.s / 2)
			else
				setSpritePosition(ma.selShp.spr, ma.cells[idx].x * ma.s, ma.cells[idx].y * ma.s)
			endif
			
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
