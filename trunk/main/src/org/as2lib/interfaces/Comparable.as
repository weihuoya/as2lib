/**
* A Class implements the comparable interface to indicate, that it supports the less discriminating
* way of comparing objects than through the == operator - the equals method. The equals method should
* only accept instances of the same class as the object whose equals method is invoked. The
* method starts a field-for-field comparison between the two objects, and returns true if all compared 
* fields have the same value. 
* 
* @author					Michael Herrmann
* 
* @date						21.11.03
*/
interface org.as2lib.basic.interfaces.Comparable {
	/**
	* Compares every field of this and the specified object. 
	* 
	* @return				True if all fields have the same value, false otherwise
	*/
	public function equals(obj:Object):Boolean;
}