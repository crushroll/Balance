#option_explicit

#constant KEY_LEFT = 37
#constant KEY_RIGHT = 39
#constant KEY_SPACE = 32

//-----------------------------------------------------
global in as Input

type Key 
	
	code as integer
	pressed as integer
	state as integer
	released as integer
	
endtype

type Input

	ptrPressed as integer
	ptrDown as integer
	ptrReleased as integer
	ptrX as float
	ptrY as float
	
	leftMousePressed as integer
	leftMouseDown as integer
	leftMouseReleased as integer
	rightMousePressed as integer
	rightMouseDown as integer
	rightMouseReleased as integer
	mouseX as float
	mouseY as float
	mouseWheel as float
	mouseWheelDelta as float
			
endtype

//-----------------------------------------------------
// Setup with seperate input obj.
//
function inInit()

	in.ptrPressed = 0
	in.ptrDown = 0
	in.ptrReleased = 0
	in.ptrX = 0
	in.ptrY = 0
	
	if WIN_MODE
		
		in.leftMousePressed = 0
		in.leftMouseDown = 0
		in.leftMouseReleased = 0
		in.rightMousePressed = 0
		in.rightMouseDown = 0
		in.rightMouseReleased = 0
		in.mouseX = 0
		in.mouseY = 0
		in.mouseWheel = 0
		in.mouseWheelDelta = 0
		
	endif
			
endfunction

//-----------------------------------------------------
// Update all input.
//
function inUpdate()

	inPointer()

endfunction

//-----------------------------------------------------
//
function inPointer()
		
	if WIN_MODE
		
		in.leftMousePressed = GetRawMouseLeftPressed()
		in.leftMouseDown = GetRawMouseLeftState()
		in.leftMouseReleased = GetRawMouseLeftReleased()
		in.rightMousePressed = GetRawMouseRightPressed()
		in.rightMouseDown = GetRawMouseRightState()
		in.rightMouseReleased = GetRawMouseRightReleased()
		in.mouseX = GetRawMouseX()
		in.mouseY = GetRawMouseY()
		in.mouseWheel = GetRawMouseWheel()
		in.mouseWheelDelta = GetRawMouseWheelDelta()

		//colog("wheel=" + str(in.mouseWheel) + ", delta=" + str(in.mouseWheelDelta))
		
		if in.leftMousePressed
			in.ptrPressed = 1
		elseif in.rightMousePressed
			in.ptrPressed = 2
		else 
			in.ptrPressed = 0
		endif

		if in.leftMouseReleased
			in.ptrReleased = 1
		elseif in.rightMouseReleased
			in.ptrReleased = 2
		else 
			in.ptrReleased = 0
		endif

		if in.leftMouseDown
			in.ptrDown = 1
		elseif in.rightMouseDown
			in.ptrDown = 2
		else 
			in.ptrDown = 0
		endif
		
		in.ptrX = in.mouseX
		in.ptrY = in.mouseY

	else 
		
		in.ptrPressed = GetPointerPressed()
		in.ptrDown = GetPointerState()
		in.ptrReleased = GetPointerReleased()
		in.ptrX = GetPointerX()
		in.ptrY = GetPointerY()
		
	endif
	
endfunction

// -----------------------------
// Check if any of the keys passed are pressed, return the first.
//
function inKeys(keys ref as Key[])
	
	local i as integer
	local code as integer
	local key as integer
	
	key = -1
		
	for i = 0 to keys.length
		
		code = keys[i].code
				
		keys[i].pressed = false
		keys[i].state = false
		keys[i].released = false
		
		if GetRawKeyPressed(code)
				
			keys[i].pressed = true
			if key = -1 then key = i
						
		elseif GetRawKeyState(code)	
			
			keys[i].state = true
			if key = -1 then key = i

		elseif GetRawKeyReleased(code)
			
			keys[i].released = true
			if key = -1 then key = i

		endif
					
	next
	
endfunction key

//
//
//




