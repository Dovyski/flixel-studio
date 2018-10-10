package flixel.addons.studio.core;

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
		add(new LibraryItem("flixel.FlxSprite"));
	}

	public function add(item:LibraryItem):Void
	{
		_list.push(item);
	}

	public function findAll():Array<LibraryItem>
	{
		return _list;
	}
	#end
}
