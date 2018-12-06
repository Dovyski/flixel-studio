package flixel.addons.studio.core;

import flash.display.Bitmap;
import flixel.FlxSprite;

/**
 * Manages all content that can be added into the game by dragging
 * and dropping items from the library window.
 *
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class Library
{
	var _list:Array<LibraryItem>;
	
	#if FLX_DEBUG
	public function new()
	{
		_list = [];

		// Add some default elements
		addFromObject(new LibraryItem("flixel.text.FlxText", null, "", [0, 0, 0, "text"]));
	}

	public function addFromObject(item:LibraryItem):Void
	{
		_list.push(item);
		FlxStudio.instance.itemAddedToLibrary.dispatch(item);
	}

	public function findAll():Array<LibraryItem>
	{
		return _list;
	}

	public function add(className:String, icon:Bitmap = null, name:String = "", params:Array<Dynamic> = null, tags:Array<String> = null):LibraryItem
	{
		var item:LibraryItem = new LibraryItem(className, icon, name, params, tags);
		addFromObject(item);

		return item;
	}	
	#end
}
