import org.as2lib.env.except.FatalException;

class org.as2lib.env.overload.UnknownOverloadHandlerException extends FatalException {
	public function UnknownOverloadHandlerException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}