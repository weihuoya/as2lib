/**
 * Basic Enumeration Class for an Array.
 *
 * @autor Hamster2k
 */

class org.as2lib.Enumeration {
	
	// Current selected Element
	private var currentElement:Number;
	// Private Array to work within
	private var targetArray:Array;
	
	/**
	 * @param [targetArray]	Array that should be listened to
	 */
	public function Enumeration(targetArray:Array) {
		this.currentElement = 0;
		if (!targetArray) {
			this.targetArray = new Array();
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