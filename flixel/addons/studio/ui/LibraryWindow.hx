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
import flixel.addons.studio.core.Library;
import flixel.addons.studio.core.LibraryItem;

using flixel.system.debug.DebuggerUtil;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class LibraryWindow extends StackableWindow
{
	private static inline var GUTTER = 4;

	var _rowsContainer:Sprite;
	var _bottomBar:Sprite;	
	var _addButton:FlxSystemButton;	
	var _library:Library;
	var _rowBeingDragged:LibraryWindowRow;
	var _rowDragStartingPoint:FlxPoint = new FlxPoint();
	var _rowDragMarker:Sprite;	
	
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
	public function new(library:Library)
	{
		super("Library", null, 200, 200, true);
		_library = library;
		
		x = 5;
		y = FlxG.game.height - height;

		_rowDragMarker = createItemDragMarker();
		createItemsContainer();
		createBottomBar();
		stopItemDrag();

		FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUpEvent);
	}

	function createItemDragMarker():Sprite
	{
		var marker = new Sprite();
		var filling = new Bitmap(new BitmapData(42, 42, false, 0x00FF0000));
		
		filling.alpha = 0.4;
		filling.x = 0;
		filling.y = 0;
		marker.visible = false;
		marker.mouseEnabled = false;
		
		marker.addChild(filling);
		FlxG.stage.addChild(marker); // TODO: improve where the marker is attached?
		
		return marker;
	}	

	function handleRowDraggedIntoScreen(row:LibraryWindowRow):Void
	{
		FlxStudio.instance.libraryItemDraggedIntoScreen.dispatch(row.item);
	}

	function handleMouseUpEvent(?e:MouseEvent):Void
	{
		if (_rowBeingDragged != null && isItemDragDistantEnough())
		{
			handleRowDraggedIntoScreen(_rowBeingDragged);
			stopItemDrag();
		}
	}

	function isItemDragDistantEnough():Bool
	{
		if (_rowBeingDragged == null)
			return false;

		var dragDistance = FlxG.mouse.getScreenPosition().distanceTo(_rowDragStartingPoint);
		return dragDistance >= 10;
	}

	override public function update():Void
	{
		super.update();

		if (_rowBeingDragged != null && isItemDragDistantEnough())
		{
			_rowDragMarker.visible = true;
			_rowDragMarker.x = FlxG.mouse.screenX * FlxG.scaleMode.scale.x;
			_rowDragMarker.y = FlxG.mouse.screenY * FlxG.scaleMode.scale.y;
		}
		else
			_rowDragMarker.visible = false;
	}

	public function startItemDrag(item:LibraryWindowRow):Void
	{
		_rowBeingDragged = item;
		_rowDragStartingPoint.x = FlxG.mouse.screenX;
		_rowDragStartingPoint.y = FlxG.mouse.screenY;
	}

	public function stopItemDrag():Void
	{
		_rowBeingDragged = null;
		_rowDragStartingPoint.set(0, 0);
		_rowDragMarker.visible = false;
	}

	public function refresh():Void
	{
		removeExistingItems();
		for (item in _library.findAll())
			addRow(item, false);
		updateItemsPosition();
	}

	public function unselectAllItems():Void
	{
		for (i in 0..._rowsContainer.numChildren)
		{
			var item:LibraryWindowRow = cast _rowsContainer.getChildAt(i);
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
		_rowsContainer = new Sprite();
		_rowsContainer.x = 0;
		_rowsContainer.y = 0;
		addChildContent(_rowsContainer);
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

	function addRow(item:LibraryItem, updatePosition:Bool = true):Void
	{
		var row = new LibraryWindowRow(item, this);
		_rowsContainer.addChild(row);

		if (updatePosition)
			updateItemsPosition();
	}

	function removeExistingItems():Void
	{
		while (_rowsContainer.numChildren > 0)
		{
			var item:LibraryWindowRow = cast _rowsContainer.getChildAt(0);
			item.destroy();
		}
	}

	function updateItemsPosition():Void
	{
		for (i in 0..._rowsContainer.numChildren)
		{
			var item:LibraryWindowRow = cast _rowsContainer.getChildAt(i);
			item.y = i * item.height;
			item.updateSize(_width);
		}
	}
}
