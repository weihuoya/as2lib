/**
* A class implements the Classifiable interface to indicate that it supports getting it's constructor through it's instances.  
* 
* @author					Michael Herrmann
* 
* @date						20.11.03
*/
interface org.as2lib.basic.interfaces.Classifiable {
	/**
	* Returns the runtime class of an object. 
	* 
	* @return				The object's class' constructor
	*/
	public function getClass():Function;
}