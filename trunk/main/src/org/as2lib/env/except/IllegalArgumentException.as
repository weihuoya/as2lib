import org.as2lib.env.except.Exception;

class org.as2lib.env.except.IllegalArgumentException extends Exception {
	public function IllegalArgumentException(message:String, thrower
											 , args:FunctionArguments) {
		super (message, thrower, args);
	}
}