package flixel.addons.studio.tools.tile;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.system.debug.Window;
import flixel.addons.studio.tools.Tile.GraphicTileTool;

using flixel.system.debug.DebuggerUtil;

/**
 * Displays information regarding available tilemaps as well as info
 * regarding the currently selected tilemap.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class TilemapWindow extends Window
{
	private var _tileTool:Tile;
	private var _tilemapSelector:TilemapSelector;
	private var _info:TextField;
	
	private function initLayout():Void
	{
		_tilemapSelector = new TilemapSelector(_tileTool);
		_tilemapSelector.y = 20;
		
		_info = DebuggerUtil.createTextField(2, _tilemapSelector.y + 20);

		addChild(_tilemapSelector);
		addChild(_info);
	}
	
	public function new(tileTool:Tile, x:Float, y:Float) 
	{
		super("Tilemap", null, 160, 90);
		_tileTool = tileTool;
		
		initLayout();
		reposition(x, y);
		
		visible = false;
	}
	
	public function refresh(activeTilemap:FlxTilemap):Void
	{
		if (activeTilemap == null)
			_info.text = "No tilemap is available.";
		else
		{
			var tileWidth:Int = cast activeTilemap.width / activeTilemap.widthInTiles;
			var tileHeight:Int = cast activeTilemap.height / activeTilemap.heightInTiles;
			
			// TODO: add some love to this layout
			_info.text = "Size (px):         " + activeTilemap.width + " x " + activeTilemap.height + "\n";
			_info.text += "Size (in tiles):    " + activeTilemap.widthInTiles + " x " + activeTilemap.heightInTiles + "\n";
			_info.text += "Tile size (px):      " + tileWidth + " x " + tileHeight;	
			
			_tilemapSelector.refresh();
		}
	}
}