// --------------------------
// Maintain the stability of the structure.
//

#option_explicit

#include "common.agc"
#include "input.agc"

#constant MA_STATE_NONE = 0
#constant MA_STATE_EDIT = 1
#constant MA_STATE_PLAY = 2

#constant MA_DEPTH_SHAPE = 1500
#constant MA_DEPTH_EDIT = 2000

type Cell
	
	x as integer
	y as integer
	rect as Rect
	spr as integer
	tx as integer
	col as integer
	
endtype

type Shape
	
	x as integer
	y as integer
	w as integer
	h as integer
	col as integer
	spr as integer
	
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
	currCellIdx as integer
	prevCellIdx as integer
	selCol as integer // The currently selected cell type.
	
endtype

global ma as Main

maInit()
//maCreateLevel(1)
maEditor()

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
			
	ma.s = 32
	ma.w = 20
	ma.h = 20
	ma.pw = ma.s * (ma.w + 2)
	ma.ph = ma.s * (ma.h + 2)
	setVirtualResolution(ma.pw, ma.ph)
	SetWindowSize(ma.pw * 2, ma.ph * 2, false)
	
	coInit()
	
	ma.prevCellIdx = -1
	ma.currCellIdx = -1
	ma.selCol = co.green[5]
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
function maEditor()
	
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
	
	for y = 0 to ma.h - 1
		
		if mod(y, 2) = 0 then col = col2 else col = col1
		px = ma.s
			
		for x = 0 to ma.w - 1
			
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
// Create a level.
//
function maCreateLevel(nbr as integer)
		
	maClean()
	
	if nbr = 1
			
		maCreateShape(1, ma.h - 4, ma.w - 2, 1, co.white, 1) // Base is always first.
		maCreateShape(ma.w / 2, ma.h / 2, 1, 5, co.blue[5], 2)
		maCreateShape(ma.w / 2 - 2, 8, 5, 1, co.red[5], 2)
		maCreateShape(ma.w / 2 - 2, 8, 5, 1, co.red[5], 2)
				
	endif
	
endfunction

// ---------------------------
// Create a shape.
// As x, y, with w, h, and col.
//
function maCreateShape(x as integer, y as integer, w as integer, h as integer, col as integer, phys as integer)
	
	local spr as integer
	local shp as Shape

	spr = CreateSprite(co.pixImg)
	SetSpriteScale(spr, w * ma.s, h * ma.s)
	coSetSpriteColor(spr, col)
	SetSpritePosition(spr, ma.s + x * ma.s, ma.s + y * ma.s)
	SetSpritePhysicsGravityScale(spr, 10)
	SetSpriteDepth(spr, MA_DEPTH_SHAPE)
	SetSpritePhysicsOn(spr, phys)
	
	shp.x = x
	shp.y = y
	shp.w = w
	shp.h = h
	shp.col = col
	shp.spr = spr
	
	ma.shps.insert(shp)

endfunction spr

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
	elseif in.ptrDown
	elseif in.ptrReleased
	else
		maHoverCell()
	endif

endfunction

// ---------------------------
// Hover over a cell, with a shape color.
//
function maHoverCell()
	
	local cci as integer
	local pci as integer
	local i as integer
	
	cci = -1
	pci = ma.prevCellIdx
		
	for i = 0 to ma.cells.length
		
		//log("px=" + str(in.ptrx) + ", py=" + str(in.ptry) + ", cell.x=" + str(ma.cells[i].rect.x) + ", celly=" + str(ma.cells[i].rect.y))
		
		if coPointWithinRect2(in.ptrX, in.ptrY, ma.cells[i].rect)
			
			cci = i
			exit
			
		endif
	next
	
	if cci > -1
		
		if pci <> cci
			
			coSetSpriteColor(ma.cells[cci].spr, ma.selCol)
		
			if pci > -1
				coSetSpriteColor(ma.cells[pci].spr, ma.cells[pci].col)
			endif
			
		endif
		
	elseif pci > -1
		
		coSetSpriteColor(ma.cells[pci].spr, ma.cells[pci].col)
	
	endif
	
	ma.prevCellIdx = ma.currCellIdx
	ma.currCellIdx = cci
	
endfunction

// ---------------------------
// Update play state.
//
function maUpdatePlay()

endfunction

// ---------------------------
// END.
//
