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

import org.as2lib.env.util.ReflectUtil;
import org.as2lib.core.BasicClass;

/**
 * Failure Class if an Failure was caused by an Testcase.
 *
 * @autor Martin Heidegger
 * @date 16.11.2003
 */

class org.as2lib.test.unit.Failure extends BasicClass {
	
	// Function where the Failure occured
	private var atFunction:String;
	
	// Class where the Faliure occured
	private var atClass:String;
	
	// Time when the Failure occured
	private var atTime:Number;
	
	// Message to the Failure
	private var message:String;
	
	function Failure (atFunction:String, atClass:String, atTime:Number, message:String) {
		this.atFunction = atFunction;
		this.atClass = atClass;
		this.atTime = atTime;
		this.message = message;
	}
	
	/**
	 * Function to print the Failure as String-
	 * 
	 * @return	Failure as String.
	 */
    public function toString ():String {
		var returnValue:String = "   Error @ "+ReflectUtil.getClassInfo(this.atClass).getFullName()+"."+this.atFunction+"() occured ["+this.atTime+"ms]";
		returnValue += "\n      "+message;
		return(returnValue);
	}
}