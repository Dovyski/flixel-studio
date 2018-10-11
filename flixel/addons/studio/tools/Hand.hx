package flixel.addons.studio.tools;

import flash.display.BitmapData;
import flash.ui.Keyboard;
import flixel.FlxBasic;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.system.debug.interaction.Interaction;
import flixel.system.debug.interaction.tools.Tool;

@:bitmap("assets/images/tools/hand.png") 
class GraphicCursorHand extends BitmapData {}

@:bitmap("assets/images/tools/hand-closed.png") 
class GraphicCursorHandClosed extends BitmapData {}

/**
 * Allow the game camera to be freely moved around.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class Hand extends Tool
{		
	static inline var CURSOR_DRAGGING = "handClosed";
	
	public static inline var KEYBOARD_MOVE_SPEED:Float = 3;
	public static inline var DRAG_SMOOTH_FACTOR:Float = 0.7;
	public static inline var DRAG_MAX_MOVEMENT:Float = 5;
	public static inline var DRAG_DEAD_ZONE_DISTANCE:Float = 10;
	
	var _dragStartPoint:FlxPoint = new FlxPoint();
	var _dragEndPoint:FlxPoint = new FlxPoint();
	var _dragHappening:Bool = false;
	
	override public function init(brain:Interaction):Tool 
	{
		super.init(brain);
		
		_name = "Hand";
		setButton(GraphicCursorHand);
		setCursor(new GraphicCursorHand(0, 0));

		brain.registerCustomCursor(CURSOR_DRAGGING, new GraphicCursorHandClosed(0, 0));		
		
		return this;
	}
	
	override public function update():Void 
	{
		if (!isActive())
			return;
		
		// Move the camera based on keyboard events, if applicable.
		updateKeyboardBasedMove();

		if (_brain.pointerJustPressed && !_dragHappening)
			startDragAction();

		if (_dragHappening)
			updateOngoinDragAction();
			
		// If any mouse button is still down, we just wait.
		if (!_brain.pointerJustReleased)
			return;

		// If we made this far, the user just released the mouse button.
		// In that case, we need to act if we were performing
		if (_dragHappening)
			stopDragAction();
	}

	function updateKeyboardBasedMove():Void
	{
		var deltaX:Float = 0;
		var deltaY:Float = 0;

		if (_brain.keyPressed(Keyboard.UP))
			deltaY = -KEYBOARD_MOVE_SPEED;

		if (_brain.keyPressed(Keyboard.DOWN))
			deltaY = KEYBOARD_MOVE_SPEED;

		if (_brain.keyPressed(Keyboard.LEFT))
			deltaX = -KEYBOARD_MOVE_SPEED;

		if (_brain.keyPressed(Keyboard.RIGHT))
			deltaX = KEYBOARD_MOVE_SPEED;

		FlxG.camera.scroll.x += deltaX;
		FlxG.camera.scroll.y += deltaY;
	}

	function updateOngoinDragAction():Void
	{
		_dragEndPoint.set(_brain.flixelPointer.x, _brain.flixelPointer.y);

		setCursorInUse(CURSOR_DRAGGING);

		var deltaX:Float = _dragEndPoint.x - _dragStartPoint.x;
		var deltaY:Float = _dragEndPoint.y - _dragStartPoint.y;

		if (_dragEndPoint.distanceTo(_dragStartPoint) <= DRAG_DEAD_ZONE_DISTANCE)
			return;

		deltaX = FlxMath.bound(deltaX, -DRAG_MAX_MOVEMENT, DRAG_MAX_MOVEMENT);
		deltaY = FlxMath.bound(deltaY, -DRAG_MAX_MOVEMENT, DRAG_MAX_MOVEMENT);
		FlxG.log.add(deltaX);

		FlxG.camera.scroll.x += deltaX * DRAG_SMOOTH_FACTOR * -1;
		FlxG.camera.scroll.y += deltaY * DRAG_SMOOTH_FACTOR * -1;
	}
	
	/**
	 * Start a dragging action. The game camera will move according to
	 * the dragging action.
	 */
	public function startDragAction():Void
	{
		_dragHappening = true;
		_dragStartPoint.set(_brain.flixelPointer.x, _brain.flixelPointer.y);
	}
	
	/**
	 * Stop any drag activity that is happening. 
	 */
	public function stopDragAction():Void
	{	
		if (!_dragHappening)
			return;
		
		_dragEndPoint.set(_brain.flixelPointer.x, _brain.flixelPointer.y);	
		_dragHappening = false;
		useDefaultCursor();
	}
}
