import org.as2lib.basic.Exception;

/**
 * Exception if a method was not passed by enough arguments
 *
 * @author						Michael Herrmann
 * @date						16.11.2003
 * 
 * @see							Exception
 */

class org.as2lib.basic.exceptions.MissingArgumentsException extends Exception {
	/**Name of the Exception*/
	public var name:String = "MissingArgumentsException";
	
	/**
	 * Code passing to the SuperClass
	 *
	 * @param location			Location of the Exception
	 * @param inFunction		Name of the Function that has been called
	 * @param theArguments		The specified arguments
	 * @param reqArguments		Number of required arguments
	 * 
	 * @see						org.as2lib.basic.Exception
	 */
	function MissingArgumentsException (location:String, inFunction:String, theArguments:Array, reqArguments:Number) {
		super("Not enough arguments provided: "+theArguments.length+" provided, "+reqArguments+" needed.", location, inFunction, theArguments);
	}	
}