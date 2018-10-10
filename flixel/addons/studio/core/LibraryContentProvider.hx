package flixel.addons.studio.core;

import openfl.display.Sprite;
import openfl.events.Event;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.debug.watch.Tracker;
import flixel.addons.studio.ui.EntitiesWindow;

using flixel.util.FlxStringUtil;
using flixel.util.FlxArrayUtil;

/**
 * TODO: add docs
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class LibraryContentProvider
{
	var _list:Array<String>;
	
	#if FLX_DEBUG
	public function new()
	{
		// TODO: properly get class names for content
		_list = ["flixel.FlxSprite", "flixel.math.FlxPoint"];
	}

	public function findAll():Array<String>
	{
		return _list;
	}
	#end
}
