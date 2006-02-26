/* See LICENSE for copyright and terms of use */

import org.actionstep.constants.ASConstantValue;

/**
 * Used by NSRect.divideRect to determine how to slice the rectangle in 
 * question.
 * 
 * @see org.actionstep.NSRect
 * @author Scott Hyndman
 */
class org.actionstep.constants.NSRectEdge extends ASConstantValue
{
	/**
	 * The inRect parameter is sliced vertically. The amount parameter will 
	 * specify the distance from the minimum x edge to place in slice.
	 */
	public static var NSMinXEdge:NSRectEdge = new NSRectEdge(0);
	
	/**
	 * The inRect parameter is sliced horizontally. The amount parameter will
	 * specify the distance from the minimum y edge to place in slice.
	 */
	public static var NSMinYEdge:NSRectEdge = new NSRectEdge(1);
	
	/**
	 * The inRect parameter is sliced vertically. The amount parameter will 
	 * specify the distance from the maximum x edge to place in slice.
	 */
	public static var NSMaxXEdge:NSRectEdge = new NSRectEdge(2);
	
	/**
	 * The inRect parameter is sliced horizontally. The amount parameter will
	 * specify the distance from the maximum y edge to place in slice.
	 */
	public static var NSMaxYEdge:NSRectEdge = new NSRectEdge(3);
			
	/**
	 * Constructs a new instance of NSRectEdge.
	 * 
	 * This method should never be called.
	 */
	private function NSRectEdge(value:Number) 
	{
		super(value);
	}
}