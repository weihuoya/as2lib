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
import org.as2lib.util.Executable;

/**
 * Call is used to enable another object to make a function call in another
 * scope without having to know where. This enables you to pass a Call to another
 * object and let the object execute the call.
 *
 * @author Simon Wacker
 */
class org.as2lib.util.Call extends BasicClass implements Executable {
	/** The object to execute the Function one. */
	private var object;
	
	/** The Function to be executed. */
	private var func:Function;
	
	/** The arguments passed to the Function on execution. */
	private var args:Array;
	
	/**
	 * Constructs a new Call instance.
	 *
	 * @param object the object the Function shall be executed on
	 * @param func the Function that shall be executed
	 * @param args the arguments that shall be passed
	 */
	public function Call(object, func:Function, args:Array) {
		this.object = object;
		this.func = func;
		this.args = args;
	}
	
	/**
	 * @see org.as2lib.util.Executable#execute()
	 */
	public function execute(Void) {
		return func.apply(object, args);
	}
}