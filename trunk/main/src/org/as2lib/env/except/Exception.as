import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.except.AbstractException;
import org.as2lib.env.except.ExceptConfig;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.env.except.Exception extends AbstractException implements Throwable {
	/**
	 * Constructs a new Exception instance.
	 */
	public function Exception(message:String, thrower, args:FunctionArguments) {
		super(message, thrower, args);
	}
	
	public function toString(Void):String {
		ExceptConfig.getOut().error(this);
		return "";
	}
}