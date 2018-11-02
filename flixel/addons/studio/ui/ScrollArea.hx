package flixel.addons.studio.ui;

import flash.text.TextField;
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
class ScrollArea extends Sprite
{
	public static var SCROLL_HANDLE_WIDTH:Int = 5;
	public static var SCROLL_HANDLE_HEIGHT:Int = 20;
	
	public var scrollSpeed:Float = 15.0;
	
	var _hitArea:TextField;
	var _content:Sprite;
	var _scrollMask:Shape;
	var _scrollHandleY:Sprite;
	var _scrollableY:Bool;
	var _usingScrollHandleY:Bool;
	
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
	public function new()
	{
		super();

		// Ugly hack to ensure the scroll area can capture mouse events even when its
		// content is transparent or contains "holes".
		_hitArea = new TextField();
		_hitArea.selectable = false;
		addChild(_hitArea);

		_content = new Sprite();
		addChild(_content);

		_scrollHandleY = createScrollHandle(SCROLL_HANDLE_WIDTH, SCROLL_HANDLE_HEIGHT);
		_scrollHandleY.y = 0;
		_scrollHandleY.addEventListener(MouseEvent.MOUSE_DOWN, onScrollHandleMouseEvent);
		addChild(_scrollHandleY);

		_scrollMask = new Shape();
		_scrollMask.graphics.beginFill(0xFF0000, 1);
		_scrollMask.graphics.drawRect(0, 0, 10, 10);
		_scrollMask.graphics.endFill();

		_scrollMask.x = 0;
		_scrollMask.y = 0;
		_scrollMask.visible = false;
		addChild(_scrollMask);

		setScrollable(true);
		
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	function createScrollHandle(width:Int, height:Int):Sprite
	{
		var handle = new Sprite();
		handle.x = 0;
		handle.y = 0;
		handle.graphics.beginFill(0x333333);
		handle.graphics.drawRect(0, 0, width, height);
		handle.graphics.endFill();

		return handle;
	}

	function updateScrollHandlesAppearance():Void
	{
		if (!_scrollableY || _scrollMask == null)
			return;

		_scrollHandleY.visible = needsScrollY();
		
		var adjustedHeight = SCROLL_HANDLE_HEIGHT / getContentScrollMaskRatio();
		_scrollHandleY.height = FlxMath.bound(adjustedHeight, SCROLL_HANDLE_HEIGHT * 0.5, SCROLL_HANDLE_HEIGHT * 1.3);
	}

	function isScrolling():Bool
	{
		return _scrollableY && _usingScrollHandleY;
	}

	function onMouseMove(?e:MouseEvent):Void
	{
		if (!isScrolling())
			return;

		var point = localToGlobal(new Point(_scrollMask.x, _scrollMask.y));
		_scrollHandleY.y = FlxMath.bound(e.stageY - point.y, 0, _scrollMask.height);
		var handleProgress = calculateScrollHandleYProgress();
		setScrollProgressY(handleProgress);
	}

	function calculateScrollHandleYProgress():Float
	{
		var progress = _scrollHandleY.y / (_scrollMask.height - _scrollHandleY.height);
		progress = FlxMath.bound(progress, 0, 1);
		return progress;
	}

	function onMouseUp(?e:MouseEvent):Void
	{
		if (_scrollableY)
			onScrollHandleMouseEvent(null);
	}

	function onScrollHandleMouseEvent(?e:MouseEvent):Void
	{
		if (!_scrollableY)
			return;

		if (e != null && e.type == MouseEvent.MOUSE_DOWN)
			_usingScrollHandleY = true;
		else
			stopScrolling();
	}

	public function stopScrolling():Void
	{
		_usingScrollHandleY = false;
		ensureScrollBoundaries();
	}

	function getAdjustedScrollSpeed():Float
	{
		var ratio = getContentScrollMaskRatio();
		var factor = FlxMath.bound(ratio, 1, 5);
		return scrollSpeed / factor;
	}

	function getContentScrollMaskRatio():Float
	{
		return _content.height / _scrollMask.height;
	}

	function onMouseWheel(?e:MouseEvent):Void
	{
		if (!_scrollableY)
			return;
		
		var isScrollingUp = e.delta > 0;
		_scrollHandleY.y += getAdjustedScrollSpeed() * (isScrollingUp ? -1 : 1);
		
		ensureScrollHandleBoundaries();
		var handleProgress = calculateScrollHandleYProgress();
		setScrollProgressY(handleProgress);
	}

	public function setScrollProgressY(progress:Float):Void
	{
		var totalNonVisibleArea = Math.max(_content.height - _scrollMask.height, 0);

		progress = FlxMath.bound(progress, 0, 1);
		_content.y = - totalNonVisibleArea * progress;

		ensureScrollBoundaries();
	}

	function ensureScrollBoundaries():Void
	{
		if (_content.y + _content.height < _scrollMask.height)
			_content.y = _scrollMask.height - _content.height;

		if (_content.y >= 0)
			_content.y = _scrollMask.y;

		ensureScrollHandleBoundaries();
	}

	function ensureScrollHandleBoundaries():Void
	{
		if (_scrollHandleY.y <= 0)
			_scrollHandleY.y = 0;
		
		if (_scrollHandleY.y + _scrollHandleY.height >= _scrollMask.height)
			_scrollHandleY.y =  _scrollMask.height - _scrollHandleY.height;
	}	

	function getScrollingProgress():Float
	{
		var totalNonVisibleArea = Math.max(0, _content.height - _scrollMask.height);
		var currentNonVisibleArea = Math.max(0, (_content.y + _content.height) - _scrollMask.height);

		if (totalNonVisibleArea <= 0)
			return 0;

		var progress = Math.max(0, 1 - currentNonVisibleArea / totalNonVisibleArea);
		return progress;
	}

	public function needsScrollY():Bool
	{
		return _content.height > _scrollMask.height;
	}

	public function resize(width:Float, height:Float):Void
	{
		_hitArea.width = width;
		_hitArea.height = height;

		if (_scrollableY && _scrollMask != null)
		{
			_scrollMask.width = width;
			_scrollMask.height = height;
			_scrollHandleY.x = width - _scrollHandleY.width;
		}

		updateScrollHandlesAppearance();
		ensureScrollHandleBoundaries();
	}

	public function addContent(child:DisplayObject):DisplayObject
	{
		var element = _content.addChild(child);
		return element;
	}

	public function setScrollable(status:Bool):Void
	{
		_usingScrollHandleY = false;
		_scrollableY = status;
		_scrollMask.visible = status;
		_content.y = _scrollMask.y;
		_content.mask = status ? _scrollMask : null;
	}

	public function destroy():Void
	{
		if (_content != null)
			removeChild(_content);

		if (_scrollMask != null)
			removeChild(_scrollMask);

		if (_scrollHandleY != null)
			removeChild(_scrollHandleY);

		_content = null;
		_scrollMask = null;
		_scrollHandleY = null;
		removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
}
