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
	
	private var methodName:String;
	private var args:Array;
	private var argumentsMatcher:ArgumentsMatcher;
	
	public function MethodCall(methodName:String, args:Array) {
		this.methodName = methodName;
		this.args = args ? args : new Array();
	}
	
	public function getMethodName(Void):String {
		return methodName;
	}
	
	public function getArguments(Void):Array {
		return args;
	}
	
	public function getArgumentsMatcher(Void):ArgumentsMatcher {
		if (!argumentsMatcher) argumentsMatcher = new DefaultArgumentsMatcher();
		return argumentsMatcher;
	}
	
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		this.argumentsMatcher = argumentsMatcher;
	}
	
	public function matches(methodCall:MethodCall):Boolean {
		if (!methodCall) return false;
		if (methodName != methodCall.getMethodName()) return false;
		return getArgumentsMatcher().matchArguments(args, methodCall.getArguments() ? methodCall.getArguments() : new Array());
	}
	
	public function toString(Void):String {
		return (methodName + "(" + args + ")");
	}
	
}