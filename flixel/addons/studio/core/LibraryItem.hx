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
	public var icon(default, null):Bitmap;
	public var params(default, null):Array<Dynamic>;
	public var tags(default, null):Array<Dynamic>;

	public function new(className:String, icon:Class<BitmapData> = null, name:String = "", params:Array<Dynamic> = null, tags:Array<String> = null)
	{
		if (className == null || className == "")
			throw "Invalid class name for library item.";

		this.className = className;
		this.name = name;
		this.params = params == null ? [] : params;
		this.tags = tags == null ? [] : tags;

		setIconFromBitmapDataClass(icon);
	}

	public function setIconFromBitmapDataClass(iconClass:Class<BitmapData>):Bitmap
	{
		var whichClass:Class<BitmapData> = iconClass == null ? GraphicLibraryItemDefaultIcon : iconClass;
		var data:BitmapData = Type.createInstance(whichClass, [0, 0]);
		var icon:Bitmap = new Bitmap(data);

		this.icon = icon;
		return this.icon;
	}

	public function setIconFromFlxGraphicsAsset(graphic:FlxGraphicAsset, animated:Bool = false, width:Int = 0, height:Int = 0):Bitmap
	{
		var sprite:FlxSprite = new FlxSprite();
		sprite.loadGraphic(graphic, animated, width, height);
		var icon:Bitmap = new Bitmap(sprite.framePixels);
		
		this.icon = icon;
		return this.icon;
	}
	#end
}
