package flixel.addons.studio.ui;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextField;
import flixel.addons.studio.core.Entities;

using flixel.system.debug.DebuggerUtil;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class EntitiesWindow extends Window
{
	var _entities:Entities;
	var _info:TextField;
	
	/**
	 * Creates a new window object.
	 * 
	 * @param   Title       The name of the window, displayed in the header bar.
	 * @param   Icon	    The icon to use for the window header.
	 * @param   Width       The initial width of the window.
	 * @param   Height      The initial height of the window.
	 * @param   Resizable   Whether you can change the size of the window with a drag handle.
	 * @param   Bounds      A rectangle indicating the valid screen area for the window.
	 * @param   Closable    Whether this window has a close button that removes the window.
	 */
	public function new(entities:Entities)
	{
		super("Entities", null, 200, 200, true);
		_entities = entities;
		
		x = 100;
		y = 100;		

		_info = DebuggerUtil.createTextField(2, 15);
		_info.text = "Hello world!";
		addChild(_info);
	}
}
