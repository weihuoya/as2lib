/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
interface org.as2lib.basic.out.level.Level {
	/**
	 * Log a message.
	 * @param message The message to be logged.
	 */
	public function log(message:String):Void;
	
	/**
	 * Log a message with the DEBUG priority.
	 * @param message The message to be logged.
	 */
	public function debug(message:String):Void;
	
	/**
	 * Log a message with the INFO priority.
	 * @param message The message to be logged.
	 */
	public function info(message:String):Void;
	
	/**
	 * Log a message with the WARNING priority.
	 * @param message The message to be logged.
	 */
	public function warning(message:String):Void;
	
	/**
	 * Log a message with the ERROR priority.
	 * @param message The message to be logged.
	 */
	public function error(exception:Exception):Void;
	
	/**
	 * Log a message with the FATAL priority.
	 * @param message The message to be logged.
	 */
	public function fatal(exception:Exception):Void;
}