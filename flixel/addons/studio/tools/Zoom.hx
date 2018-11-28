package flixel.addons.studio.tools;

import flash.display.BitmapData;
import flash.ui.Keyboard;
import flixel.FlxBasic;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.system.debug.interaction.Interaction;
import flixel.system.debug.interaction.tools.Tool;

/**
 * Allow the scale factor fo the main camera to be controlled, i.e. zoom in/out.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class Zoom extends Tool
{		
	public static inline var ZOOM_CHANGE_STEP:Float = 0.05;`
	
	var _tooltip:TooltipOverlay;	
	
	override public function init(brain:Interaction):Tool 
	{
		super.init(brain);
		_name = "Zoom";

		_tooltip = Tooltip.add(null, "");
		_tooltip.textField.wordWrap = false;
		_tooltip.setVisible(false);
		
		return this;
	}
	
	override public function update():Void 
	{
		super.update();
		
		var activationPressed = _brain.keyPressed(Keyboard.CONTROL);
		var zoomIn = activationPressed && _brain.keyPressed(Keyboard.PERIOD);
		var zoomOut = activationPressed && _brain.keyPressed(Keyboard.COMMA);
		var change:Float = 0;

		if (!zoomIn && !zoomOut)
		{
			if (_tooltip.visible)
				_tooltip.setVisible(false);
			return;
		}

		change = zoomIn ? ZOOM_CHANGE_STEP : -ZOOM_CHANGE_STEP;
		FlxG.camera.setScale(FlxG.camera.scaleX + change, FlxG.camera.scaleY + change);

		_tooltip.x = FlxG.camera.scroll.x;
		_tooltip.y = FlxG.camera.scroll.y;
		_tooltip.setText(
			"scaleX: " + FlxG.camera.scaleX + "\n" +
			"scaleX: " + FlxG.camera.scaleY
		);
	}
}
