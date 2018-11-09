package flixel.addons.studio.ui;

/**
 * Provide information regarding padding of an element, e.g. padding left.
 * The information follows the same structure of CSS padding info, i.e. top, right, bottom, left.
 * 
 * @author Fernando Bevilacqua <dovyski@gmail.com>
 */
class PaddingInfo
{
	public var top:Float;
	public var right:Float;	
	public var bottom:Float;
	public var left:Float;	

	/**
	 * Creates a new object.
	 */
	public function new(top:Float = 0, right:Float = 0, bottom:Float = 0, left:Float = 0)
	{
		this.top = top;
		this.right = right;		
		this.bottom = bottom;
		this.left = left;		
	}
}
