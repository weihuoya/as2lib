import org.as2lib.env.except.Exception;

class org.as2lib.tool.changelog.FileNotFoundException extends Exception {

	public function FileNotFoundException(message:String, thrower, args:FunctionArguments) {
		super(message, thrower, args);
	}
}