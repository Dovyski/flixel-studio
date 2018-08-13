package flixel.addons.studio.ui;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
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

using flixel.util.FlxStringUtil;
using flixel.system.debug.DebuggerUtil;

class EntityRow extends Sprite implements IFlxDestroyable
{
	private static inline var GUTTER = 4;
	private static inline var TEXT_HEIGHT = 20;
	private static inline var MAX_NAME_WIDTH = 125;
	
	public var entity:Entity;

	private var _icon:Bitmap;
	private var _nameText:TextField;
	private var _visibilityButton:FlxSystemButton;
	private var _lockButton:FlxSystemButton;

	public function new(entity:Entity)
	{
		super();
		this.entity = entity;
		buildUI();
	}
	
	private function buildUI():Void
	{
		_nameText = initTextField(DebuggerUtil.createTextField());
		updateName();
		
		_icon = createIcon();
		_visibilityButton = createUIButton(onVisibilityClick);
		_lockButton = createUIButton(onLockClick);

		updateSize(100, 200);
	}

	private function createUIButton(upHandler:Void->Void):FlxSystemButton
	{
		var button = new FlxSystemButton(new GraphicCloseButton(0, 0), upHandler);
		
		button.y = (TEXT_HEIGHT - button.height) / 2;
		button.alpha = 0.3;
		addChild(button);

		return button;
	}

	private function createIcon():Bitmap
	{
		// TODO: select icon based on entity type.
		var data:BitmapData = new GraphicCloseButton(0, 0);
		var icon:Bitmap = new Bitmap(data);
		icon.y = (TEXT_HEIGHT - icon.height) / 2;
		addChild(icon);

		return icon;
	}

	private function initTextField<T:TextField>(textField:T):T
	{
		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, 12, 0xFFFFFF);
		textField.autoSize = TextFieldAutoSize.NONE;
		textField.height = TEXT_HEIGHT;
		addChild(textField);
		return textField;
	}

	private function onVisibilityClick():Void
	{
		// TODO: do something
	}

	private function onLockClick():Void
	{
		// TODO: do something
	}

	public function updateSize(nameWidth:Float, windowWidth:Float):Void
	{
		var textWidth = windowWidth - _icon.width - GUTTER * 2 - _lockButton.width - GUTTER - _visibilityButton.width - GUTTER;

		_icon.x = GUTTER;
		_nameText.x = _icon.x + _icon.width + GUTTER;
		_nameText.width = nameWidth;
		_lockButton.x = textWidth + GUTTER;
		_visibilityButton.x = _lockButton.x + _lockButton.width + GUTTER;
	}
	
	private function updateName()
	{
		if (entity != null)
			setNameText(Std.string(entity.type));
	}
	
	private function setNameText(name:String)
	{
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
		return _nameText.textWidth + GUTTER * 2 + _lockButton.width; 
	}
	
	public function destroy()
	{
		_nameText = FlxDestroyUtil.removeChild(this, _nameText);
	}
}