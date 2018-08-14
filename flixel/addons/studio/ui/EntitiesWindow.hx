package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextField;
import flixel.system.ui.FlxSystemButton;
import flixel.system.debug.FlxDebugger.GraphicCloseButton;
import flixel.addons.studio.core.Entities;

using flixel.system.debug.DebuggerUtil;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class EntitiesWindow extends Window
{
	private static inline var LINE_HEIGHT:Int = 15;
	private static inline var GUTTER = 4;

	var _entriesContainer:Sprite;
	var _topBar:Sprite;	
	var _bottomBar:Sprite;	
	var _addButton:FlxSystemButton;	
	var _entities:Entities;
	
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

		createEntitiesContainer();
		createTopBar();
		createBottomBar();
	}

	public function refresh():Void
	{
		removeExistingEntries();
		for (entry in _entities.findAll())
			addEntry(entry, false);
		updateEntriesPosition();
	}

	override public function resize(width:Float, height:Float):Void
	{
		super.resize(width, height);
		updateEntriesPosition();
	}

	function createEntitiesContainer():Void
	{
		_entriesContainer = new Sprite();
		_entriesContainer.x = 0;
		_entriesContainer.y = 30;
		addChild(_entriesContainer);
	}

	function createTopBar():Void
	{
		_topBar = new Sprite();
		_topBar.x = 0;
		_topBar.y = 15;
		addChild(_topBar);
	}

	function createBottomBar():Void
	{
		_bottomBar = new Sprite();
		_bottomBar.x = 0;
		_bottomBar.y = height - 15;

		_addButton = new FlxSystemButton(new GraphicCloseButton(0, 0), onAddClick);
		_addButton.x = GUTTER;
		_addButton.alpha = 0.3;
		
		_bottomBar.addChild(_addButton);
		addChild(_bottomBar);
	}

	function onAddClick():Void
	{
		// TODO: do something here
	} 

	function addEntry(entity:Entity, updatePosition:Bool = true):Void
	{
		var entry = new EntityRow(entity);
		_entriesContainer.addChild(entry);
		
		if (updatePosition)
			updateEntriesPosition();
	}

	function removeExistingEntries():Void
	{
		while (_entriesContainer.numChildren > 0)
		{
			var entry:EntityRow = cast _entriesContainer.getChildAt(0);
			entry.destroy();
		}
	}

	function updateEntriesPosition():Void
	{
		for (i in 0..._entriesContainer.numChildren)
		{
			var entry:EntityRow = cast _entriesContainer.getChildAt(i);
			entry.y = i * LINE_HEIGHT;
			entry.updateSize(100, _width);
		}
	}
}
