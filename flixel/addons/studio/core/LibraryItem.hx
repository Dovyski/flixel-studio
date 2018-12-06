package flixel.addons.studio.core;

import openfl.display.Bitmap;

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

	public function new(className:String, icon:Bitmap = null, name:String = "", params:Array<Dynamic> = null, tags:Array<String> = null)
	{
		if (className == null || className == "")
			throw "Invalid class name for library item.";

		this.className = className;
		this.icon = icon;
		this.name = name;
		this.params = params == null ? [] : params;
		this.tags = tags == null ? [] : tags;
	}
	#end
}
