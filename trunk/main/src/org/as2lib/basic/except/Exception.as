﻿import org.as2lib.basic.except.Throwable;
import org.as2lib.basic.BasicInterface;
import org.as2lib.basic.except.AbstractException;
import org.as2lib.Config;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.except.Exception extends AbstractException implements Throwable {
	/**
	 * Constructs a new Exception instance.
	 */
	public function Exception(message:String, thrower, args:FunctionArguments) {
		super(message, thrower, args);
	}
	
	public function toString(Void):String {
		Config.out.error(this);
		return "";
	}
}