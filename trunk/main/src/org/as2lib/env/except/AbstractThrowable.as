/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.except.ThrowableStringifier;
import org.as2lib.util.Stringifier;

/**
 * AbstractThrowable is an abstract class that contains sourced out functionalities
 * used by both the classes Exception and the class FatalException. It is
 * thought to be an abstract implementation of the Throwable interface.
 *
 * @author Simon Wacker
 * @see Error
 */
class org.as2lib.env.except.AbstractThrowable extends Error {
	
	/** Stringifier used to stringify throwables. */
	private static var stringifier:Stringifier;
	
	/** 
	 * Logger used to output the exception.
	 * Not typed because typing would add dependency on the logging module.
	 * (org.as2lib.env.log)
	 */
	private static var logger;
	
	/** The saved stack of operation calls. */
	private var stackTrace:Array;
	
	/** The Throwable that caused this Throwable to be thrown. */
	private var cause:Throwable;
	
	/** The message describing what was wrong. */
	private var message:String;
	
	/**
	 * Returns the stringifier to stringify throwables.
	 *
	 * <p>The returned stringifier is either the default ThrowableStringifier
	 * if no custom stringifier was set or if the stringifier was set to null.
	 *
	 * @return the current stringifier
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new ThrowableStringifier();
		return stringifier;
	}
	
	/**
	 * Sets the stringifier to stringify throwables.
	 *
	 * <p>If you set a stringifier of value null #getStringifier(Void):Stringifier
	 * returns the default stringifier.
	 *
	 * @param throwableStringifier the stringifier to stringify throwables
	 */
	public static function setStringifier(throwableStringifier:Stringifier):Void {
		stringifier = throwableStringifier;
	}
	
	/**
	 * Returns the logger used to output the exception.
	 *
	 * <p>This method's return type is not specified because this would
	 * introduce dependency on the logging module (org.as2lib.env.log).
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The logging module is not included.</li>
	 *   <li>The logger repository's getLogger-method returns null.</li>
	 * </ul>
	 * 
	 * @return the logger used to output the exception
	 */
	private static function getLogger(Void) {
		if (logger === undefined) {
			var repositoryManager = eval("_global." + "org.as2lib.env.log.LoggerRepositoryManager");
			if (repositoryManager) {
				logger = repositoryManager.getRepository().getLogger("org.as2lib.env.except.Throwable");
			} else {
				logger = null;
			}
		}
		return logger;
	}
	
	/**
	 * The private constructor.
	 *
	 * @param message the message describing what went wrong
	 * @param thrower the instance that throwed the Throwable
	 * @param args the arguments of the throwing operation
	 */
	private function AbstractThrowable(message:String, thrower, args:Array) {
		stackTrace = new Array();
		this.message = message;
		addStackTraceElement(thrower, args.callee, args);
		// TODO: Implement findMethod to display the next line correctly.
		// addStackTraceElement(undefined, args.caller, new Array());
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#addStackTraceElement()
	 */
	public function addStackTraceElement(thrower, method:Function, args:Array):Void {
		stackTrace.push(new StackTraceElement(thrower, method, args));
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#getStack()
	 */
	public function getStackTrace(Void):Array {
		return stackTrace;
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#getCause()
	 */
	public function getCause(Void):Throwable {
		return cause;
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#initCause()
	 */
	public function initCause(newCause:Throwable):Throwable {
		if (!newCause) throw new IllegalArgumentException("Cause must not be null or undefined.", this, arguments);
		if (cause) throw new IllegalStateException("The cause [" + cause + "] has already been initialized.", this, arguments);
		cause = newCause;
		return Throwable(this);
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#getMessage()
	 */
	public function getMessage(Void):String {
		return message;
	}
	
}