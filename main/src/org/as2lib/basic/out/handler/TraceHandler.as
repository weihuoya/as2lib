import org.as2lib.basic.out.OutHandler;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.handler.TraceHandler implements OutHandler {
	/**
	 * @see org.as2lib.basic.out.OutHandler
	 */
	public function write(message:String):Void {
		trace (message);
	}
	
	/**
	 * @see org.as2lib.basic.out.OutHandler
	 */
	public function error(exception:Exception):Void {
		//trace (ExceptionUtil.toString(exception));
	}
}