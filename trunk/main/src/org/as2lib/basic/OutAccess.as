/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
interface org.as2lib.basic.OutAccess {
	/**
	 * Log a message.
	 * @param message
	 */
	public function log(message:String):Void;
	
	/**
	 * Log a message with the DEBUG priority.
	 * @param message
	 */
	public function debug(message:String):Void;
	
	/**
	 * Log a message with the INFO priority.
	 * @param message
	 */
	public function info(message:String):Void;
	
	/**
	 * Log a message with the WARNING priority.
	 * @param message
	 */
	public function warning(message:String):Void;
	
	/**
	 * Log a message with the ERROR priority.
	 * @param message
	 */
	public function error(exception:Exception):Void;
	
	/**
	 * Log a message with the FATAL priority.
	 * @param message
	 */
	public function fatal(exception:Exception):Void;
}