import org.as2lib.basic.out.Handler;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.handler.Trace implements Handler {
	/**
	 * @see org.as2lib.basic.out.Handler
	 */
	public function write(message:String):Void {
		trace (message);
	}
	
	/**
	 * @see org.as2lib.basic.out.Handler
	 */
	public function error(exception:Exception):Void {
		//trace (ExceptionUtil.toString(exception));
	}
}