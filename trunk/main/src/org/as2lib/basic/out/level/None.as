import org.as2lib.basic.out.OutLevel;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.None implements OutLevel {
	/**
	 * @see org.as2lib.basic.out.Level
	 */
	public function log(message:String):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.Level
	 */
	public function debug(message:String):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.Level
	 */
	public function info(message:String):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.Level
	 */
	public function warning(message:String):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.Level
	 */
	public function error(exception:Exception):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.Level
	 */
	public function fatal(exception:Exception):Void {
	}
}