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
import org.as2lib.env.overload.Overload;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.test.mock.AssertionFailedError;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.MethodCallRange extends BasicClass {
	
	private static var QUANTITY_ANY:Number = Number.POSITIVE_INFINITY;
	
	private var minimum:Number;
	private var maximum:Number;
	
	public function MethodCallRange() {
		var o:Overload = new Overload(this);
		o.addHandler([], MethodCallRangeByVoid);
		o.addHandler([Number], MethodCallRangeByQuantity);
		o.addHandler([Number, Number], MethodCallRangeByMinimumAndMaximumQuantity);
		o.forward(arguments);
	}
	
	private function MethodCallRangeByVoid(Void):Void {
		MethodCallRangeByQuantity(QUANTITY_ANY);
	}
	
	private function MethodCallRangeByQuantity(quantity):Void {
		MethodCallRangeByMinimumAndMaximumQuantity(quantity, quantity);
	}
	
	private function MethodCallRangeByMinimumAndMaximumQuantity(minimum:Number, maximum:Number):Void {
		if (minimum < 0) throw new IllegalArgumentException("Minimum quantity [" + minimum + "] must not be negative.", this, arguments);
		if (minimum > maximum) throw new IllegalArgumentException("Minimum quantity [" + minimum + "] must not be bigger than the maximum quantity [" + maximum + "].", this, arguments);
		this.minimum = minimum;
		this.maximum = maximum;
	}
	
	public function getMinimum(Void):Number {
		return minimum;
	}
	
	public function getMaximum(Void):Number {
		return maximum;
	}
	
	public function contains(quantity:Number):Boolean {
		if (minimum != QUANTITY_ANY && maximum != QUANTITY_ANY) {
			if (minimum > quantity || maximum < quantity) {
				return false;
			}
		}
		return true;
	}
	
	public function toString(Void):String {
		return ("minimum: " + minimum + ", maximum: " + maximum);
	}
	
}