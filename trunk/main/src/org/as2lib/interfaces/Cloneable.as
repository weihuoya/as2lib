/**
* A class implements the Cloneable interface to indicate, that it supports making field-for-field copies of it's instances.
* 
* @author					Michael Herrmann
* 
* @date						20.11.03
*/

interface org.as2lib.basic.interfaces.Cloneable {
	/**
	* Creates and returns a copy of this object. The precise meaning of "clone" may depend on the class of the object. 
	* The general intent is that, for any object x, the expression: 
	* 	x.clone() != x
	* will be true, and that x.clone() returns an instance of the same class as x is, but these are not absolute requirements. 
	* 
	* @return				A field-for-field copy of the object.
	*/
	public function clone():Object;
}