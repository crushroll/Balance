// -------------------------------------------------------
// BUTTON CODE.
// -------------------------------------------------------

type Text
	
	dir as integer
	text as string
	font as integer
	size as integer
	tx as integer
	
endtype

type Button
	
	bgImg as integer
	fgImg as integer
	text as string
	ts as integer
	bs as float
	fs as float
	
	bg as integer
	fg as integer
	txs as Text[]
	
endtype

// -------------------------------------------------------
// Create a simple button.
//
function buCreateBut(but ref as Button, bgImg as integer, fgImg as integer)
	
	but.bs = 1
	but.fs = 1
	but.bg = 0
	but.fg = 0
	but.txs.length = -1
	but.text = ""
	
	buClearBut(but)
	buSetButBg(but, bgImg)
	buSetButFg(but, fgImg)
		
endfunction

// -------------------------------------------------------
// Delete a simple button.
//
function buDeleteBut(but ref as Button)
	
	local i as integer
	
	buSetButBg(but, 0)
	buSetButFg(but, 0)
	
	for i = 0 to but.txs.length
		deletetext(but.txs[i].tx)
	next
	
	but.txs.length = -1
		
endfunction

// -------------------------------------------------------
// update the position a button.
//
function buUpdateButPos(but ref as Button)

	local spr as integer
	
	if but.bg
		spr = but.bg
	elseif but.fg
		spr = but.fg
	else
		spr = 0
	endif
	
	if spr
		buSetButPos(but, GetSpriteXByOffset(spr), GetSpriteYByOffset(spr))
	endif
	
endfunction

// -------------------------------------------------------
// Position a button.
//
function buSetButPos(but ref as Button, x as float, y as float)
	
	if but.fg	
		SetSpritePositionByOffset(but.fg, x, y)
	endif
			
	if but.bg			
		SetSpritePositionByOffset(but.bg, x, y)		
	endif
	
	buSetTxPos(but, -1, x, y)
	
endfunction

// -------------------------------------------------------
// Position a button text.
//
function buSetTxPos(but ref as Button, idx as integer, x as float, y as float)

	local xx as float
	local yy as float
	local i as integer

	for i = 0 to but.txs.length
		
		if idx > -1 // Want a specific idx.
			if idx <> i // Doesn't match, ignore this one.
				continue
			endif
		endif
		
		xx = x
		yy = y - GetTextTotalHeight(but.txs[i].tx) / 2

		if but.txs[i].dir = DIR_N				
			if but.bg // Put above bg.
				yy = y - GetSpriteHeight(but.bg) / 2 - GetTextTotalHeight(but.txs[i].tx)
			elseif but.fg // Put above fg.
				yy = y - GetSpriteHeight(but.fg) / 2 - GetTextTotalHeight(but.txs[i].tx)
			endif
		elseif but.txs[i].dir = DIR_S			
			if but.bg // Put below bg.
				yy = y + GetSpriteHeight(but.bg) / 2
			elseif but.fg // Put below fg.
				yy = y + GetSpriteHeight(but.fg) / 2
			endif
		elseif but.txs[i].dir = DIR_W			
			if but.bg // Put below bg.
				xx = x - GetSpriteWidth(but.bg) / 2 - GetTextTotalWidth(but.txs[i].tx)
			elseif but.fg // Put below fg.
				xx = x - GetSpriteWidth(but.fg) / 2 - GetTextTotalWidth(but.txs[i].tx)
			endif
		elseif but.txs[i].dir = DIR_E			
			if but.bg // Put below bg.
				xx = x + GetSpriteWidth(but.bg) / 2
			elseif but.fg // Put below fg.
				xx = x + GetSpriteWidth(but.fg) / 2
			endif
		endif
		
		SetTextPosition(but.txs[i].tx, xx, yy)
		
	next

endfunction

// -------------------------------------------------------
// Set the bg ibuge.
//
function buSetButBg(but ref as Button, bgImg as integer)
	
	if bgImg
		
		but.bgImg = bgImg
		
		if but.bg
			deletesprite(but.bg)
		endif
		
		but.bg = createSprite(bgImg)
		
	elseif but.bg
	
		deletesprite(but.bg)	
		but.bg = 0
		
	endif

endfunction

// -------------------------------------------------------
// Set the fg ibuge.
//
function buSetButFg(but ref as Button, fgImg as integer)
	
	if fgImg
		
		but.fgImg = fgImg
		
		if but.fg
			deletesprite(but.fg)
		endif
		
		but.fg = createSprite(fgImg)

	elseif but.fg
	
		deletesprite(but.fg)	
		but.bg = 0
		
	endif

endfunction

// -------------------------------------------------------
// Set the fg ibuge as an anim sprite.
//
function buSetButFgFrame(but ref as Button, fw as integer, fh as integer, fc as integer, fr as integer)
	
	if but.fg
		
		SetSpriteAnimation(but.fg, fw, fh, fc)
		SetSpriteFrame(but.fg, fr)
		
	endif
	
endfunction

