import org.as2lib.except.FatalException;

class org.as2lib.overload.UnknownOverloadHandlerException extends FatalException {
	public function UnknownOverloadHandlerException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}