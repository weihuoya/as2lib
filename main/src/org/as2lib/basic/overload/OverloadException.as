import org.as2lib.basic.except.FatalException;

class org.as2lib.basic.overload.OverloadException extends FatalException {
	public function OverloadException(message:String, thrower:Object, args:FunctionArguments) {
		super (message, thrower, args);
	}
}