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
import flixel.addons.studio.ui.EntitiesWindow.GraphicTilemapIcon;
import flixel.addons.studio.ui.EntitiesWindow.GraphicEmitterIcon;
import flixel.addons.studio.ui.EntitiesWindow.GraphicGroupIcon;
import flixel.addons.studio.ui.EntitiesWindow.GraphicDotIcon;

using flixel.util.FlxStringUtil;
using flixel.system.debug.DebuggerUtil;

class EntityRow extends Sprite implements IFlxDestroyable
{
	private static inline var HIGHLIGHT_BG_COLOR:FlxColor = 0x00FF0000;
	private static inline var HIGHLIGHT_ALPHA:Float = 0.2;
	private static inline var GUTTER = 4;
	private static inline var TEXT_HEIGHT = 15;
	private static inline var MAX_NAME_WIDTH = 125;
	
	public var entity:Entity;

	var _controllingWindow:EntitiesWindow;
	var _icon:Bitmap;
	var _nameText:TextField;
	var _visibilityButton:FlxSystemButton;
	var _lockButton:FlxSystemButton;
	var _highlightMarker:Sprite;
	var _highlighted:Bool;

	public function new(entity:Entity, controllingWindow:EntitiesWindow)
	{
		super();
		this.entity = entity;
		_controllingWindow = controllingWindow;
		buildUI();

		addEventListener(MouseEvent.CLICK, function(e:Event):Void {
			e.preventDefault();
			FlxStudio.instance.entityRowSelected.dispatch(this);
		});
	}
	
	function buildUI():Void
	{
		_nameText = initTextField(DebuggerUtil.createTextField());
		updateName();
		
		_icon = createIcon();
		_visibilityButton = createUIButton(function():Void {
			FlxStudio.instance.entityVisibilityButtonClicked.dispatch(this);
		});
		_lockButton = createUIButton(function():Void {
			FlxStudio.instance.entityLockButtonClicked.dispatch(this);
		});
		_highlightMarker = createHighlightMarker();

		updateSize(100, 200);
	}

	function createHighlightMarker():Sprite
	{
		var container = new Sprite();
		var filling = new Bitmap(new BitmapData(50, TEXT_HEIGHT, false, HIGHLIGHT_BG_COLOR));
		
		filling.alpha = HIGHLIGHT_ALPHA;
		filling.x = 0;
		filling.y = (TEXT_HEIGHT - filling.height) / 2;
		container.visible = false;
		container.mouseEnabled = false;
		
		container.addChild(filling);
		addChild(container);
		
		return container;
	}

	function createUIButton(upHandler:Void->Void):FlxSystemButton
	{
		var button = new FlxSystemButton(new GraphicDotIcon(0, 0), upHandler);
		
		button.y = (TEXT_HEIGHT - button.height) / 2;
		button.alpha = 0.3;
		addChild(button);

		return button;
	}

	function createIcon():Bitmap
	{
		var data:BitmapData;
		var icon:Bitmap;
		
		switch (entity.type)
		{
			case EntityType.SPRITE:  data = new GraphicSpriteIcon(0, 0);
			case EntityType.TILEMAP: data = new GraphicTilemapIcon(0, 0);
			case EntityType.EMITTER: data = new GraphicEmitterIcon(0, 0);
			case EntityType.GROUP:   data = new GraphicGroupIcon(0, 0);
		}

		icon = new Bitmap(data);		
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

	public function setHighlighted(status:Bool):Void
	{
		_highlighted = status;
		_highlightMarker.visible = _highlighted;		

		if (_highlighted)
			_highlightMarker.width = width;
	}

	public function updateSize(nameWidth:Float, windowWidth:Float):Void
	{
		var textWidth = windowWidth - _icon.width - GUTTER * 2 - _lockButton.width - GUTTER - _visibilityButton.width - GUTTER;

		_icon.x = GUTTER;
		_nameText.x = _icon.x + _icon.width + GUTTER;
		_nameText.width = nameWidth;
		_lockButton.x = textWidth + GUTTER;
		_visibilityButton.x = _lockButton.x + _lockButton.width + GUTTER;
		_highlightMarker.width = width;
	}
	
	function updateName()
	{
		if (entity != null)
			setNameText(entity.name);
	}
	
	function setNameText(name:String)
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
		// TODO: check this
		return _nameText.textWidth + GUTTER * 2 + _lockButton.width; 
	}
	
	public function destroy()
	{
		_nameText = FlxDestroyUtil.removeChild(this, _nameText);
		_icon = FlxDestroyUtil.removeChild(this, _icon);
		_visibilityButton = FlxDestroyUtil.removeChild(this, _visibilityButton);
		_lockButton = FlxDestroyUtil.removeChild(this, _lockButton);
		_highlightMarker = FlxDestroyUtil.removeChild(this, _highlightMarker);
	}
}