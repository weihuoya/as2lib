/**
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.basic.out.OutHandler {
	/**
	 * Writes a message to the output target.
	 * @param message
	 */
	public function write(message:String):Void;
	
	/**
	 * Writes the String appearance of an exception to the output target.
	 * @param exception
	 */
	public function error(exception:Exception):Void;
}