// -------------------------------------------------------
// Get the idx of a button with dir.
//
function buButTxForDir(but ref as Button, dir as integer)
	
	local i as integer
	local idx as integer
	
	idx = -1
	
	for i = 0 to but.txs.length
		if but.txs[i].dir = dir
			
			idx = i
			exit
			
		endif
	next
	
endfunction idx

// -------------------------------------------------------
// Set the tx and ts on the but.
// dir = 0, centre text, ither DIR_... specifies where the text goes.
// If tx = "" text is deleted at this dir.
//
function buSetButTx(but ref as Button, dir as integer, text as string, font as integer, size as integer)
		
	local idx as integer
	local tx as Text
	
	idx = buButTxForDir(but, dir)

	if text <> ""
		
		if font < 0
			font = 0
		endif
		
		if size < 0
			size = 0
		endif
				
		if idx = -1 // New, add it.
			
			tx.dir = dir

			if tx.dir <> DIR_C and tx.dir <> DIR_N and tx.dir <> DIR_S and tx.dir <> DIR_W and tx.dir <> DIR_E
				tx.dir = DIR_C
			endif
			
			tx.text = text
			tx.font = font
			tx.size = size
			but.txs.insert(tx)
			idx = but.txs.length
			
		else // Existing, update.
			
			but.txs[idx].text = text		
			but.txs[idx].font = font
			but.txs[idx].size = size
			
		endif
		
		if but.txs[idx].tx // It exists?
		
			SetTextString(but.txs[idx].tx, but.txs[idx].text)	
			coSetTextFont(but.txs[idx].tx, but.txs[idx].font)
			SetTextSize(but.txs[idx].tx, but.txs[idx].size)
			
		else
			
			but.txs[idx].tx = coCreateText(but.txs[idx].text, but.txs[idx].font, but.txs[idx].size)
			
			if dir = DIR_W
				SetTextAlignment(but.txs[idx].tx, 2)
			elseif dir = DIR_E
				SetTextAlignment(but.txs[idx].tx, 0)
			else //if dir = DIR_N or dir = DIR_S or dir = DIR_C
				SetTextAlignment(but.txs[idx].tx, 1)
			endif
			
		endif
		
		if but.txs[idx].size = 0 and but.txs[idx].dir = DIR_C
			buCalcTextSize(but, idx)
		endif
						
	else
		
		DeleteText(but.txs[idx].tx)
		but.txs.remove(idx)
		
	endif

endfunction

// -------------------------------------------------------
// Fiddle the text size until it fits.
//
function buCalcTextSize(but ref as Button, idx as integer)
	
	local size as integer
	local w as float
	local h as float
	
	if not but.bg // Can't do anything, if bg is not set.
		exitfunction
	endif
	
	w = GetSpriteWidth(but.bg)
	h = GetSpriteHeight(but.bg)
	
	size = GetTextSize(but.txs[idx].tx)
	
	while GetTextTotalWidth(but.txs[idx].tx) < w and GetTextTotalheight(but.txs[idx].tx) < h
		
		inc size, 4
		SetTextSize(but.txs[idx].tx, size)
		
	endwhile
			
	while GetTextTotalWidth(but.txs[idx].tx) >= w or GetTextTotalheight(but.txs[idx].tx) >= h
		
		dec size, 4
		SetTextSize(but.txs[idx].tx, size)
		
	endwhile

	dec size, 4 // buke sure it fits.
	SetTextSize(but.txs[idx].tx, size)
			
endfunction

// -------------------------------------------------------
// Set the button scale.
//
function buSetButScale(but ref as Button, bs as float, fs as float)

	local i as integer
	
	but.bs = bs
	
	if but.bg
		setspritescale(but.bg, bs, bs)
	endif
	
	if but.fg
		setspritescale(but.fg, fs, fs)
	endif
	
	for i = 0 to but.txs.length
		
		if but.txs[i].size = 0
			buCalcTextSize(but, i)
		else
			buSetButTx(but, but.txs[i].dir, but.txs[i].text, but.txs[i].font, but.txs[i].size)
		endif
	next
	
endfunction

// -------------------------------------------------------
// Set the button vis.
//
function buSetButVis(but ref as Button, vis as integer)
	
	local i as integer
	
	if but.bg
		SetSpriteVisible(but.bg, vis)
	endif

	if but.fg
		SetSpriteVisible(but.fg, vis)
	endif

	for i = 0 to but.txs.length
		SetTextVisible(but.txs[i].tx, vis)
	next
	
endfunction

// -------------------------------------------------------
// Check if the button was pressed.
//
function buButPressed(but ref as Button)

	local ret as integer
	
	if but.bg
		ret = coGetSpriteHitTest4(but.bg, in.ptrx, in.ptry, 0)
	elseif but.fg
		ret = coGetSpriteHitTest4(but.fg, in.ptrx, in.ptry, 0)
	else
		ret = false
	endif
	
endfunction ret

// -------------------------------------------------------
// Clear the button for reuse.
//
function buClearBut(but ref as Button)
	
	but.bg = 0
	but.fg = 0
	but.txs.length = -1
	
endfunction