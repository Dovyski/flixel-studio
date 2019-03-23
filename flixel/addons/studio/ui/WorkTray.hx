package flixel.addons.studio.ui;

import flash.display.BitmapData;
import flash.events.Event;
import flixel.system.ui.FlxSystemButton;
import flixel.system.debug.Window;

/**
 * Window displayed right below the interactive debug icon at the top of the screen
 * to house all buttons related to Flixel Studio.
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class WorkTray extends flixel.system.debug.Window
{
	public static var WIDTH:Int = 100;
	public static var HEIGHT:Int = 15;
	public static var PADDING_TOP:Int = 18;
	public static var PADDING:Int = 5;

    /**
     * List of buttons available for use in the studio.
     */
    var _buttons:Array<FlxSystemButton> = [];
	
	public function new()
	{
		super("", null, WIDTH, HEIGHT, false, null, false, true);
		visible = true;
		
		addEventListener(Event.ADDED, onAddedToDisplayList);
	}

	function onAddedToDisplayList(?e:Event):Void
	{
		removeEventListener(Event.ADDED, onAddedToDisplayList);
		adjustLayout();
	}

	function adjustLayout():Void
	{
		_header.visible = false;
	}

    /**
	 * Create and add a new button.
	 * 
	 * @param   icon           The icon to use for the button
	 * @param   upHandler      The function to be called when the button is pressed.
	 * @param   toggleMode     Whether this is a toggle button or not.
	 * @return  The added button.
	 */
	public function addButton(?icon:BitmapData, ?upHandler:Void->Void, toggleMode:Bool = false):FlxSystemButton
	{
		var button = new FlxSystemButton(icon, upHandler, toggleMode);
		button.y = PADDING_TOP;
		button.x = PADDING + 20 * _buttons.length; // TODO: re-work this.
		_buttons.push(button);
		addChild(button);
		
		return button;
	}
	
	/**
	 * Removes and destroys a button from the list of buttons.
	 * 
	 * @param   Button         The FlxSystemButton instance to remove.
	 */
	public function removeButton(button:FlxSystemButton):Void
	{
		removeChild(button);
		button.destroy();
		_buttons.remove(button);
	}
	
	public function addWindowToggleButton(window:Window, icon:Class<BitmapData>):Void
	{
		var button = addButton(Type.createInstance(icon, [0, 0]), window.toggleVisible, true);
		window.toggleButton = button;
		button.toggled = !window.visible;
	}

	override public function destroy():Void
	{
		super.destroy();
		_buttons = null;
	}
}
