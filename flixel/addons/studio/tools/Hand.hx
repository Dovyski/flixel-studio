package flixel.addons.studio.tools;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.ui.Keyboard;
import flixel.FlxBasic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxSpriteUtil;
import flixel.system.debug.interaction.Interaction;
import flixel.system.debug.interaction.tools.Tool;

using flixel.util.FlxArrayUtil;

@:bitmap("assets/images/debugger/cursorCross.png")
class GraphicCursorHand extends BitmapData {}

/**
 * Allow the game camera to be freely moved around.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class Hand extends Tool
{		
	public static inline var MOVEMENT_SPEED:Float = 3;
	public static inline var DRAG_SMOOTH:Float = 0.7;
	
	var _dragStartPoint:FlxPoint = new FlxPoint();
	var _dragEndPoint:FlxPoint = new FlxPoint();
	var _dragHappening:Bool = false;
	
	override public function init(brain:Interaction):Tool 
	{
		super.init(brain);
		
		_name = "Hand";
		setButton(GraphicCursorHand);
		setCursor(new GraphicCursorHand(0, 0));
		
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
		var deltaX = 0;
		var deltaY = 0;

		if (_brain.keyPressed(Keyboard.UP))
			deltaY = -MOVEMENT_SPEED;

		if (_brain.keyPressed(Keyboard.DOWN))
			deltaY = MOVEMENT_SPEED;

		if (_brain.keyPressed(Keyboard.LEFT))
			deltaX = -MOVEMENT_SPEED;

		if (_brain.keyPressed(Keyboard.RIGHT))
			deltaX = MOVEMENT_SPEED;

		FlxG.camera.scroll.x += deltaX;
		FlxG.camera.scroll.y += deltaY;
	}

	function updateOngoinDragAction():Void
	{
		_dragEndPoint.set(_brain.flixelPointer.x, _brain.flixelPointer.y);

		var deltaX = _dragEndPoint.x - _dragStartPoint.x;
		var deltaY = _dragEndPoint.y - _dragStartPoint.y;

		FlxG.camera.scroll.x += deltaX * DRAG_SMOOTH * -1;
		FlxG.camera.scroll.y += deltaY * DRAG_SMOOTH * -1;
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
	}
}
