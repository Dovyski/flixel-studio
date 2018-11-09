package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.Shape;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;
import flixel.math.FlxMath;

/**
 * A window that can be attached to another window to create
 * content separated by tabs. When attached, each window works
 * as a tab, several windows can occupy the same space on the
 * screen while only one of them is actively displaying content.
 *
 * Internally, the `TabWindow` class works without a centralized
 * window manager. Instead each window has a referece to other
 * sibling windows (left and right siblings, respectively).
 * When attached, the windows become siblings in a chain, which
 * is used to propagate important events, e.g. resize.
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class TabWindow extends flixel.system.debug.Window
{
	public static var HEADER_HEIGHT:Int = 15;
	
	var _siblingLeft:TabWindow;
	var _siblingRight:TabWindow;
	var _content:ScrollArea;
	var _activeTabHighlight:Bitmap;
	
	/**
	 * When the window is attached to other windows, this property controls
	 * if this window is the active one (the one being viewed by the user).
	 */
	var _activeTab:Bool;
	
	/**
	 * Creates a new tabbed window object.
	 * 
	 * @param   title       The name of the window, displayed in the header bar.
	 * @param   icon	    The icon to use for the window header.
	 * @param   width       The initial width of the window.
	 * @param   height      The initial height of the window.
	 * @param   resizable   Whether you can change the size of the window with a drag handle.
	 * @param   bounds      A rectangle indicating the valid screen area for the window.
	 * @param   closable    Whether this window has a close button that removes the window.
	 */
	public function new(title:String, ?icon:BitmapData, width:Float = 0, height:Float = 0, resizable:Bool = true,
		?bounds:Rectangle, closable:Bool = false)
	{
		super(title, icon, width, height, resizable, bounds, closable, false);
		visible = true;
		_activeTab = true;
		
		_content = new ScrollArea();
		_content.x = 0;
		_content.y = HEADER_HEIGHT;
		_content.setScrollable(true);
		_content.scrollYPadding.bottom = _handle.height;
		addChild(_content);

		_activeTabHighlight = new Bitmap(new BitmapData(1, 1, true, flixel.system.debug.Window.BG_COLOR));
		addChildAt(_activeTabHighlight, getChildIndex(_title));

		addEventListener(Event.ADDED, onAddedToDisplayList);
	}

	function onAddedToDisplayList(?e:Event):Void
	{
		e.preventDefault();
		adjustLayout();
		removeEventListener(Event.ADDED, onAddedToDisplayList);
	}

	function setActiveTab(status:Bool, force:Bool = false):Void
	{
		_activeTab = status;
		_content.visible = status;
		_shadow.visible = status;
		_background.visible = status;
		_activeTabHighlight.visible = status;
		_activeTabHighlight.scaleX = getTitleWidth();
		_activeTabHighlight.scaleY = HEADER_HEIGHT;

		if (_icon != null)
			_icon.alpha = status ? 1 : 0.3;

		if (_resizable)
			_handle.visible = status;
	}

	override function onMouseDown(?e:MouseEvent):Void
	{
		super.onMouseDown(e);

		if (hasSiblings())
		{
			var clickedIndex = getSiblingIndexFromMouseClickInTitles(this.mouseX, this.mouseY);
			adjustActiveTabStatusFromActiveSiblingIndex(clickedIndex);
			refreshSiblings(clickedIndex);
		}
	}

	function adjustActiveTabStatusFromActiveSiblingIndex(activeSiblingIndex:Int = -1):Void
	{
		if (activeSiblingIndex == -1)
			return;
		
		var isActiveTab = activeSiblingIndex == getIndexAmongSiblings();
		setActiveTab(isActiveTab);
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
			if (mouseY <= _header.height && mouseX >= currentX && mouseX <= (currentX + sibling.getTitleWidth()))
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

	function updateBasedOnSibling(commander:TabWindow, toTheRight:Bool = true, activeSiblingIndex:Int = -1):Void
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

		adjustActiveTabStatusFromActiveSiblingIndex(activeSiblingIndex);
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
			var offsetX = calculateTitleOffsetFromSiblings();
			if (_icon != null)
			{
				_icon.x = offsetX + 5;
				_title.x = _icon.x + _icon.width + 2;
			}
			else
				_title.x = offsetX;
			_activeTabHighlight.x = offsetX;
			_header.visible = shouldDisplayHeaderBar();

			var minWidth = Std.int(getMinWidthHouseAllSiblingsTitles());
			if (_width <= minWidth)
				_width = minWidth;
		}
		
		_background.scaleX = _width;
		_shadow.scaleX = _width;
		_header.scaleX = _width;
		
		if (_content != null)
			_content.resize(_width, _height - _content.y);

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

	/**
	 * Add an element to the scrollable area of the window. If you do not want your
	 * element to be scrollable within the window, use `addChild()` instead. 
	 * 
	 * @param child            Element to be added to the window as content.
	 * @return DisplayObject   Reference to the added element.
	 */
	public function addContent(child:DisplayObject):DisplayObject
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
		return (_icon != null ? _icon.width + 2 : 0) + _title.textWidth + 15;
	}

	public function hasSiblings():Bool
	{
		return _siblingLeft != null || _siblingRight != null;
	}

	/**
	 * Attach this window to another window. When attached, the windows will
	 * occupy the same space on the screen and will display their content as
	 * tabs, i.e. only one window will be display content at the time.
	 * 
	 * @param   target   Window to be attached to.
	 */
	public function attachTo(target:TabWindow):Void
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
		setActiveTab(true);
	}

	public function detach():Void
	{
		// TODO: implement this
	}

	/**
	 * When the window is attached to other windows, return the
	 * window that is located at the start (far right) of the chain of windows.
	 * 
	 * @return TabWindow reference to the first window in the chain (right most one). If the windows is not attached to other windows, this method returns a reference to the window itself.
	 */
	public function getRightMostSibling():TabWindow
	{
		var sibling:TabWindow = _siblingRight;
		while (sibling != null)
		{
			if (sibling._siblingRight == null)
				break;
			sibling = sibling._siblingRight;
		}

		return sibling == null ? this : sibling;
	}

	/**
	 * When the window is attached to other windows, return the
	 * window that is located at the start (far right) of the chain of windows.
	 * 
	 * @return TabWindow reference to the last window in the chain (left most one). If the windows is not attached to other windows, this method returns a reference to the window itself.
	 */
	public function getLeftMostSibling():TabWindow
	{
		var sibling:TabWindow = _siblingLeft;
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

		_content = null;
	}
}
