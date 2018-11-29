package flixel.addons.studio.utils;

import flixel.math.FlxMath;

/**
 * Contain several methods to perform small, self-contained tasks regarding
 * formatting data, e.g. print a float with only two digits.
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class Formatter
{		
	public static function prettifyFloat(number:Float):String
	{
		var value = FlxMath.roundDecimal(cast number, FlxG.debugger.precision);
		return Std.string(value);
	}
}
