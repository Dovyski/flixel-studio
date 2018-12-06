package flixel.addons.studio.ui;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.system.debug.FlxDebugger.GraphicCloseButton;
import flixel.system.debug.console.ConsoleUtil;
import flixel.system.debug.watch.EditableTextField;
import flixel.system.ui.FlxSystemButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.addons.studio.core.Entities;
import flixel.addons.studio.core.Entities.EntityType;
import flixel.addons.studio.core.LibraryItem;
import flixel.addons.studio.ui.EntitiesWindow.GraphicSpriteIcon;

using flixel.util.FlxStringUtil;
using flixel.system.debug.DebuggerUtil;

class LibraryWindowRow extends Sprite implements IFlxDestroyable
{
	private static inline var SELECTED_BG_COLOR:FlxColor = 0x00FF0000;
	private static inline var SELECTED_ALPHA:Float = 0.2;
	private static inline var GUTTER = 4;
	private static inline var TEXT_HEIGHT = 15;
	
	public var item(default, null):LibraryItem;
	
	var _icon:Bitmap;
	var _parentWindow:LibraryWindow;
	var _nameText:TextField;
	var _labelText:TextField;
	var _selectedMarker:Sprite;
	var _selected:Bool;

	public function new(item:LibraryItem, parentWindow:LibraryWindow)
	{
		super();

		if (item == null)
			throw "Library item cannot be null.";

		this.item = item;
		_parentWindow = parentWindow;

		buildUI();
		
		addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvent);
		addEventListener(MouseEvent.MOUSE_UP, handleMouseEvent);
	}

	function handleMouseEvent(?e:MouseEvent):Void
	{
		e.preventDefault();

		if (e.type == MouseEvent.MOUSE_DOWN)
		{
			_parentWindow.unselectAllItems();
			setSelected(true);
			_parentWindow.startItemDrag(this);
		}
		else if (e.type == MouseEvent.MOUSE_UP)
			_parentWindow.stopItemDrag();
	}
	
	function buildUI():Void
	{
		_nameText = initTextField(DebuggerUtil.createTextField());
		_labelText = initTextField(DebuggerUtil.createTextField(), 10, 0xBABABA);
		_selectedMarker = createSelectedMarker();
		_icon = createIcon();

		updateName();
		positionInnerElements();
	}

	function createSelectedMarker():Sprite
	{
		var container = new Sprite();
		var filling = new Bitmap(new BitmapData(50, TEXT_HEIGHT, false, SELECTED_BG_COLOR));
		
		filling.alpha = SELECTED_ALPHA;
		filling.x = 0;
		filling.y = (TEXT_HEIGHT - filling.height) / 2;
		container.visible = false;
		container.mouseEnabled = false;
		
		container.addChild(filling);
		addChild(container);
		
		return container;
	}

	function createIcon():Bitmap
	{
		var iconData:BitmapData = item.icon != null ? item.icon.bitmapData : LibraryIcon.create().bitmapData;
		var icon:Bitmap = new Bitmap(iconData);

		// TODO: ensure icon has the proper width/height.

		icon.x = 0;
		icon.y = 0;
		addChild(icon);

		return icon;
	}

	function initTextField<T:TextField>(textField:T, fontSize:Int = 12, fontColor:Int = 0xFFFFFF, upHandler:Event->Void = null):T
	{
		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, fontSize, fontColor);
		textField.autoSize = TextFieldAutoSize.NONE;
		textField.height = TEXT_HEIGHT;
		addChild(textField);

		if (upHandler != null)
			textField.addEventListener(MouseEvent.CLICK, upHandler);

		return textField;
	}

	public function setSelected(status:Bool):Void
	{
		_selected = status;
		_selectedMarker.visible = _selected;		

		if (_selected)
		{
			_selectedMarker.width = width;
			_selectedMarker.height = height;
		}
	}

	function positionInnerElements():Void
	{
		_icon.x = GUTTER;
		_icon.y = GUTTER;
		_nameText.x = _icon.x + _icon.width + GUTTER;
		_nameText.y = _icon.y;
		_labelText.x = _nameText.x;
		_labelText.y = _nameText.height + GUTTER / 2;
		_selectedMarker.y = _icon.y - GUTTER / 2;
	}

	public function updateSize(windowWidth:Float):Void
	{
		_selectedMarker.width = windowWidth;
	}	

	function updateName()
	{
		if (this.item.className == null)
		{
			// This seems like a mistake. Someone provided this item with an invalid
			// class. Let's show some meaningful warning about it.
			_nameText.text = "[null]";
			_labelText.text = "Invalid class name";
			return;
		}

		var label = this.item.className;
		var name = this.item.name;
		
		if (name == "")
		{
			var cutIndex = label.lastIndexOf('.');
			name = cutIndex == -1 ? label : label.substr(cutIndex + 1);
		}

		_nameText.text = name;
		_labelText.text = label;
	}
	
	public function getMinWidth():Float
	{
		return Math.max(_nameText.textWidth, _labelText.textWidth) + GUTTER * 2;
	}
	
	public function destroy()
	{
		_nameText = FlxDestroyUtil.removeChild(this, _nameText);
		_labelText = FlxDestroyUtil.removeChild(this, _labelText);
		_icon = FlxDestroyUtil.removeChild(this, _icon);
		_selectedMarker = FlxDestroyUtil.removeChild(this, _selectedMarker);
		this.item = null;
	}
}