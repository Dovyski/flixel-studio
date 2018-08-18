package flixel.addons.studio.core;

import openfl.display.Sprite;
import openfl.events.Event;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.system.debug.watch.Tracker;

using flixel.util.FlxStringUtil;
using flixel.util.FlxArrayUtil;

/**
 * TODO: add docs.
 */
class Properties
{
	#if FLX_DEBUG
	var _target:FlxBasic;
	var _window:Tracker;

	public function new()
	{
		_target = null;
	}

	public function setTarget(target:FlxBasic):Void
	{
		_target = target;

		if (_window != null)
			_window.close();

		if (target == null)
			return;
		
		var profile = Tracker.findProfile(_target);

		if (profile == null)
			FlxG.log.error("Could not find a tracking profile for object of class '" + target.getClassName(true) + "'."); 
		else
		{
			_window = new Tracker(profile, _target);
			_window.x = FlxG.game.width - _window.width;
			_window.y = 50;
			FlxG.game.debugger.addWindow(_window);
		}
	}

	public function update():Void {
		var selectedItems = FlxG.game.debugger.interaction.selectedItems;

		if(selectedItems.length != 1)
			// TODO: show message that multiple elements cannot be tracked?
			return;

		// TODO: properly get the first selected item
		var selectedItem = selectedItems.members[0];

		if(_target != selectedItem)
			setTarget(cast selectedItem);
	}
	#end
}