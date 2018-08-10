package flixel.addons.studio;

import flash.display.BitmapData;
import flash.errors.Error;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets;
import flixel.system.debug.Window;
import flixel.text.FlxText;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.util.FlxStringUtil;
import openfl.Assets;

import flixel.addons.studio.tools.Tile;
import flixel.addons.studio.core.Properties;

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */

class FlxStudio extends Window
{	
	public static var instance:FlxStudio;

	var _properties:Properties;

	// TODO: choose a good name for this
	public static function bootstrap():Void
	{
		FlxStudio.instance = new FlxStudio();
	}

	/**
	 * TODO: add docs
	 */
	public function new()
	{
		super("FlxStudio");

		visible = false;
		_properties = new Properties();
		addInteractionTools();

		FlxG.game.debugger.addWindow(this);
	}

	override public function update():Void
	{
		super.update();
		_properties.update();
	}

	/**
	 * TODO: add docs
	 */
	function addInteractionTools():Void
	{
		FlxG.game.debugger.interaction.addTool(new Tile());
	}
}
