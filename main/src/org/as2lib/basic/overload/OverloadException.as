import org.as2lib.basic.FatalException;

class org.as2lib.basic.overload.OverloadException extends FatalException {
	public function OverloadException(message:String, thrower:Object, args:FunctionArguments) {
		super (message, thrower, args);
	}
}