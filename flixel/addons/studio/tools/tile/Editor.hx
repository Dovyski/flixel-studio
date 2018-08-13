package flixel.addons.studio.tools.tile;

import flash.Vector;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.ui.Keyboard;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSpriteUtil;
import flixel.system.debug.Window;
import flixel.system.debug.interaction.Interaction;
import flixel.system.debug.interaction.tools.Tool;
import flixel.system.ui.FlxSystemButton;
import flixel.addons.studio.tools.Tile.GraphicTileTool;


/**
 * Allows the user to modify a tilemap.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class Editor extends TileSubTool
{		
	public function new(tileTool:Tile) 
	{
		super(tileTool);
	}
	
	override public function init(brain:Interaction):Tool 
	{
		super.init(brain);

		_name = "Tile editor";
		setButton(GraphicTileTool);
		setCursor(new GraphicTileTool(0, 0));
		
		return this;
	}
	
	override public function activate():Void 
	{
		super.activate();
		
		_tileBrain.refresh();
		_tileBrain.properties.setVisible(true);
		_tileBrain.palette.setVisible(true);
	}
	
	override public function deactivate():Void 
	{
		super.deactivate();
		_tileBrain.properties.setVisible(false);
		_tileBrain.palette.setVisible(false);
	}
	
	override public function update():Void 
	{		
		super.update();
		
		// If the tool is not active, do nothing.
		if (!isActive())
			return;
		
		if (_brain.pointerPressed)
		{
			if (_tileBrain.activeTilemap >= 0)
				var b :Bool = _tileBrain.tilemaps[_tileBrain.activeTilemap].setTile(Std.int(_brain.flixelPointer.x / _tileBrain.tileHightligh.width), Std.int(_brain.flixelPointer.y / _tileBrain.tileHightligh.height), _brain.keyPressed(Keyboard.DELETE) ? 0 : _tileBrain.palette.selectedTile);
		}
	}
	
	override public function draw():Void 
	{
		// If the tool is not active, do nothing.
		if (!isActive())
			return;
		
		_tileBrain.tileHightligh.drawDebug();
		drawTileLinesAroundCursor();
	}
	
	private function drawTileLinesAroundCursor():Void
	{
		var tile:FlxSprite = _tileBrain.tileHightligh.clone(); // TODO: remove the clone() call!
		var amount:Int = 7;
		var amountHalf:Int = Std.int(amount / 2);
		
		for (row in -amountHalf...amountHalf + 1)
		{
			for (col in -amountHalf...amountHalf + 1)
			{
				tile.x = _tileBrain.tileHightligh.x + _tileBrain.tileHightligh.width * col;
				tile.y = _tileBrain.tileHightligh.y + _tileBrain.tileHightligh.height * row;
				
				drawTileOutline(tile);
			}
		}
	}
	
	// TODO: replace FlxSprite with rect probably
	private function drawTileOutline(sprite:FlxSprite):Void
	{
		var gfx:Graphics = _brain.getDebugGraphics();
		
		if (gfx == null)
			return;
		
		// Render a red rectangle centered at the selected item
		gfx.lineStyle(0.7, 0x990000, 0.15);
		gfx.drawRect(sprite.x - FlxG.camera.scroll.x,
			sprite.y - FlxG.camera.scroll.y,
			sprite.width * 1.0, sprite.height * 1.0);
		
		// Draw the debug info to the main camera buffer.
		if (FlxG.renderBlit)
			FlxG.camera.buffer.draw(FlxSpriteUtil.flashGfxSprite);
	}
}