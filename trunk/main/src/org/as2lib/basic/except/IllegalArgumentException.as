import org.as2lib.basic.except.Exception;

class org.as2lib.basic.except.IllegalArgumentException extends Exception {
	public function IllegalArgumentException(message:String, thrower:Object, args:FunctionArguments) {
		super (message, thrower, args);
	}
}