import org.as2lib.basic.Exception

/**
 * Exception if an Object should be created that is Allready defined.
 *
 * @autor Martin Heidegger
 * @date 14.11.2003
 * 
 * @see Exception
 */

class org.as2lib.basic.exceptions.ObjectAllreadyDefinedException extends Exception{
	// Name of the Exception
	public var name:String = "ObjectAllreadyDefinedException";
	
	/**
	 * Code passing to the SuperClass
	 *
	 * @param message		Message for the Exception
	 * @param location		Location of the Exception
	 * @param inFunction	Name of the Function that has been called
	 * @param thearguments	Arguments that are used in that Function
	 * 
	 * @see Exception
	 */
	function ObjectAllreadyDefinedException (message:String, location:String, inFunction:String, thearguments:Array) {
		super(message, location, inFunction, thearguments);
	}	
}