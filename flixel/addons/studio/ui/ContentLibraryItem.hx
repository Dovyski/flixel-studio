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
import flixel.addons.studio.ui.EntitiesWindow.GraphicSpriteIcon;

using flixel.util.FlxStringUtil;
using flixel.system.debug.DebuggerUtil;

class ContentLibraryItem extends Sprite implements IFlxDestroyable
{
	private static inline var SELECTED_BG_COLOR:FlxColor = 0x00FF0000;
	private static inline var SELECTED_ALPHA:Float = 0.2;
	private static inline var GUTTER = 4;
	private static inline var TEXT_HEIGHT = 15;
	private static inline var MAX_NAME_WIDTH = 125;
	
	var _icon:Bitmap;
	var _className:String;
	var _parentWindow:ContentLibraryWindow;
	var _nameText:TextField;
	var _selectedMarker:Sprite;
	var _selected:Bool;

	public function new(className:String, parentWindow:ContentLibraryWindow)
	{
		super();
		_className = className;
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
		_selectedMarker = createSelectedMarker();
		_icon = createIcon();

		updateName();		
		updateSize(100, 200);
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
		var data:BitmapData = new GraphicSpriteIcon(0, 0);
		var icon:Bitmap = new Bitmap(data);		

		icon.y = (TEXT_HEIGHT - icon.height) / 2;
		addChild(icon);

		return icon;
	}

	function initTextField<T:TextField>(textField:T, upHandler:Event->Void = null):T
	{
		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, 12, 0xFFFFFF);
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
			_selectedMarker.width = width;
	}

	public function updateSize(nameWidth:Float, windowWidth:Float):Void
	{
		var textWidth = windowWidth - _icon.width - GUTTER * 2;

		_icon.x = GUTTER;
		_nameText.x = _icon.x + _icon.width + GUTTER;
		_nameText.width = nameWidth;
		_selectedMarker.width = width;
	}
	
	function updateName()
	{
		setNameText(_className);
	}
	
	function setNameText(name:String)
	{
		if (name == null)
			return;

		_nameText.text = name;
		var currentWidth = _nameText.textWidth + 4;
		_nameText.width = Math.min(currentWidth, MAX_NAME_WIDTH);
	}
	
	public function getNameWidth():Float
	{
		return _nameText.width;
	}
	
	public function getMinWidth():Float
	{
		// TODO: check this
		return _nameText.textWidth + GUTTER * 2;
	}
	
	public function destroy()
	{
		_nameText = FlxDestroyUtil.removeChild(this, _nameText);
		_icon = FlxDestroyUtil.removeChild(this, _icon);
		_selectedMarker = FlxDestroyUtil.removeChild(this, _selectedMarker);
	}
}