import org.as2lib.env.except.Exception;
import org.as2lib.env.event.EventInfo;

/**
 *
 * @author Christoph Atteneder
 * @see org.as2lib.env.except.Exception
 */
class org.as2lib.data.io.conn.ConnectorError extends Exception implements EventInfo{
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	private var isConError:Boolean;
	private var isServError:Boolean;
	/** Name of the event */
	private var name:String;
		 
	public function ConnectorError(message:String,
								   thrower,
								   args:FunctionArguments,
								   isConError:Boolean,
								   isServError:Boolean) {
		
		super (message, thrower, args);
		name = "onError";
		this.isConnectionError = isConnectionError;
		this.isServerError = isServerError;
	}
	
	/**
	 * @return The specified name.
	 */
	public function getName(Void):String {
		return this.name;
	}
	
	public function isConnectionError(Void):Boolean {
		return isConError;
	}
	
	public function isServerError(Void):Boolean {
		return isServError;
	}
}