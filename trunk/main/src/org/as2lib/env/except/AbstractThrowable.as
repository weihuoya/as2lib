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
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;

/**
 * AbstractThrowable is an abstract class that contains sourced out
 * functionalities used by the classes Exception and FatalException.
 * 
 * <p>It is thought to be an abstract implementation of the Throwable
 * interface. Because of that sub-classes must implement the Throwable
 * interface if they are themselves not abstract.
 *
 * <p>This class extends the Error class. Thus you can use sub-classes
 * of it as throwable type in catch-blocks in Flex.
 *
 * @author Simon Wacker
 * @see Error
 * @see org.as2lib.env.except.Throwable
 */
class org.as2lib.env.except.AbstractThrowable extends Error {
	
	/** Stringifier used to stringify throwables. */
	private static var stringifier:Stringifier;
	
	/** Logger used to output the exception. */
	private static var logger:Logger;
	
	/** The saved stack of operation calls. */
	private var stackTrace:Array;
	
	/** The Throwable that caused this Throwable to be thrown. */
	private var cause;
	
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
	 * Returns the logger used to log/output the throwable.
	 *
	 * <p>Null will be returned if LogManager#getLogger returns null or
	 * undefined.
	 * 
	 * @return the logger used to output the throwable
	 */
	private static function getLogger(Void):Logger {
		if (logger === undefined) {
			logger = LogManager.getLogger("org.as2lib.env.except.Throwable");
		}
		return logger;
	}
	
	/**
	 * Constructs a new AbstractThrowable instance.
	 *
	 * <p>All arguments are allowed to be null or undefined. But if one is,
	 * the string representation returned by the #toString method is not
	 * complete anymore.
	 *
	 * <p>The args array should be the internal arguments array of the
	 * method that throws the throwable. The internal arguments array exists
	 * in every method and contains its parameters, the callee method and
	 * the caller method. You can refernce it in every method using the name
	 * 'arguments'.
	 *
	 * @param message the message that describes in detail what the problem is
	 * @param thrower the object that declares the method that throws this throwable
	 * @param args the arguments of the throwing method
	 */
	private function AbstractThrowable(message:String, thrower, args:Array) {
		this.message = message;
		stackTrace = new Array();
		addStackTraceElement(thrower, args.callee, args);
		// TODO: Implement findMethod to display the next line correctly.
		// addStackTraceElement(undefined, args.caller, new Array());
	}
	
	/**
	 * Adds a StackTraceElement instance to the stack trace.
	 *
	 * <p>The new stack trace element is added to the end of the stack trace.
	 *
	 * <p>At some parts in your application you may want to add stack trace
	 * elements manually. This can help you to get a clearer image of what
	 * went where wrong and why.
	 * You can use this method to do so.
	 *
	 * @param thrower the object that threw, rethrew or forwarded (let pass) the throwable
	 * @param method the method that threw, rethrew or forwarded (let pass) the throwable
	 * @param args the arguments the method was invoked with when throwing, rethrowing or forwarding (leting pass) the throwable
	 */
	public function addStackTraceElement(thrower, method:Function, args:Array):Void {
		stackTrace.push(new StackTraceElement(thrower, method, args));
	}
	
	/**
	 * Returns an array that contains StackTraceElement instances of the
	 * methods the were invoked before this throwable was thrown.
	 *
	 * <p>The last element is always the one that contains the actual method
	 * that threw the throwable.
	 *
	 * <p>The stack trace helps you a lot because it says you where the
	 * throwing of the throwable took place and also what arguments caused
	 * the throwing.
	 *
	 * <p>The returned stack trace is never null or undefined. If no stack
	 * trace element has been set an empty array gets returned.
	 *
	 * @return a stack containing the invoked methods until the throwable was thrown
	 */
	public function getStackTrace(Void):Array {
		return stackTrace;
	}
	
	/**
	 * Returns the initialized cause.
	 *
	 * <p>The cause is the throwable that caused this throwable to be thrown.
	 *
	 * @return the initialized cause
	 * @see #initCause
	 */
	public function getCause(Void) {
		return cause;
	}
	
	/**
	 * Initializes the cause of this throwable.
	 *
	 * <p>The cause can only be initialized once. You normally initialize 
	 * a cause if you throw a throwable due to the throwing of another throwable.
	 * Thereby you do not lose the information the cause offers.
	 * 
	 * <p>This method returns this throwable to have an easy way to initialize
	 * the cause.
	 * Following is how you could use the cause mechanism.
	 *
	 * <code>try {
	 *   myInstance.invokeMethodThatThrowsAThrowable();
	 * } catch (e:org.as2lib.env.except.Throwable) {
	 *   throw new MyThrowable("myMessage", this, arguments).initCause(e);
	 * }</code>
	 * 
	 * @param cause the throwable that caused the throwing of this throwable
	 * @return this throwable itself
	 * @throws org.as2lib.env.except.IllegalArgumentException if the passed-in cause is null or undefined
	 * @throws org.as2lib.env.except.IllegalStateException if the cause has already been initialized
	 * @see #getCause
	 */
	public function initCause(newCause):Throwable {
		if (!newCause) throw new IllegalArgumentException("Cause must not be null or undefined.", this, arguments);
		if (cause) throw new IllegalStateException("The cause [" + cause + "] has already been initialized.", this, arguments);
		cause = newCause;
		return Throwable(this);
	}
	
	/**
	 * Returns the message that describes in detail what went wrong.
	 *
	 * <p>The message should be understandable, even for non-programmers.
	 * It should contain detailed information about what went wrong. And
	 * maybe also how the user that sees this message can solve the problem.
	 *
	 * <p>If the throwable was thrown for example because of a wrong collaborator
	 * or an illegal string or something similar, provide the string representation
	 * of it in the error message. It is recommended to put these into '-signs.
	 *
	 * @return the message that describes the problem in detail
	 */
	public function getMessage(Void):String {
		return message;
	}
	
	/**
	 * Returns the string representation of this throwable.
	 *
	 * <p>The string representation is obtained via the stringifier
	 * returned by the static #getStringifier method.
	 *
	 * <p>If you want to change the string representation either set
	 * a new stringifier via the static #setStringifier method or if
	 * you wnat the string representation only change for one throwable
	 * and its sub-classes overwrite this method.
	 *
	 * @return the string representation of this throwable
	 */
	private function doToString(Void):String {
		return getStringifier().execute(this);
	}
	
}