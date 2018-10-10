package flixel.addons.studio.core;

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

	public function new(className:String, name:String = "", icon:Class<BitmapData> = null, params:Array<Dynamic> = null, tags:Array<String> = null)
	{
		if (className == null || className == "")
			throw "Invalid class name for library item.";

		this.className = className;
		this.name = name;
		this.icon = createIcon(icon);
		this.params = params == null ? [] : params;
		this.tags = tags == null ? [] : tags;
	}

	function createIcon(iconBitmapDataClass:Class<BitmapData>):Bitmap
	{
		var whichClass:Class<BitmapData> = iconBitmapDataClass == null ? GraphicLibraryItemDefaultIcon : iconBitmapDataClass;
		var data:BitmapData = Type.createInstance(whichClass, [0, 0]);
		var icon:Bitmap = new Bitmap(data);

		return icon;	
	}
	#end
}
