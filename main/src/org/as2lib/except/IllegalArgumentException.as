import org.as2lib.except.Exception;

class org.as2lib.except.IllegalArgumentException extends Exception {
	public function IllegalArgumentException(message:String, thrower
											 , args:FunctionArguments) {
		super (message, thrower, args);
	}
}