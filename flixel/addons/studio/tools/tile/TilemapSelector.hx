package flixel.addons.studio.tools.tile;

import flash.display.Sprite;
import flash.text.TextField;
import flixel.system.debug.FlxDebugger.GraphicArrowLeft;
import flixel.system.debug.FlxDebugger.GraphicArrowRight;
import flixel.system.ui.FlxSystemButton;
import flixel.addons.studio.tools.Tile.GraphicTileTool;

using flixel.system.debug.DebuggerUtil;

/**
 * UI component to navigate among the available tilemaps.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class TilemapSelector extends Sprite
{
	private var _prev:FlxSystemButton;
	private var _next:FlxSystemButton;
	private var _text:TextField;
	private var _tileTool:Tile;
		
	public function new(tileTool:Tile) 
	{
		super();
		_tileTool = tileTool;
		_text = DebuggerUtil.createTextField(2, -3);

		_prev = new FlxSystemButton(Type.createInstance(GraphicArrowLeft, [0, 0]), prev);
		_next = new FlxSystemButton(Type.createInstance(GraphicArrowRight, [0, 0]), next);
		
		_prev.x = 0;
		_text.x = _prev.x + _prev.width + 5;
		_next.x = _text.x + 70;
		
		addChild(_prev);
		addChild(_text);
		addChild(_next);
		
		refresh();
	}
	
	public function refresh():Void
	{
		// TODO: replace this with tilemap name? Is there any API for that?
		_text.text = "tilemap_" + _tileTool.activeTilemap;
		
		_prev.visible = _tileTool.activeTilemap > 0;
		_next.visible = _tileTool.activeTilemap < _tileTool.tilemaps.length - 1;
	}
	
	private function next():Void
	{
		_tileTool.activeTilemap++; 
		refresh();
	}
	
	private function prev():Void
	{
		_tileTool.activeTilemap--; 
		refresh();
	}
}