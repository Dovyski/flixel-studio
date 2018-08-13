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
	public var displayName(default, null):String;

	private var nameText:TextField;
	private var valueText:EditableTextField;
	private var removeButton:FlxSystemButton;
	private var defaultFormat:TextFormat;

	public function new(displayName:String, entity:Entity)
	{
		super();
		
		this.displayName = displayName;
		this.entity = entity;

		defaultFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, 12, 0xFFFFFF);
		nameText = initTextField(DebuggerUtil.createTextField());
		valueText = initTextField(DebuggerUtil.initTextField(new EditableTextField(true, defaultFormat, submitValue)));

		updateName();
		
		addChild(removeButton = new FlxSystemButton(new GraphicCloseButton(0, 0), destroy));
		removeButton.y = (TEXT_HEIGHT - removeButton.height) / 2;
		removeButton.alpha = 0.3;
	}
	
	private function initTextField<T:TextField>(textField:T):T
	{
		textField.selectable = true;
		textField.defaultTextFormat = defaultFormat;
		textField.autoSize = TextFieldAutoSize.NONE;
		textField.height = TEXT_HEIGHT;
		addChild(textField);
		return textField;
	}

	public function updateSize(nameWidth:Float, windowWidth:Float):Void
	{
		var textWidth = windowWidth - removeButton.width - GUTTER;
		
		nameText.width = nameWidth;
		valueText.x = nameWidth + GUTTER;
		valueText.width = textWidth - nameWidth - GUTTER;
		removeButton.x = textWidth;
	}
	
	private function updateName()
	{
		if (displayName != null)
			setNameText(displayName);
	}
	
	private function setNameText(name:String)
	{
		nameText.text = name;
		var currentWidth = nameText.textWidth + 4;
		nameText.width = Math.min(currentWidth, MAX_NAME_WIDTH);
	}
	
	private function submitValue(value:String):Void
	{
		// TODO: do something here
	}
	
	public function getNameWidth():Float
	{
		return nameText.width;
	}
	
	public function getMinWidth():Float
	{
		return valueText.x + GUTTER * 2 + removeButton.width; 
	}
	
	public function destroy()
	{
		nameText = FlxDestroyUtil.removeChild(this, nameText);
		FlxDestroyUtil.destroy(valueText);
		valueText = FlxDestroyUtil.removeChild(this, valueText);
	}
}