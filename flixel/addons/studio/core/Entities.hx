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
 * This class manages and monitors all entities in the game that can be
 * handled by FlxStudio, e.g. sprites, tilemaps, etc.
 */
class Entities
{
	var _list:Array<Entity>;
	var _window:EntitiesWindow;
	
	#if FLX_DEBUG
	public function new()
	{
		_list = findItems(FlxG.state.members);
		_window = new EntitiesWindow(this);

		_window.refresh();
		FlxG.game.debugger.addWindow(_window);
	}

	public function update():Void
	{
		// TODO: monitor changes to FlxG.state?
	}


	private function findItems(members:Array<FlxBasic>, level:Int = 0, maxLevel:Int = 200):Array<Entity>
	{
		var result:Array<Entity> = [];

		if (level > maxLevel)
			return result;

		for (member in members)
		{
			if (member == null)
				continue;

			var entity:Entity = null;

			if (Std.is(member, FlxTypedEmitter))
				entity = new Entity(EntityType.EMITTER, cast member, level);
			else if (Std.is(member, FlxTilemap))
				entity = new Entity(EntityType.TILEMAP, cast member, level);
			else if (Std.is(member, FlxTypedGroup))
			{
				entity = new Entity(EntityType.GROUP, member, level);
				entity.children = findItems((cast member).members, level + 1, maxLevel);
			}
			else if (Std.is(member, FlxSprite))
				entity = new Entity(EntityType.SPRITE, cast member, level);
			
			if (entity != null)
				result.push(entity);
		}

		return result;
	}

	public function findAll():Array<Entity>
	{
		return _list;
	}
	#end
}

enum EntityType {
	SPRITE;
	TILEMAP;
	EMITTER;
	GROUP;
}

class Entity
{
	public var type:EntityType;
	public var children:Array<Entity>;
	public var level:Int;
	public var reference:FlxBasic;

	public function new(type:EntityType, reference:FlxBasic = null, level:Int = -1)
	{
		this.type = type;
		this.reference = reference;
		this.level = level;
		this.children = [];
	}

	public function toString():String
	{
		return "[Entity type=" + type + ", level=" + level + "]";
	}
}