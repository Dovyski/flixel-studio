package flixel.addons.studio.tools.tile;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.system.debug.Window;
import flixel.addons.studio.tools.Tile.GraphicTileTool;

/**
 * Window displayed when the user clicks the tile editing tool.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class TileSelectionWindow extends Window
{
	public var selectedTile(default, null):Int;
	
	private var _tileTool:Tile;
	private var _tileHightligh:Sprite;
	private var _tileSelected:Sprite;
	private var _tilemap:FlxTilemap;
	private var _tilemapGraphic:Sprite;
	private var _tilemapBitmap:Bitmap;
	private var _graphicTile:FlxPoint;
	
	private function initLayout():Void
	{
		_tilemapGraphic = new Sprite();
		_tilemapBitmap = new Bitmap();
		
		_tilemapGraphic.addChild(_tilemapBitmap);
		
		_tilemapGraphic.y = 20;
		_tilemapGraphic.scaleX = 2; // TODO: get values from Flixel
		_tilemapGraphic.scaleY = 2; // TODO: get values from Flixel
		
		addChild(_tilemapGraphic);
	}
	
	private function adjustComponentSizes(referenceTile:FlxSprite):Void
	{	
		_tileHightligh.graphics.clear();
		_tileHightligh.graphics.lineStyle(1, 0xee0000);
		_tileHightligh.graphics.drawRect(0, 0, referenceTile.width, referenceTile.height);
		_tileHightligh.width = referenceTile.width * FlxG.scaleMode.scale.x;
		_tileHightligh.height = referenceTile.height * FlxG.scaleMode.scale.y;
		
		_tileSelected.graphics.clear();
		_tileSelected.graphics.lineStyle(1, 0xff0000);
		_tileSelected.graphics.drawRect(0, 0, referenceTile.width, referenceTile.height);
		_tileSelected.width = referenceTile.width * FlxG.scaleMode.scale.x;
		_tileSelected.height = referenceTile.height * FlxG.scaleMode.scale.y;
	}
	
	public function new(tileTool:Tile, x:Float, y:Float) 
	{
		super("Tile palette", new GraphicTileTool(0, 0), 200, 100);
		_tileTool = tileTool;
		
		initLayout();
		
		_tileHightligh = new Sprite();
		_tileHightligh.x = _tilemapGraphic.x;
		_tileHightligh.y = _tilemapGraphic.y;
		_tileHightligh.visible = false;
		
		_tileSelected = new Sprite();
		_tileSelected.x = _tilemapGraphic.x;
		_tileSelected.y = _tilemapGraphic.y;
		_tileSelected.visible = true;
		
		_graphicTile = new FlxPoint();
		
		addChild(_tileSelected);
		addChild(_tileHightligh);
		
		reposition(x, y);
		
		_tilemapGraphic.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseOverGraphic);
		_tilemapGraphic.addEventListener(MouseEvent.MOUSE_UP, handleClickGraphic);
		_tilemapGraphic.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOverGraphic);
		
		visible = false;
	}
	
	public function refresh(tilemap:FlxTilemap):Void
	{
		_tilemap = tilemap;
		
		if (_tilemap != null)
		{
			resetSelectedTile();
			adjustComponentSizes(_tileTool.tileHightligh);
			
			_tilemapBitmap.bitmapData = _tilemap.frames.parent.bitmap;
			resize(_tilemapBitmap.bitmapData.width * 2 + 5, _tilemapBitmap.bitmapData.height * 2 + _tilemapGraphic.y + 5);
		}
	}
	
	private function handleMouseOverGraphic(event:MouseEvent):Void
	{		
		if (event.type == MouseEvent.MOUSE_MOVE)
		{
			_graphicTile.x = Math.floor(event.localX / _tileTool.tileHightligh.width) * _tileTool.tileHightligh.width;
			_graphicTile.y = Math.floor(event.localY / _tileTool.tileHightligh.height) * _tileTool.tileHightligh.height;
			
			updateHighlightedSelection();
		}
		else if (event.type == MouseEvent.MOUSE_OUT)
		{
			_tileHightligh.visible = false;
		}
	}
	
	private function resetSelectedTile():Void
	{
		_graphicTile.x = 0;
		_graphicTile.y = 0;
		
		updateHighlightedSelection();
		
		selectedTile = 0;
		_tileSelected.x = _tileHightligh.x;
		_tileSelected.y = _tileHightligh.y;
	}
	
	private function updateHighlightedSelection():Void
	{
		_tileHightligh.x = _graphicTile.x * FlxG.scaleMode.scale.x;
		_tileHightligh.y = _graphicTile.y * FlxG.scaleMode.scale.y;
		
		_tileHightligh.x += _tilemapGraphic.x;
		_tileHightligh.y += _tilemapGraphic.y;
		_tileHightligh.visible = true;
	}
	
	private function handleClickGraphic(event:MouseEvent):Void
	{
		selectTileBasedOnHighlightedSelection();
	}
	
	private function selectTileBasedOnHighlightedSelection():Void
	{
		var tilesPerRow:Int = Std.int(_tilemapBitmap.bitmapData.width / _tileTool.tileHightligh.width);
		var row:Int = Std.int(_graphicTile.y / _tileTool.tileHightligh.height);
		var column:Int = Std.int(_graphicTile.x / _tileTool.tileHightligh.width);
		var index = row * tilesPerRow + column;
		
		selectedTile = index;
		_tileSelected.x = _tileHightligh.x;
		_tileSelected.y = _tileHightligh.y;
	}
}