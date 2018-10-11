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
	
	public static inline var KEYBOARD_MOVE_SPEED:Float = 1;
	public static inline var KEYBOARD_MOVE_SPEED_BOOSTED:Float = 5;
	public static inline var DRAG_SMOOTH_FACTOR:Float = 0.7;
	public static inline var DRAG_MAX_MOVEMENT:Float = 15;
	public static inline var DRAG_DEAD_ZONE_DISTANCE:Float = 2;
	
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
		var speed:Float = _brain.keyPressed(Keyboard.SHIFT) ? KEYBOARD_MOVE_SPEED_BOOSTED : KEYBOARD_MOVE_SPEED;
		var deltaX:Float = 0;
		var deltaY:Float = 0;

		if (_brain.keyPressed(Keyboard.UP))
			deltaY = -speed;

		if (_brain.keyPressed(Keyboard.DOWN))
			deltaY = speed;

		if (_brain.keyPressed(Keyboard.LEFT))
			deltaX = -speed;

		if (_brain.keyPressed(Keyboard.RIGHT))
			deltaX = speed;

		FlxG.camera.scroll.x += deltaX;
		FlxG.camera.scroll.y += deltaY;
	}

	function updateOngoinDragAction():Void
	{
		// If the mouse cursor is not moving on the screen, we interrupt the calculation
		// to prevent the camera from "sliding" endlessly.
		if (_dragEndPoint.distanceTo(_brain.flixelPointer) <= DRAG_DEAD_ZONE_DISTANCE)
			return;

		_dragEndPoint.set(_brain.flixelPointer.x, _brain.flixelPointer.y);

		var deltaX:Float = _dragEndPoint.x - _dragStartPoint.x;
		var deltaY:Float = _dragEndPoint.y - _dragStartPoint.y;

		deltaX = FlxMath.bound(deltaX, -DRAG_MAX_MOVEMENT, DRAG_MAX_MOVEMENT);
		deltaY = FlxMath.bound(deltaY, -DRAG_MAX_MOVEMENT, DRAG_MAX_MOVEMENT);

		FlxG.camera.scroll.x += deltaX * DRAG_SMOOTH_FACTOR * -1;
		FlxG.camera.scroll.y += deltaY * DRAG_SMOOTH_FACTOR * -1;

		setCursorInUse(CURSOR_DRAGGING);
	}
	
	/**
	 * Start a dragging action. The game camera will move according to
	 * the dragging action.
	 */
	public function startDragAction():Void
	{
		_dragHappening = true;
		_dragStartPoint.set(_brain.flixelPointer.x, _brain.flixelPointer.y);
		setCursorInUse(CURSOR_DRAGGING);
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
