/**
*
*	@project : as2Lib
* 	@file : NoSuchElementException
*	@version : 0.2.0
*	@author : Yome - yomec@free.fr/ real.yome@wanadoo.fr
*	@date : 07/10/2003 - revised 11.03
*	@copyright : as2Lib
*
*/
import org.as2lib.basic.Exception;

// TO DO :
// TO PUT IN AS2LIB FORMAT

class org.as2lib.basic.exceptions.NoSuchElementException extends Exception
{
	/**Name of the Exception*/
	public var name:String = "NoSuchElementException";

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
	function MissingArgumentsException (message:String, location:String, inFunction:String, thearguments:Array)
	{
		super(message, location, inFunction, thearguments);
	}
}