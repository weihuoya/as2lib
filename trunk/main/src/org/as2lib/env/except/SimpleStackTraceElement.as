import org.as2lib.core.BasicClass;
import org.as2lib.env.except.ExceptConfig;
import org.as2lib.env.except.StackTraceElement;

/**
 * Simple implementation of the StackTraceElement interface.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.except.SimpleStackTraceElement extends BasicClass implements StackTraceElement {
	private var thrower;
	private var method:Function;
	private var args:FunctionArguments;
	
	public function SimpleStackTraceElement(thrower, method:Function, args:FunctionArguments) {
		this.thrower = thrower;
		this.method = method;
		this.args = args;
	}
	
	public function getThrower(Void) {
		return this.thrower;
	}
	
	public function getMethod(Void):Function {
		return this.method;
	}
	
	public function getArguments(Void):FunctionArguments {
		return this.args;
	}
	
	public function toString(Void):String {
		return ExceptConfig.getStackTraceElementStringifier().execute(this);
	}
}