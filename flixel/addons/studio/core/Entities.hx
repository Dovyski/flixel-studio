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
	
	#if FLX_DEBUG
	public function new()
	{
		parseCurrentState();
	}
	
	public function parseCurrentState():Void
	{
		_list = findItems(FlxG.state.members);
		
		// Try to apply the names of the properties of the currently active state
		// to the items that were just collected if they point to the same object.
		renameItemsUsingMeaningfulNames();
	}

	public function update():Void {}

	private function renameItemsUsingMeaningfulNames():Void
	{
		var meaningfulNames = Type.getInstanceFields(Type.getClass(FlxG.state));

		for (name in meaningfulNames)
		{
			var obj:Dynamic = Reflect.field(FlxG.state, name);

			for (entity in _list)
				if (entity.reference == obj)
					entity.name = name;
		}
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
	public var name:String;	
	public var children:Array<Entity>;
	public var level:Int;
	public var reference:FlxBasic;

	public function new(type:EntityType, reference:FlxBasic = null, level:Int = -1)
	{
		this.type = type;
		this.name = Std.string(type);
		this.reference = reference;
		this.level = level;
		this.children = [];
	}

	public function toString():String
	{
		return "[Entity type=" + type + ", level=" + level + "]";
	}
}