import org.as2lib.except.Throwable;
import org.as2lib.core.BasicInterface;
import org.as2lib.except.AbstractException;
import org.as2lib.Config;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.except.Exception extends AbstractException implements Throwable {
	/**
	 * Constructs a new Exception instance.
	 */
	public function Exception(message:String, thrower, args:FunctionArguments) {
		super(message, thrower, args);
	}
	
	public function toString(Void):String {
		Config.out.error(this);
		return "";
	}
}