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
 
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.except.SimpleStackTraceElement;
import test.unit.org.as2lib.env.except.AbstractTStackTraceElement;

/**
 * @author Jayaprakash A
 */
class test.unit.org.as2lib.env.except.TSimpleStackTraceElement extends AbstractTStackTraceElement{
	/**
	 * Overriding Template Method to return SimpleStackTraceElement.
	 */
	public function getStackTraceElement (thrower:Object, method:Function, args:FunctionArguments):StackTraceElement {	
		return new SimpleStackTraceElement(thrower, method, args);
	}
	
}
