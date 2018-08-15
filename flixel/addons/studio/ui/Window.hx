package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class Window extends flixel.system.debug.Window
{
	var _siblingLeft:Window;
	var _siblingRight:Window;
	var _content:Sprite;
	var _featured:Bool;
	
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
		
		_content = new Sprite();
		_content.x = 0;
		_content.y = 0;
		addChild(_content);
	}

	function setFeatured(status:Bool):Void
	{
		if (_featured == status)
			return;

		_featured = status;
		_content.visible = status;
		_shadow.visible = status;
		_background.visible = status;
		_background.visible = status;
		_title.border = status;
		_title.borderColor = 0xff0000;

		if (_resizable)
			_handle.visible = status;
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

	function updateBasedOnSibling(commander:Window, toTheRight:Bool = true, offsetX:Float = 0):Void
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

	function adjustLayout():Void
	{
		var head = getLastLeftSibling();
		var contentSize = getMaxWidthAmongSiblings();

		_content.scaleX = contentSize;
		_content.x = head.x - x;
		_background.scaleX = _content.scaleX;
		_background.x = _content.x;
		_shadow.scaleX = _content.scaleX;
		_shadow.x = _content.x;

		if (_resizable)
			_handle.x = _background.x + _background.width - _handle.width;
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

	public function addChildContent(child:DisplayObject):DisplayObject
	{
		return _content.addChild(child);
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

	public function attachTo(target:Window):Void
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

	public function getLastRightSibling():Window
	{
		var sibling:Window = _siblingRight;
		while (sibling != null)
		{
			if (sibling._siblingRight == null)
				break;
			sibling = sibling._siblingRight;
		}

		return sibling == null ? this : sibling;
	}

	public function getLastLeftSibling():Window
	{
		var sibling:Window = _siblingLeft;
		while (sibling != null)
		{
			if (sibling._siblingLeft == null)
				break;
			sibling = sibling._siblingLeft;
		}

		return sibling == null ? this : sibling;
	}
}
