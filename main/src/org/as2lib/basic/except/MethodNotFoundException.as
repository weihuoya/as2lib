import org.as2lib.basic.Exception;

class org.as2lib.basic.except.MethodNotFoundException extends Exception {
	public function IllegalArgumentException(message:String, thrower:Object, args:FunctionArguments) {
		super (message, thrower, args);
	}
}