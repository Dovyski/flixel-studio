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

@:bitmap("assets/images/icons/library.png")
class LibraryWindowToggle extends BitmapData {}
@:bitmap("assets/images/icons/Entities.png")
class EntitiesWindowToggle extends BitmapData {}

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */

class FlxStudio extends flixel.system.debug.Window
{	
	public static var instance:FlxStudio;

	/**
	 * TODO: add docs
	 */
	public var library(default, null):Library;	

	var _properties:Properties;
	var _entities:Entities;
	var _entitiesWindow:EntitiesWindow;	
	var _libraryWindow:LibraryWindow;	
	var _workTray:WorkTray;

	public var entityRowSelected:FlxTypedSignal<EntityRow->Void> = new FlxTypedSignal();
	public var entityVisibilityButtonClicked:FlxTypedSignal<EntityRow->Void> = new FlxTypedSignal();
	public var entityLockButtonClicked:FlxTypedSignal<EntityRow->Void> = new FlxTypedSignal();
	public var entitiesAddButtonClicked:FlxSignal = new FlxSignal();
	public var entitiesVisibilityButtonClicked:FlxSignal = new FlxSignal();
	public var entitiesLockButtonClicked:FlxSignal = new FlxSignal();
	public var libraryItemDraggedIntoScreen:FlxTypedSignal<LibraryItem->Void> = new FlxTypedSignal();	
	public var itemAddedToLibrary:FlxTypedSignal<LibraryItem->Void> = new FlxTypedSignal();	

	// TODO: choose a good name for this
	public static function create():Void
	{
		if (instance == null)
			new FlxStudio();
	}

	/**
	 * TODO: add docs
	 */
	function new()
	{
		super("FlxStudio");
		visible = false;
		FlxStudio.instance = this;
		
		// Initialize everything only after the game has been started, that way
		// we have access to all element added during the game's `create()` call.
		// It allows developers to call `FlxStudio.start()` at any point.
		if (FlxG.game != null && FlxG.game.debugger != null)
			bootstrap();
		else
			FlxG.signals.postGameStart.addOnce(bootstrap);
	}

	/**
	 * TODO: add docs
	 */
	function bootstrap():Void
	{
		_properties = new Properties();
		_entities = new Entities();
		library = new Library();

		addInteractionTools();
		initSignals();
		initUI();

		FlxG.game.debugger.addWindow(this);
		setExitHandler(onExit);
		FlxG.signals.postStateSwitch.add(onStateSwitch);
	}

	override public function update():Void
	{
		super.update();
		_properties.update();
		_entities.update();
	}
	
	function onStateSwitch():Void
	{
		_entities.parseCurrentState();
		_entitiesWindow.refresh();
	}

	function onExit():Void
	{
		// TODO: save last minute data.
	}

	// Source: https://stackoverflow.com/a/34305562/29827
	function setExitHandler(callback:Void->Void):Void {
		#if openfl_legacy
		openfl.Lib.current.stage.onQuit = function() {
			callback();
			openfl.Lib.close();
		};
		#else
		openfl.Lib.current.stage.application.onExit.add(function(code) {
			callback();
		});
		#end
	}

	function initUI():Void 
	{
		_entitiesWindow = new EntitiesWindow(_entities);
		_libraryWindow = new LibraryWindow(library);
		_workTray = new WorkTray();

		_entitiesWindow.refresh();
		_libraryWindow.refresh();
		
		FlxG.game.debugger.addWindow(_entitiesWindow);
		FlxG.game.debugger.addWindow(_libraryWindow);
		
		// the _workTray is a window that is not exactly a window. It is always
		// located below Flixe debugger's top toolbar and it houses all buttons
		// of the Flixel studio itself. 
		FlxG.game.debugger.addWindow(_workTray);
		
		// Add all windows/buttons available in the studio to the work tray
		_workTray.addWindowToggleButton(_entitiesWindow, EntitiesWindowToggle);
		_workTray.addWindowToggleButton(_libraryWindow, LibraryWindowToggle);
	}

	/**
	 * TODO: add docs
	 */
	function addInteractionTools():Void
	{
		FlxG.game.debugger.interaction.addTool(new Tile());
		FlxG.game.debugger.interaction.addTool(new Hand());
		FlxG.game.debugger.interaction.addTool(new Zoom());
	}

	/**
	 * TODO: add docs
	 */
	function initSignals():Void
	{
		entityRowSelected.add(onEntityRowSelected);
		libraryItemDraggedIntoScreen.add(onLibraryItemDraggedIntoScreen);
		itemAddedToLibrary.add(onItemAddedToLibrary);
	}

	function onLibraryItemDraggedIntoScreen(item:LibraryItem):Void
	{
		var classDefinition = Type.resolveClass(item.className);
		var obj:FlxObject = Type.createInstance(classDefinition, item.params);
		
		if (obj == null)
			return;
		
		obj.x = FlxG.mouse.x;
		obj.y = FlxG.mouse.y;
		
		// TODO: add obj to the right layer
		FlxG.state.add(obj);
	}

	function onItemAddedToLibrary(item:LibraryItem):Void
	{
		_libraryWindow.refresh();
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
		else if (entity.type == EntityType.EMITTER)
		{
			_properties.setTarget(cast entity.reference);
		}
	}
}
