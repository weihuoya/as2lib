import org.as2lib.basic.Exception;

class org.as2lib.basic.overload.OverloadException extends Exception {
	public function OverloadException(message:String, thrower:Object, args:FunctionArguments) {
		super (message, thrower, args);
	}
}