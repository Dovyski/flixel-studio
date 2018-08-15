package flixel.addons.studio;

import flash.display.BitmapData;
import flash.errors.Error;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets;
import flixel.system.debug.interaction.tools.Tool;
import flixel.text.FlxText;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxSignal;
import flixel.math.FlxPoint;
import openfl.Assets;

import flixel.addons.studio.tools.*;
import flixel.addons.studio.core.*;
import flixel.addons.studio.core.Entities.EntityType;
import flixel.addons.studio.ui.*;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */

class FlxStudio extends flixel.system.debug.Window
{	
	public static var instance:FlxStudio;

	var _properties:Properties;
	var _entities:Entities;
	var _entitiesWindow:EntitiesWindow;	

	public var entityRowSelected:FlxTypedSignal<EntityRow->Void> = new FlxTypedSignal();
	public var entityVisibilityButtonClicked:FlxTypedSignal<EntityRow->Void> = new FlxTypedSignal();
	public var entityLockButtonClicked:FlxTypedSignal<EntityRow->Void> = new FlxTypedSignal();
	public var entitiesAddButtonClicked:FlxSignal = new FlxSignal();
	public var entitiesVisibilityButtonClicked:FlxSignal = new FlxSignal();
	public var entitiesLockButtonClicked:FlxSignal = new FlxSignal();	

	// TODO: choose a good name for this
	public static function bootstrap():Void
	{
		FlxStudio.instance = new FlxStudio();
	}

	/**
	 * TODO: add docs
	 */
	public function new()
	{
		super("FlxStudio");

		visible = false;
		_properties = new Properties();
		_entities = new Entities();

		addInteractionTools();
		initSignals();
		initUI();		

		FlxG.game.debugger.addWindow(this);
	}

	override public function update():Void
	{
		super.update();
		_properties.update();
		_entities.update();
	}

	function initUI():Void 
	{
		_entitiesWindow = new EntitiesWindow(_entities);
		_entitiesWindow.refresh();
		
		FlxG.game.debugger.addWindow(_entitiesWindow);	
	}

	/**
	 * TODO: add docs
	 */
	function addInteractionTools():Void
	{
		FlxG.game.debugger.interaction.addTool(new Tile());
	}

	/**
	 * TODO: add docs
	 */
	function initSignals():Void
	{
		entityRowSelected.add(onEntityRowSelected);
	}

	function selectInteractionTool(className:Class<Tool>):Void
	{
		var tool = FlxG.game.debugger.interaction.getTool(className);
		FlxG.game.debugger.interaction.setActiveTool(tool);
	}

	function onEntityRowSelected(entityRow:EntityRow):Void
	{
		_entitiesWindow.selectEntityRow(entityRow);

		var entity = entityRow.entity;
		var interaction = FlxG.game.debugger.interaction;

		// Make sure nothing is selected on the screen after
		// an entity row is clicked
		interaction.clearSelection();

		if (entity.type == EntityType.SPRITE)
		{
			selectInteractionTool(flixel.system.debug.interaction.tools.Pointer);
			interaction.selectedItems.add(cast entity.reference);
		}
		else if (entity.type == EntityType.TILEMAP)
		{
			selectInteractionTool(flixel.addons.studio.tools.tile.Editor);
			// TODO: select the proper tilemap.
		}
	}	
}
