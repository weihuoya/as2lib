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

import org.as2lib.data.holder.Stack;
import org.as2lib.core.BasicInterface;

/**
 * Throwable is the basic interface for every class that will be thrown. You can
 * actually throw every class even if it does not implement this interface but it
 * is recommended to strictly use this interface for every Throwable. It produces 
 * clarity and builds a standard.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.except.Throwable extends BasicInterface {
	/**
	 * Returns a Stack of the operations that were called before this Throwable
	 * was thrown.
	 *
	 * @return a Stack containing the called operations
	 */
	public function getStackTrace(Void):Stack;
	
	/**
	 * Adds a StackTraceElement to the Stack trace.
	 *
	 * @param thrower the object that threw the Throwable
	 * @param method the operation that thew the Throwable
	 * @param args the arguments that caused the operation to throw the Throwable
	 */
	public function addStackTraceElement(thrower, method:Function, args:FunctionArguments):Void;
	
	/**
	 * Initializes the cause of the Throwable. The cause can only be initialized
	 * once. You normally initialize a cause if you throw a Throwable due to
	 * the throw of another Throwable. Thereby you will not lose the information
	 * the cause offers.
	 * This method returns itself to have an easy way to initialize the cause:
	 * <pre>throw new Throwable("error", this, arguments).initCause(e);</pre>
	 *
	 * @param a Throwable representing the cause of the new Throwable
	 * @return the Throwable itself.
	 * @throws org.as2lib.env.except.IllegalStateException
	 */
	public function initCause(cause:Throwable):Throwable;
	
	/**
	 * Returns the initialized cause.
	 *
	 * @return the initialized cause
	 */
	public function getCause(Void):Throwable;
	
	/**
	 * Returns the message that has been set via the constructor. The message
	 * should describe detailed what went wrong.
	 *
	 * @return the message set via the constructor
	 */
	public function getMessage(Void):String;
}