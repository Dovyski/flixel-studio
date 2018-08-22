package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.Shape;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class StackableWindow extends flixel.system.debug.Window
{
	public var scrollSpeed:Float = 15.0;
	
	var _siblingLeft:StackableWindow;
	var _siblingRight:StackableWindow;
	var _content:Sprite;
	var _overlays:Sprite;
	var _featured:Bool;
	var _scrollMask:Shape;
	var _scrollHandleY:Sprite;
	var _scrollableY:Bool;
	
	/**
	 * Creates a new window object.  This Flash-based class is mainly (only?) used by FlxDebugger.
	 * 
	 * @param   Title       The name of the window, displayed in the header bar.
	 * @param   Icon	    The icon to use for the window header.
	 * @param   Width       The initial width of the window.
	 * @param   Height      The initial height of the window.
	 * @param   Resizable   Whether you can change the size of the window with a drag handle.
	 * @param   Bounds      A rectangle indicating the valid screen area for the window.
	 * @param   Closable    Whether this window has a close button that removes the window.
	 */
	public function new(title:String, ?icon:BitmapData, width:Float = 0, height:Float = 0, resizable:Bool = true,
		?bounds:Rectangle, closable:Bool = false)
	{
		super(title, icon, width, height, resizable, bounds, closable);
		visible = true;
		_featured = true;
		
		_content = new Sprite();
		_overlays = new Sprite();
		_content.x = _overlays.x = 0;
		_content.y = _overlays.y = 0;
		addChild(_content);
		addChild(_overlays);

		createScrollInfra();
		setScrollable(true);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}

	function createScrollInfra():Void
	{
		_scrollHandleY = new Sprite();
		_scrollHandleY.x = 0;
		_scrollHandleY.y = 0;
		_scrollHandleY.graphics.beginFill(0xFF0000);
		_scrollHandleY.graphics.drawRect(0, 0, 5, 10);
		_scrollHandleY.graphics.endFill();
		_scrollHandleY.addEventListener(MouseEvent.MOUSE_DOWN, onScrollHandleMouseEvent);
		_overlays.addChild(_scrollHandleY);

		_scrollMask = new Shape();
		_scrollMask.graphics.beginFill(0xFF0000, 1);
		_scrollMask.graphics.drawRect(0, 0, 10, 10);
		_scrollMask.graphics.endFill();

		addChild(_scrollMask);
		_content.mask = _scrollMask;
	}

	function setFeatured(status:Bool, force:Bool = false):Void
	{
		if (_featured == status)
			return;

		_featured = status;
		_content.visible = status;
		_shadow.visible = status;
		_background.visible = status;
		_title.border = status;
		_title.borderColor = 0xff0000;

		if (_resizable)
			_handle.visible = status;
	}

	function onScrollHandleMouseEvent(?e:MouseEvent):Void
	{
	}

	function onMouseWheel(?e:MouseEvent):Void
	{
		_content.y += scrollSpeed * (e.delta > 0 ? 1 : -1);
	}

	override function onMouseDown(?e:MouseEvent):Void
	{
		super.onMouseDown(e);

		if (hasSiblings() && _overHeader)
		{
			setFeatured(true);
			refreshSiblings();
		}
	}

	function refreshSiblings():Void
	{
		if (_siblingRight != null)
			_siblingRight.updateBasedOnSibling(this, true, getTitleTabWidth());
		if (_siblingLeft != null)
			_siblingLeft.updateBasedOnSibling(this, false);
	}

	function updateBasedOnSibling(commander:StackableWindow, toTheRight:Bool = true, offsetX:Float = 0):Void
	{
		// Decide on the next sibling based on the informed flow,
		// i.e. to the right or to the left.
		var next = toTheRight ? _siblingRight : _siblingLeft;
		
		// offsetX is our position in relation to the window being dragged, i.e. commander
		var nextOffsetX = offsetX + (toTheRight ? 1 : -1) * getTitleTabWidth();

		if (commander != null && commander != this)
		{
			x = commander.x + offsetX + (toTheRight ? 0 : -getTitleTabWidth());
			y = commander.y;
		}

		if (next != null)
			next.updateBasedOnSibling(commander, toTheRight, nextOffsetX);

		setFeatured(false);
	}

	override function updateSize():Void
	{
		super.updateSize();

		if (_scrollMask == null)
			return;

		_scrollMask.width = _width;
		_scrollMask.height = _height;

		_scrollHandleY.x = _width - _scrollHandleY.width;
	}

	function adjustLayout():Void
	{
		var head = getLastLeftSibling();
		var contentSize = getMaxWidthAmongSiblings();

		_content.x = head.x - x;
		_background.scaleX = contentSize;
		_background.x = _content.x;
		_shadow.scaleX = _background.scaleX;
		_shadow.x = _background.x;

		if (_resizable)
			_handle.x = _content.x + _background.width - _handle.width;
	}

	function getMaxWidthAmongSiblings():Float
	{
		var head = getLastLeftSibling();
		var maxWidth:Float = head.x + head._width;
		var sibling = head._siblingRight;

		while (sibling != null)
		{
			maxWidth = Math.max(maxWidth, sibling.x + sibling._width);
			sibling = sibling._siblingRight;
		}

		return maxWidth - head.x;
	}

	function adjustLayoutOfRightSiblings():Void
	{
		var sibling = _siblingRight;

		while (sibling != null)
		{
			sibling.adjustLayout();
			sibling = sibling._siblingRight;
		}
	}

	public function addChildContent(child:DisplayObject, alwaysOnTop:Bool = false):DisplayObject
	{
		var container = alwaysOnTop ? _overlays : _content;
		var element = container.addChild(child);
		updateSize();

		return element;
	}

	override public function reposition(x:Float, y:Float):Void
	{
		super.reposition(x, y);
		
		if (hasSiblings())
			refreshSiblings();
	}

	public function getTitleTabWidth():Float
	{
		return _title.textWidth + 10;
	}

	public function hasSiblings():Bool
	{
		return _siblingLeft != null || _siblingRight != null;
	}

	public function attachTo(target:StackableWindow):Void
	{
		if (target == null)
			throw "target window to be attached to must not be null";

		var lastSibling = target.getLastRightSibling();
		lastSibling._siblingRight = this;
		this._siblingLeft = lastSibling;

		// Update position and state of all windows in the chain
		var head = getLastLeftSibling();
		head.updateBasedOnSibling(head, true);
		head.adjustLayout();
		head.adjustLayoutOfRightSiblings();

		// Make this window the active one
		setFeatured(true);
	}

	public function detach():Void
	{
		// TODO: implement this
	}

	public function setScrollable(status:Bool):Void
	{
		_scrollableY = status;
	}

	public function getLastRightSibling():StackableWindow
	{
		var sibling:StackableWindow = _siblingRight;
		while (sibling != null)
		{
			if (sibling._siblingRight == null)
				break;
			sibling = sibling._siblingRight;
		}

		return sibling == null ? this : sibling;
	}

	public function getLastLeftSibling():StackableWindow
	{
		var sibling:StackableWindow = _siblingLeft;
		while (sibling != null)
		{
			if (sibling._siblingLeft == null)
				break;
			sibling = sibling._siblingLeft;
		}

		return sibling == null ? this : sibling;
	}
}
