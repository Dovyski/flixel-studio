package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextField;
import flixel.system.ui.FlxSystemButton;
import flixel.system.debug.FlxDebugger.GraphicCloseButton;
import flixel.addons.studio.core.Entities;

using flixel.system.debug.DebuggerUtil;

@:bitmap("assets/images/icons/emitter.png") 
class GraphicEmitterIcon extends BitmapData {}

@:bitmap("assets/images/icons/group.png") 
class GraphicGroupIcon extends BitmapData {}

@:bitmap("assets/images/icons/lock.png") 
class GraphicLockIcon extends BitmapData {}

@:bitmap("assets/images/icons/sprite.png") 
class GraphicSpriteIcon extends BitmapData {}

@:bitmap("assets/images/icons/tilemap.png") 
class GraphicTilemapIcon extends BitmapData {}

@:bitmap("assets/images/icons/visibility.png") 
class GraphicVisilityIcon extends BitmapData {}

@:bitmap("assets/images/icons/x.png") 
class GraphicXIcon extends BitmapData {}

@:bitmap("assets/images/icons/dot.png") 
class GraphicDotIcon extends BitmapData {}

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class EntitiesWindow extends TabWindow
{
	private static inline var LINE_HEIGHT:Int = 15;
	private static inline var GUTTER = 4;

	var _entriesContainer:Sprite;
	var _topBar:Sprite;	
	var _bottomBar:Sprite;	
	var _addButton:FlxSystemButton;	
	var _visibilityButton:FlxSystemButton;	
	var _lockButton:FlxSystemButton;	
	var _entities:Entities;
	var _selectedEntityRow:EntityRow;
	
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
		
		x = 5;
		y = FlxG.game.height - height;

		createTopBar();
		createEntitiesContainer();		
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

		_bottomBar.y = height - 15;
	}

	public function selectEntityRow(entityRow:EntityRow):Void
	{
		if (_selectedEntityRow != null)
			_selectedEntityRow.setHighlighted(false);

		_selectedEntityRow = entityRow;

		if (_selectedEntityRow == null)
			return;
		
		_selectedEntityRow.setHighlighted(true);
	}

	function createEntitiesContainer():Void
	{
		_entriesContainer = new Sprite();
		_entriesContainer.x = 0;
		_entriesContainer.y = _topBar.y + _topBar.height;
		addContent(_entriesContainer);
	}

	function createTopBar():Void
	{
		_topBar = new Sprite();
		_topBar.x = 0;
		_topBar.y = GUTTER;

		_visibilityButton = new FlxSystemButton(new GraphicVisilityIcon(0, 0), function():Void {
			FlxStudio.instance.entitiesVisibilityButtonClicked.dispatch();
		});
		_visibilityButton.x = width - 42; // TODO: better position this
		_visibilityButton.alpha = 0.7;

		_lockButton = new FlxSystemButton(new GraphicLockIcon(0, 0), function():Void {
			FlxStudio.instance.entitiesLockButtonClicked.dispatch();
		});
		_lockButton.x = _visibilityButton.x + _visibilityButton.width + GUTTER;
		_lockButton.alpha = 0.7;

		_topBar.addChild(_visibilityButton);
		_topBar.addChild(_lockButton);

		addContent(_topBar);
	}

	function createBottomBar():Void
	{
		_bottomBar = new Sprite();
		_bottomBar.x = 0;
		_bottomBar.y = height - 15;

		_addButton = new FlxSystemButton(new GraphicCloseButton(0, 0), function():Void {
			FlxStudio.instance.entitiesAddButtonClicked.dispatch();
		});
		_addButton.x = GUTTER;
		_addButton.alpha = 0.7;
		
		_bottomBar.addChild(_addButton);
		addChild(_bottomBar);
	}

	function addEntry(entity:Entity, updatePosition:Bool = true):Void
	{
		var entry = new EntityRow(entity, this);
		_entriesContainer.addChild(entry);

		if (updatePosition)
			updateEntriesPosition();
	}

	function removeExistingEntries():Void
	{
		while (_entriesContainer.numChildren > 0)
		{
			var entry:EntityRow = cast _entriesContainer.removeChildAt(0);
			entry.destroy();
		}
		
		_selectedEntityRow = null;
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
