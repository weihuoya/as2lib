import org.as2lib.except.FatalException;

class org.as2lib.core.overload.OverloadException extends FatalException {
	public function OverloadException(message:String, thrower:Object, args:FunctionArguments) {
		super (message, thrower, args);
	}
}