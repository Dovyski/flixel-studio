package flixel.addons.studio.core;

import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.display.BitmapData;
import openfl.display.Bitmap;

@:bitmap("assets/images/icons/library-item.png") 
class GraphicLibraryItemDefaultIcon extends BitmapData {}

/**
 * Describe a content item that is displayed in the library
 * window and can be dragged into the screen by the user.
 *
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class LibraryItem
{
	#if FLX_DEBUG
	public var className(default, null):String;
	public var name(default, null):String;
	public var icon(default, null):LibraryItemIcon;
	public var params(default, null):Array<Dynamic>;
	public var tags(default, null):Array<Dynamic>;

	public function new(className:String, icon:LibraryItemIcon = null, name:String = "", params:Array<Dynamic> = null, tags:Array<String> = null)
	{
		if (className == null || className == "")
			throw "Invalid class name for library item.";

		this.className = className;
		this.icon = icon == null ? createDefaultIcon() : icon;
		this.name = name;
		this.params = params == null ? [] : params;
		this.tags = tags == null ? [] : tags;
	}

	public static function createIconFromBitmapDataClass(iconClass:Class<BitmapData>):LibraryItemIcon
	{
		var whichClass:Class<BitmapData> = iconClass;
		var data:BitmapData = Type.createInstance(whichClass, [0, 0]);
		var icon:LibraryItemIcon = new LibraryItemIcon(data);

		return icon;
	}

	public static function createIconFromFlxGraphicAsset(graphic:FlxGraphicAsset, animated:Bool = false, width:Int = 0, height:Int = 0):LibraryItemIcon
	{
		var sprite:FlxSprite = new FlxSprite();
		sprite.loadGraphic(graphic, animated, width, height);
		var icon:LibraryItemIcon = new LibraryItemIcon(sprite.framePixels);
		
		return icon;
	}

	public static function createDefaultIcon():LibraryItemIcon
	{
		return createIconFromBitmapDataClass(GraphicLibraryItemDefaultIcon);
	}
	#end
}

class LibraryItemIcon
{
	public var bitmapData(default, null):BitmapData;

	public function new(data:BitmapData)
	{
		this.bitmapData = data;
	}
}
