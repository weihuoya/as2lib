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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.data.type.NumberFormatException;

/**
 * Class to be used if you have a method that only works with integers. 
 * A integer is a positive or negative natural number including zero.
 * 
 * @author Martin Heidegger.
 */
class org.as2lib.data.type.Integer extends Number implements BasicInterface {
	
	/** Internal holder for the integer */
	private var int:Number;
	
	/**
	 * Transforms the applied number to a integer.
	 * It will floor the number so that only the base is used
	 * as integer (if post-comma-digits are available).
	 * 
	 * @param number Number to be used as integer.
	 * @throws NumberFormatException if you apply Infinity or -Infinity.
	 */
	public function Integer(number:Number) {
		if(number == Infinity || number == -Infinity) {
			throw new NumberFormatException("Infinity is not evaluateable as integer", this, arguments);
		} else {
			int = number-number%1;
		}
	}
	
	/**
	 * Returns the value of the integer (not the instance of this class.
	 * 
	 * @return Value of the integer.
	 */
	public function valueOf(Void):Number {
		return int;
	}
	
	/**
	 * Returns the string representation of the integer.
	 * 
	 * @return String representation of the integer.
	 */
	public function toString(Void):String {
		return int.toString();
	}
	
	/**
	 * Uses the ReflectUtil#getClassInfo() operation to fulfill the task.
	 *
	 * @see org.as2lib.core.BasicInterface#getClass()
	 */
	public function getClass(Void):ClassInfo {
		return ClassInfo.forInstance(this);
	}
}