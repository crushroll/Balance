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
	buts as Shape[]
	selSpr as integer
	selTyp as integer // The selected typ.
	selShp as Shape // The selected sprite to drop based on typ.
	selY as float
	startSpr as integer
	startSpr2 as integer
	phys as integer
	
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
	local y as float
	local shp as Shape
	local xx as float
	local yy as float
	local w as float
	local h as float

	
	ma.s = 64
	ma.w = 20
	ma.h = 20
	ma.ox = 0
	ma.oy = 3
	ma.pw = (ma.w + ma.ox) * ma.s
	ma.ph = (ma.h + ma.oy) * ma.s
	
	setVirtualResolution(ma.pw, ma.ph)
	SetWindowSize(ma.pw, ma.ph, false)
	SetWindowPosition(GetDeviceWidth() / 2 - GetWindowWidth() / 2, GetDeviceHeight() / 2 - GetWindowHeight() / 2)
	
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
	
	maCreateShape(shp, MA_SHP_X, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_I, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_J, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_L, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_O, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_S, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_T, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_Z, 0, 0)
	ma.buts.insert(shp)
	maCreateShape(shp, MA_SHP_B, 0, 0)
	ma.buts.insert(shp)
	
	maGrid()

	x = ma.s
	y = (ma.s * ma.oy) / 2
	w = ma.s * 2
	h = ma.s * 2
	
	ma.selY = y + ma.s
	
	for i = 0 to ma.buts.length
				
		if i = MA_SHP_X
			SetSpriteScale(ma.buts[i].spr, 1, 1)	
		elseif i = MA_SHP_B	
			SetSpriteScale(ma.buts[i].spr, 0.1, 0.1)
		else	
			SetSpriteScale(ma.buts[i].spr, 0.5, 0.5)	
		endif
		
		SetSpriteDepth(ma.buts[i].spr, MA_DEPTH_SEL)
		SetSpriteVisible(ma.buts[i].spr, false)
		SetSpritePositionByOffset(ma.buts[i].spr, x, y)
		
		xx = GetSpriteXByOffset(ma.buts[i].spr)
		yy = GetSpriteYByOffset(ma.buts[i].spr)
				
		ma.buts[i].rect.x = xx - w / 2
		ma.buts[i].rect.y = yy - h / 2
		ma.buts[i].rect.w = w
		ma.buts[i].rect.h = h

		inc x, ma.s * 1.9
		
	next

	ma.tickImg = loadimage("gfx/tick.png")
	ma.playImg = loadimage("gfx/play.png")
	ma.stopImg = loadimage("gfx/stop.png")
	
	ma.startSpr = CreateSprite(co.pixImg)
	SetSpriteScale(ma.startSpr, ma.s * 2, ma.s * 2)
	SetSpriteDepth(ma.startSpr, MA_DEPTH_EDIT)
	coSetSpriteColor(ma.startSpr, co.grey[5])
	SetSpritePositionByOffset(ma.startSpr, co.w - GetSpriteWidth(ma.startSpr) / 4 * 3, y)

	ma.startSpr2 = CreateSprite(ma.playImg)
	//SetSpriteScale(ma.startSpr2, ma.s, ma.s)
	SetSpriteDepth(ma.startSpr2, MA_DEPTH_EDIT - 2)
	SetSpritePositionByOffset(ma.startSpr2, GetSpriteXByOffset(ma.startSpr), GetSpriteYByOffset(ma.startSpr))
	
	ma.selSpr = createsprite(ma.tickImg)
	SetSpriteScale(ma.selSpr, 0.5, 0.5)
	SetSpriteVisible(ma.selSpr, false)
	
	ma.selTyp = 0
	ma.selShp.typ = MA_SHP_X
	ma.phys = false
	
	maEdit(true)
	maSelectShape()
	
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
		
		if maStartPressed()
			// Do nothing.
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
function maStartPressed()
	
	local ret as integer
	
	ret = false
	
	if coGetSpriteHitTest4(ma.startSpr, in.ptrX, in.ptrY, 0)
		
		if ma.phys
			
			ma.phys = false
			SetSpriteImage(ma.startSpr2, ma.playImg)
			maShowPhysics()
			maResetShapes()
			ret = true
				
		else
			
			ma.phys = true
			SetSpriteImage(ma.startSpr2, ma.stopImg)
			maShowPhysics()

			ret = true

		endif
				
	endif

endfunction ret

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
		
		//if coGetSpriteHitTest4(ma.buts[i].spr, in.ptrX, in.ptrY, 0)
		if coPointWithinRect2(in.ptrX, in.ptrY, ma.buts[i].rect)
			
			if i = ma.selTyp
				if i > 0				
					maRotateShape(ma.buts[ma.selTyp])					
				endif
			else
				ma.selTyp = i
			endif
				
			if ma.selTyp
				maCloneShape(ma.buts[ma.selTyp], ma.selShp)
			endif
			
			idx = i
			
			exit
			
		endif
		
	next
	
	SetSpritePositionByOffset(ma.selSpr, GetSpriteXByOffset(ma.buts[ma.selTyp].spr), ma.selY)
		
endfunction idx

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
		
		SetSpriteShader(shp.spr, 3)

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
		
		SetSpriteShader(shp.spr, 3)
		
	endif
		
endfunction

// ---------------------------
// Drop a dragged shape.
//
function maDropShape()
	
	local i as integer
	
	if ma.selTyp // Not deleting.
		
		ma.shps.insert(ma.selShp)
		//SetSpriteVisible(ma.selShp.spr, false)
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
			
			/*
			if ma.selShp.rot = 1 or ma.selShp.rot = 3	
				
				h = getspritewidth(ma.selShp.spr)
				w = GetSpriteHeight(ma.selShp.spr)
				SetSpritePositionByOffset(ma.selShp.spr, (ma.ox + ma.selShp.x) * ma.s + w / 2, (ma.oy + ma.selShp.y) * ma.s + h / 2)	
				
			else	
						
				w = getspritewidth(ma.selShp.spr)
				h = GetSpriteHeight(ma.selShp.spr)
				SetSpritePositionByOffset(ma.selShp.spr, (ma.ox + ma.selShp.x) * ma.s + w / 2, (ma.oy + ma.selShp.y) * ma.s + h / 2)	
				
			endif
			*/
			
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
