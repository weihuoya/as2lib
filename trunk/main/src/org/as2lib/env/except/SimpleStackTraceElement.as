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