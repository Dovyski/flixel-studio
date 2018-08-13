package flixel.addons.studio.ui;

import openfl.display.Sprite;
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

	private var _nameText:TextField;
	private var removeButton:FlxSystemButton;

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
		
		addChild(removeButton = new FlxSystemButton(new GraphicCloseButton(0, 0), destroy));
		removeButton.y = (TEXT_HEIGHT - removeButton.height) / 2;
		removeButton.alpha = 0.3;
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

	public function updateSize(nameWidth:Float, windowWidth:Float):Void
	{
		var textWidth = windowWidth - removeButton.width - GUTTER;
		_nameText.width = nameWidth;
		removeButton.x = textWidth;
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
		return _nameText.textWidth + GUTTER * 2 + removeButton.width; 
	}
	
	public function destroy()
	{
		_nameText = FlxDestroyUtil.removeChild(this, _nameText);
	}
}