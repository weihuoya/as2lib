﻿/**
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
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.test.mock.MockControlState;
import org.as2lib.test.mock.MethodBehavior;
import org.as2lib.test.mock.Behavior;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.RecordState extends BasicClass implements MockControlState {
	
	/** Used to add and get method behaviors. */
	private var behavior:Behavior;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param behavior used to add and get method call behaviors
	 */
	public function RecordState(behavior:Behavior) {
		if (!behavior) throw new IllegalArgumentException("Behavior is not allowed to be null or undefined.", this, arguments);
		this.behavior = behavior;
	}
	
	public function getBehavior(Void):Behavior {
		return behavior;
	}
	
	/**
	 * @see MockControlState#invokeMethod()
	 */
	public function invokeMethod(methodCall:MethodCall) {
		behavior.addMethodBehavior(methodCall.getMethodName(), behavior.createMethodBehavior(methodCall));
	}
	
	/**
	 * @see MockControlState#setMethodResponse()
	 */ 
	public function setMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void {
		behavior.getLastMethodBehavior().addMethodResponse(methodResponse, methodCallRange);
	}
	
	/**
	 * @see MockControlState#setArgumentsMatcher()
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		behavior.getLastMethodBehavior().setArgumentsMatcher(argumentsMatcher);
	}
	
	/**
	 * @see MockControlState#verify()
	 */
	public function verify(Void):Void {
		throw new IllegalStateException("Method must not be called in record state.", this, arguments);
	}
	
}