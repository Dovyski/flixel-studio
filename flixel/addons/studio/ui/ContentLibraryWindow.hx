package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flixel.system.ui.FlxSystemButton;
import flixel.math.FlxPoint;
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
	private static inline var GUTTER = 4;

	var _itemsContainer:Sprite;
	var _bottomBar:Sprite;	
	var _addButton:FlxSystemButton;	
	var _contentProvider:ContentProvider;
	var _itemBeingDragged:ContentLibraryItem;
	var _itemDragStartingPoint:FlxPoint = new FlxPoint();
	var _itemDragMarker:Sprite;	
	
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

		_itemDragMarker = createItemDragMarker();
		createItemsContainer();
		createBottomBar();
		stopItemDrag();

		FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUpEvent);
	}

	function createItemDragMarker():Sprite
	{
		var marker = new Sprite();
		var filling = new Bitmap(new BitmapData(80, 20, false, 0x00FF0000));
		
		filling.alpha = 0.5;
		filling.x = 0;
		filling.y = 0;
		marker.visible = false;
		marker.mouseEnabled = false;
		
		marker.addChild(filling);
		FlxG.stage.addChild(marker); // TODO: improve where the marker is attached?
		
		return marker;
	}	

	function handleItemDraggedIntoScreen(item:ContentLibraryItem):Void
	{
		FlxStudio.instance.contentLibraryItemDraggedIntoScreen.dispatch(item);
	}

	function handleMouseUpEvent(?e:MouseEvent):Void
	{
		if (_itemBeingDragged != null && isItemDragDistantEnough())
		{
			handleItemDraggedIntoScreen(_itemBeingDragged);
			stopItemDrag();
		}
	}

	function isItemDragDistantEnough():Bool
	{
		if (_itemBeingDragged == null)
			return false;

		var dragDistance = FlxG.mouse.getScreenPosition().distanceTo(_itemDragStartingPoint);
		return dragDistance >= 10;
	}

	override public function update():Void
	{
		super.update();

		if (_itemBeingDragged != null && isItemDragDistantEnough())
		{
			_itemDragMarker.visible = true;
			_itemDragMarker.x = FlxG.mouse.screenX * FlxG.scaleMode.scale.x;
			_itemDragMarker.y = FlxG.mouse.screenY * FlxG.scaleMode.scale.y;
		}
		else
			_itemDragMarker.visible = false;
	}

	public function startItemDrag(item:ContentLibraryItem):Void
	{
		_itemBeingDragged = item;
		_itemDragStartingPoint.x = FlxG.mouse.screenX;
		_itemDragStartingPoint.y = FlxG.mouse.screenY;
	}

	public function stopItemDrag():Void
	{
		_itemBeingDragged = null;
		_itemDragStartingPoint.set(0, 0);
		_itemDragMarker.visible = false;
	}

	public function refresh():Void
	{
		removeExistingItems();
		for (className in _contentProvider.findAll())
			addItem(className, false);
		updateItemsPosition();
	}

	public function unselectAllItems():Void
	{
		for (i in 0..._itemsContainer.numChildren)
		{
			var item:ContentLibraryItem = cast _itemsContainer.getChildAt(i);
			item.setSelected(false);
		}
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
		var item = new ContentLibraryItem(itemClassName, this);
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
			item.y = i * item.height;
			item.updateSize(_width);
		}
	}
}
