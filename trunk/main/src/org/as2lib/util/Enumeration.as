import org.as2lib.basic.exceptions.*

/**
 * Basic Enumeration Class for an Array.
 *
 * @autor Michael Herrmann
 */

class org.as2lib.util.Enumeration {
	
	// Current selected Element
	private var currentElement:Number;
	// Private Array to work within this Class.
	private var targetArray:Array;
	
	/**
	 * @param [targetArray]	Array that should be listened to
	 */
	public function Enumeration(targetArray:Array) {
		this.currentElement = 0;
		if (!targetArray) {
			throw new MissingArgumentException("org.as2lib.util.Enumeration", "", 1, 0, arguments);
		} else {
			this.targetArray = targetArray;
		}
	}
	
	/**
	 * @return	true if more Elements are available
	 */
	public function hasMoreElements():Boolean {
		return(this.currentElement<this.targetArray.length);
	}
	
	/**
	 * Sets the Index one Step further. 
	 *
	 * @return	Next Element
	 */
	public function getNextElement():Object {
		return this.hasMoreElements() ? this.getElement(this.currentElement++) : null;
	}
	
	
	/**
	 * Method to get the Element registered at an Index
	 *
	 * @param index		Position from the Element
	 * 
	 * @return	Content @ Position from Index
	 */
	private function getElement(index:Number):Object {
		return this.targetArray[index];
	}
}