/* See LICENSE for copyright and terms of use */

import org.actionstep.images.ASScrollerUpArrowRep;
import org.actionstep.NSSize;

/**
 * An image shown in a table column header if the column has a ascending sort
 * applied to it.
 * 
 * @author Scott Hyndman
 */
class org.actionstep.images.ASSortUpIndicatorRep 
	extends ASScrollerUpArrowRep 
{
	/**
	 * Creates a new instance of the ASSortIndicatorDownRep class.
	 */
	public function ASSortUpIndicatorRep() 
	{
		m_size = new NSSize(6,6);
	}


	/**
	 * @see org.actionstep.NSObject#description
	 */
	public function description():String 
	{
		return "ASSortUpIndicatorRep";
	}
}