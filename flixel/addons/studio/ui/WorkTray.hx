package flixel.addons.studio.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flixel.system.ui.FlxSystemButton;
import flixel.system.debug.Window;
import flixel.util.FlxColor;

/**
 * Window displayed right below the interactive debug icon at the top of the screen
 * to house all buttons related to Flixel Studio.
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class WorkTray extends flixel.system.debug.Window
{
	/**
	 * The background color of the tray.
	 */
	public static inline var BG_COLOR:FlxColor = 0x44f900e9;
	public static inline var DENT_BG_COLOR:FlxColor = 0x44f900e9; 
	
	public static var WIDTH:Int = 50;
	public static var HEIGHT:Int = 25;
	public static var PADDING:Int = 5;

    /**
     * List of buttons available for use in the studio.
     */
    var _buttons:Array<FlxSystemButton> = [];

	/**
	 * Button in the debugger top bar that will be used as the anchor to
	 * guide the position of the tray.
	 */
	var _anchorButton:FlxSystemButton;

	var _dent:Bitmap;
	
	public function new()
	{
		super("", null, WIDTH, HEIGHT, false, null, false, true);
		visible = true;
		
		addEventListener(Event.ADDED, onAddedToDisplayList);
	}

	function onAddedToDisplayList(?e:Event):Void
	{
		removeEventListener(Event.ADDED, onAddedToDisplayList);
		
		// The anchor button is the one that activates/deactives the
		// interactive debugger functionality.
		_anchorButton = FlxG.game.debugger.interaction.toggleButton;
		
		buildLayout();
		adjustLayout();
	}

	function adjustLayout():Void
	{	
		_header.visible = false;
		_shadow.visible = false;
		_background.y = 0;
		
		reposition(_anchorButton.x - _dent.width - PADDING / 2, _anchorButton.y + _anchorButton.height - PADDING);
		
		// Move the stats window down a bit to make room for the tray.
		// TODO: check if it is actually disturbing before moving. 
		FlxG.game.debugger.stats.y += HEIGHT + PADDING;
	}

	function buildLayout():Void
	{
		var dentBitmapData = new BitmapData(Std.int(_anchorButton.width + PADDING),
		                                    Std.int(_anchorButton.height + PADDING * 2),
											true,
											DENT_BG_COLOR);
		_dent = new Bitmap(dentBitmapData);
		_dent.x = - PADDING / 2;
		_dent.y = - PADDING;
		_anchorButton.addChild(_dent);

		// Re-define the background of this window so it looks more like a tray
		// instead of a regular window.
		_background.bitmapData = new BitmapData(1, 1, true, BG_COLOR);
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
		button.y = PADDING / 2;
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

	override public function update():Void
	{
		if (_anchorButton == null)
			return;
			
		visible = !_anchorButton.toggled;
		_dent.visible = visible;
	}

	override public function destroy():Void
	{
		super.destroy();
		_buttons = null;
	}
}
