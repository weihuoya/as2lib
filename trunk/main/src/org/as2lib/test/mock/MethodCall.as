/**
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

import org.as2lib.core.BasicClass;
import org.as2lib.test.mock.ArgumentsMatcher;
import org.as2lib.test.mock.support.DefaultArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.MethodCall extends BasicClass {
	
	/** The name of the called method. */
	private var methodName:String;
	
	/** The arguments passed to the method. */
	private var args:Array;
	
	/** The matcher that compares expected and actual arguments. */
	private var argumentsMatcher:ArgumentsMatcher;
	
	/**
	 * Constructs a new MethodCall instance.
	 *
	 * @param methodName the name of the called method
	 * @param args the arguments used for the method call
	 */
	public function MethodCall(methodName:String, args:Array) {
		this.methodName = methodName;
		this.args = args ? args : new Array();
	}
	
	/**
	 * @return the name of the called method
	 */
	public function getMethodName(Void):String {
		return methodName;
	}
	
	/**
	 * @return the arguments used for the method call
	 */
	public function getArguments(Void):Array {
		return args;
	}
	
	/**
	 * Returns the currently used arguments matcher.
	 * 
	 * <p>That is either the arguments matcher set via setArgumentsMatcher(ArgumentsMatcher):Void
	 * or an instance of the default DefaultArgumentsMatcher.
	 *
	 * @return the currently used arguments matcher
	 */
	public function getArgumentsMatcher(Void):ArgumentsMatcher {
		if (!argumentsMatcher) argumentsMatcher = new DefaultArgumentsMatcher();
		return argumentsMatcher;
	}
	
	/**
	 * Sets the new arguments matcher.
	 * 
	 * <p>If you set an arguments matcher of value null or undefined the
	 * #getArgumentsMatcher(Void):ArgumentsMatcher method returns the default
	 * one.
	 *
	 * @param argumentsMatcher the new arguments matcher
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		this.argumentsMatcher = argumentsMatcher;
	}
	
	/**
	 * Checks whether this method call matches the passed-in one.
	 *
	 * <p>Falls will be returned if:
	 * <ul>
	 *   <li>The passed-in method call is null or undefined.</li>
	 *   <li>The method names do not match.</li>
	 *   <li>The arguments do not match.</li>
	 * </ul>
	 *
	 * @param methodCall the method call to compare with this instance
	 */
	public function matches(methodCall:MethodCall):Boolean {
		if (!methodCall) return false;
		if (methodName != methodCall.getMethodName()) return false;
		return getArgumentsMatcher().matchArguments(args, methodCall.getArguments() ? methodCall.getArguments() : new Array());
	}
	
	/**
	 * @see BasicInterface#toString(Void):String
	 */
	public function toString(Void):String {
		return (methodName + "(" + args + ")");
	}
	
}