package flixel.addons.studio.ui;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flixel.math.FlxPoint;
import flixel.system.ui.FlxSystemButton;
import flixel.system.debug.FlxDebugger.GraphicCloseButton;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.addons.studio.core.Entities;
import flixel.addons.studio.core.Library;
import flixel.addons.studio.core.LibraryItem;

using flixel.system.debug.DebuggerUtil;

@:bitmap("assets/images/icons/library-item.png") 
class GraphicLibraryDefaultIcon extends BitmapData {}

/**
 * TODO: add docs
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class LibraryIcon
{
	public function new() {}

	public static function createFromBitmapDataClass(iconClass:Class<BitmapData>):Bitmap
	{
		var whichClass:Class<BitmapData> = iconClass;
		var data:BitmapData = Type.createInstance(whichClass, [0, 0]);
		var icon:Bitmap = new Bitmap(data);

		return icon;
	}

	public static function createFromFlxGraphicAsset(graphic:FlxGraphicAsset, animated:Bool = false, width:Int = 0, height:Int = 0):Bitmap
	{
		var sprite:FlxSprite = new FlxSprite();
		sprite.loadGraphic(graphic, animated, width, height);
		var icon:Bitmap = new Bitmap(sprite.framePixels);
		
		return icon;
	}

	public static function create():Bitmap
	{
		return createFromBitmapDataClass(GraphicLibraryDefaultIcon);
	}
}
