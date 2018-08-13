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
 * A tool to select and move tiles in tilemaps
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class Pointer extends TileSubTool
{		
	public function new(tileTool:Tile) 
	{
		super(tileTool);
	}
	
	override public function init(brain:Interaction):Tool 
	{
		super.init(brain);

		_name = "Tile pointer";
		setButton(GraphicTileTool);
		setCursor(new GraphicTileTool(0, 0));
		
		return this;
	}
	
	override public function activate():Void 
	{
		super.activate();
		_tileBrain.refresh();
		_tileBrain.properties.setVisible(true);
	}
	
	override public function deactivate():Void 
	{
		super.deactivate();
		_tileBrain.properties.setVisible(false);
	}
	
	override public function update():Void 
	{		
		super.update();
		
		// If the tool is not active, do nothing.
		if (!isActive())
			return;
	}
	
	override public function draw():Void 
	{
		// If the tool is not active, do nothing.
		if (!isActive())
			return;
	}
}