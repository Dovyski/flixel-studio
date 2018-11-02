package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.Shape;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;
import flixel.math.FlxMath;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class StackableWindow extends flixel.system.debug.Window
{
	public static var HEADER_HEIGHT:Int = 15;
	public static var SCROLL_HANDLE_WIDTH:Int = 5;
	public static var SCROLL_HANDLE_HEIGHT:Int = 20;
	
	public var scrollSpeed:Float = 15.0;
	
	var _siblingLeft:StackableWindow;
	var _siblingRight:StackableWindow;
	var _content:ScrollArea;
	var _overlays:Sprite;
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
		_featured = true;
		
		_content = new ScrollArea();
		_overlays = new Sprite();
		_content.x = _overlays.x = 0;
		_content.y = _overlays.y = HEADER_HEIGHT;
		_content.setScrollable(true);

		addChild(_content);
		addChild(_overlays);

		addEventListener(Event.ADDED, onAddedToDisplayList);
	}

	function onAddedToDisplayList(?e:Event):Void
	{
		e.preventDefault();
		adjustLayout();
		removeEventListener(Event.ADDED, onAddedToDisplayList);
	}

	function setFeatured(status:Bool, force:Bool = false):Void
	{
		_featured = status;
		_content.visible = status;
		_shadow.visible = status;
		_background.visible = status;
		_title.border = status;
		_title.borderColor = flixel.system.debug.Window.BG_COLOR;
		_title.background = status;
		_title.backgroundColor = flixel.system.debug.Window.BG_COLOR;

		if (_resizable)
			_handle.visible = status;

		if (_content.visible)
			_content.resize(_width, _height);
	}

	override function onMouseDown(?e:MouseEvent):Void
	{
		super.onMouseDown(e);

		if (hasSiblings())
		{
			var clickedIndex = getSiblingIndexFromMouseClickInTitles(this.mouseX, this.mouseY);
			adjustFeaturedStatusFromActiveSiblingIndex(clickedIndex);
			refreshSiblings(clickedIndex);
		}
	}

	function adjustFeaturedStatusFromActiveSiblingIndex(activeSiblingIndex:Int = -1):Void
	{
		if (activeSiblingIndex == -1)
			return;
		
		var featured = activeSiblingIndex == getIndexAmongSiblings();
		setFeatured(featured);
	}

	function getSiblingIndexFromMouseClickInTitles(mouseX:Float, mouseY:Float):Int
	{
		// If the click occurred outside the window bounds, or it was related to
		// the resize handle, we inform that no window title had actually being
		// clicked in this interaction.
		if (mouseX < 0 || mouseX > _width || _overHandle)
			return -1;

		var index = 0;
		var found = false;
		var currentX:Float = 0;
		var sibling = getLeftMostSibling();

		while (sibling != null)
		{
			if (mouseX >= currentX && mouseX <= (currentX + sibling.getTitleWidth()))
			{
				found = true;
				break;
			}

			index++;
			currentX += sibling.getTitleWidth();
			sibling = sibling._siblingRight;
		}

		return found ? index : -1;
	}

	function refreshSiblings(activeSiblingIndex:Int = -1):Void
	{
		if (_siblingRight != null)
			_siblingRight.updateBasedOnSibling(this, true, activeSiblingIndex);
		if (_siblingLeft != null)
			_siblingLeft.updateBasedOnSibling(this, false, activeSiblingIndex);
	}

	function updateBasedOnSibling(commander:StackableWindow, toTheRight:Bool = true, activeSiblingIndex:Int = -1):Void
	{
		// Decide the next sibling based on the informed flow,
		// i.e. to the right or to the left.
		var next = toTheRight ? _siblingRight : _siblingLeft;
		
		if (commander != null && commander != this)
		{
			x = commander.x;
			y = commander.y;
			_width = commander._width;
			_height = commander._height;
			
			super.updateSize();
		}

		adjustFeaturedStatusFromActiveSiblingIndex(activeSiblingIndex);
		adjustLayout();

		if (next != null)
			next.updateBasedOnSibling(commander, toTheRight, activeSiblingIndex);		
	}

	override function updateSize():Void
	{
		super.updateSize();
		adjustLayout();
		refreshSiblings();
	}

	function getMinWidthHouseAllSiblingsTitles():Float
	{
		var head = getLeftMostSibling();
		var minWidth = head.getTitleWidth();
		var sibling = head._siblingRight;

		while (sibling != null)
		{
			minWidth += sibling.getTitleWidth();
			sibling = sibling._siblingRight;
		}

		return minWidth;
	}

	function shouldDisplayHeaderBar():Bool
	{
		var head = getLeftMostSibling();

		// If we have no parent yet, there is no way to know if
		// we have the lowest Z coordinate. In such case, we display
		// the header bar if we are the first window in the chain
		// (it is not garanteed to work, but it's something).
		if (head.parent == null || parent == null)
			return getIndexAmongSiblings() == 0;

		var myZ = parent.getChildIndex(this);
		var lowestZ = head.parent.getChildIndex(head);
		var sibling = head._siblingRight;

		while (sibling != null)
		{
			var siblingZ = sibling.parent == null ? lowestZ : sibling.parent.getChildIndex(sibling);
			lowestZ = Std.int(Math.min(lowestZ, siblingZ));
			sibling = sibling._siblingRight;
		}

		return myZ == lowestZ;
	}

	function adjustLayout():Void
	{
		if (hasSiblings())
		{
			_title.x = calculateTitleOffsetFromSiblings();
			_header.visible = shouldDisplayHeaderBar();

			var minWidth = Std.int(getMinWidthHouseAllSiblingsTitles());
			if (_width <= minWidth)
				_width = minWidth;
		}
		
		_background.scaleX = _width;
		_shadow.scaleX = _width;
		_header.scaleX = _width;
		
		if (_content != null)
			_content.resize(_width, _height);

		if (_resizable)
			_handle.x = _width - _handle.width;
	}

	function calculateTitleOffsetFromSiblings():Float
	{
		var head = getLeftMostSibling();

		if (head == this)
			return 0;

		var offset:Float = head.getTitleWidth();
		var sibling = head._siblingRight;

		while (sibling != null && sibling != this)
		{
			offset += sibling.getTitleWidth();
			sibling = sibling._siblingRight;			
		}

		return offset;
	}

	function getIndexAmongSiblings():Int
	{
		var head = getLeftMostSibling();

		if (head == this)
			return 0;

		var position:Int = 1;
		var sibling = head._siblingRight;

		while (sibling != null && sibling != this)
		{
			sibling = sibling._siblingRight;
			position++;			
		}

		return position;
	}

	public function addChildContent(child:DisplayObject, alwaysOnTop:Bool = false):DisplayObject
	{
		var element = _content.addContent(child);
		updateSize();

		return element;
	}

	override public function reposition(x:Float, y:Float):Void
	{
		super.reposition(x, y);
		
		if (hasSiblings())
			refreshSiblings();
	}

	public function getTitleWidth():Float
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

		var lastSibling = target.getRightMostSibling();
		lastSibling._siblingRight = this;
		this._siblingLeft = lastSibling;

		// Update position and state of all windows in the chain
		var head = getLeftMostSibling();
		head.updateBasedOnSibling(head, true, getIndexAmongSiblings());

		// Make this window the active one
		setFeatured(true);
	}

	public function detach():Void
	{
		// TODO: implement this
	}

	public function getRightMostSibling():StackableWindow
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

	public function getLeftMostSibling():StackableWindow
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

	override public function destroy():Void
	{
		super.destroy();

		if (_content != null)
		{
			_content.destroy();
			removeChild(_content);
		}

		if (_overlays != null)
			removeChild(_overlays);

		_content = null;
		_overlays = null;
	}
}
