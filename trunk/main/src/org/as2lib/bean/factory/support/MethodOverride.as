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
import org.as2lib.env.except.AbstractOperationException;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.MethodOverride extends BasicClass {
	
	private var methodName:String;
	
	private function MethodOverride(methodName:String) {
		this.methodName = methodName;
	}
	
	public function getMethodName(Void):String {
		return methodName;
	}
	
	public function matches(methodName:String):Boolean {
		throw new AbstractOperationException("This method is marked as abstract and must be overridden by sub-classes.", this, arguments);
		return null;
	}
	
}