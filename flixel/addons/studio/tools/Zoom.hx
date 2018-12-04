package flixel.addons.studio.tools;

import flash.display.BitmapData;
import flash.ui.Keyboard;
import flixel.FlxBasic;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.system.debug.interaction.Interaction;
import flixel.system.debug.interaction.tools.Tool;
import flixel.system.debug.Tooltip;
import flixel.addons.studio.utils.Formtatter;

/**
 * Allow the scale factor fo the main camera to be controlled, i.e. zoom in/out.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class Zoom extends Tool
{		
	public static inline var ZOOM_CHANGE_STEP:Float = 0.02;
	public static inline var TOOLTIP_TTL_SECONDS:Float = 1;
	
	var _tooltip:TooltipOverlay;
	var _tooltipTTL:Float;
	
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
		updateTooltipOverlay();

		var activationPressed = _brain.keyPressed(Keyboard.CONTROL);
		var zoomIn = activationPressed && _brain.keyPressed(Keyboard.PERIOD);
		var zoomOut = activationPressed && _brain.keyPressed(Keyboard.COMMA);
		var change:Float = 0;

		if (!zoomIn && !zoomOut)
			return;

		change = ZOOM_CHANGE_STEP * (zoomIn ?  1 : -1);
		FlxG.camera.setScale(FlxG.camera.scaleX + change, FlxG.camera.scaleY + change);

		showTooltipOverlay();
	}

	function updateTooltipOverlay():Void
	{
		if (_tooltipTTL > 0)
			_tooltipTTL -= FlxG.elapsed;

		if (_tooltipTTL <= 0 && _tooltip.visible)
			_tooltip.setVisible(false);

		_tooltip.setText(
			"camera.scaleX: " + Formatter.prettifyFloat(FlxG.camera.scaleX) + "\n" +
			"camera.scaleY: " + Formatter.prettifyFloat(FlxG.camera.scaleY)
		);
	}

	function showTooltipOverlay():Void
	{
		if (!_tooltip.visible)
			_tooltip.setVisible(true);
			
		_tooltip.x = FlxG.width * 0.4;
		_tooltip.y = FlxG.height * 0.4;
		_tooltipTTL = TOOLTIP_TTL_SECONDS;
	}
}
