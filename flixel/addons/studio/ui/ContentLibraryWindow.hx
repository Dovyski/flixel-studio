package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextField;
import flixel.system.ui.FlxSystemButton;
import flixel.system.debug.FlxDebugger.GraphicCloseButton;
import flixel.addons.studio.core.Entities;
import flixel.addons.studio.core.ContentProvider;

using flixel.system.debug.DebuggerUtil;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class ContentLibraryWindow extends StackableWindow
{
	private static inline var LINE_HEIGHT:Int = 15;
	private static inline var GUTTER = 4;

	var _itemsContainer:Sprite;
	var _bottomBar:Sprite;	
	var _addButton:FlxSystemButton;	
	var _contentProvider:ContentProvider;
	
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
	public function new(contentProvider:ContentProvider)
	{
		super("Content library", null, 200, 200, true);
		_contentProvider = contentProvider;
		
		x = 5;
		y = FlxG.game.height - height;

		createItemsContainer();		
		createBottomBar();
	}

	public function refresh():Void
	{
		removeExistingItems();
		for (className in _contentProvider.findAll())
			addItem(className, false);
		updateItemsPosition();
	}

	override public function resize(width:Float, height:Float):Void
	{
		super.resize(width, height);
		updateItemsPosition();
	}

	function createItemsContainer():Void
	{
		_itemsContainer = new Sprite();
		_itemsContainer.x = 0;
		_itemsContainer.y = 0;
		addChildContent(_itemsContainer);
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
		addChildContent(_bottomBar, true);
	}

	function addItem(itemClassName:String, updatePosition:Bool = true):Void
	{
		var item = new ContentLibraryItem(itemClassName);
		_itemsContainer.addChild(item);

		if (updatePosition)
			updateItemsPosition();
	}

	function removeExistingItems():Void
	{
		while (_itemsContainer.numChildren > 0)
		{
			var item:ContentLibraryItem = cast _itemsContainer.getChildAt(0);
			item.destroy();
		}
	}

	function updateItemsPosition():Void
	{
		for (i in 0..._itemsContainer.numChildren)
		{
			var item:ContentLibraryItem = cast _itemsContainer.getChildAt(i);
			item.y = i * LINE_HEIGHT;
			item.updateSize(100, _width);
		}
	}
}
