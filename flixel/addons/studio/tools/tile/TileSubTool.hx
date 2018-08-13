package flixel.addons.studio.tools.tile;

import flixel.system.debug.interaction.tools.Tool;

/**
 * Base class extended by all tile tools.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class TileSubTool extends Tool
{		
	private var _tileBrain(default, null):Tile;

	public function new(tileTool:Tile) 
	{
		super();
		_tileBrain = tileTool;
	}
}