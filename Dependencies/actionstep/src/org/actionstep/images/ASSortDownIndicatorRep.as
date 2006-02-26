/* See LICENSE for copyright and terms of use */

import org.actionstep.images.ASScrollerDownArrowRep;
import org.actionstep.NSSize;

/**
 * An image shown in a table column header if the column has a descending sort
 * applied to it.
 * 
 * @author Scott Hyndman
 */
class org.actionstep.images.ASSortDownIndicatorRep 
	extends ASScrollerDownArrowRep 
{
	/**
	 * Creates a new instance of the ASSortIndicatorDownRep class.
	 */
	public function ASSortDownIndicatorRep() 
	{
		m_size = new NSSize(6,6);
	}


	/**
	 * @see org.actionstep.NSObject#description
	 */
	public function description():String 
	{
		return "ASSortDownIndicatorRep";
	}
}