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
	
	public static var DEFAULT_MINIMUM:Number = 0;
	public static var DEFAULT_MAXIMUM:Number = Number.POSITIVE_INFINITY;
	
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
		MethodCallRangeByMinimumAndMaximumQuantity(null, null);
	}
	
	private function MethodCallRangeByQuantity(quantity):Void {
		if (quantity == null) {
			MethodCallRangeByMinimumAndMaximumQuantity(null, null);
		}
		MethodCallRangeByMinimumAndMaximumQuantity(quantity, quantity);
	}
	
	private function MethodCallRangeByMinimumAndMaximumQuantity(minimum:Number, maximum:Number):Void {
		if (minimum == null) minimum = DEFAULT_MINIMUM;
		if (maximum == null) maximum = DEFAULT_MAXIMUM;
		if (minimum < 0) minimum = -minimum;
		if (maximum < 0) maximum = -maximum;
		if (minimum > maximum) {
			var oldMinimum:Number = minimum;
			minimum = maximum;
			maximum = oldMinimum;
		}
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
		if (quantity == null) return false;
		if (quantity < 0) quantity = -quantity;
		if (minimum > quantity || maximum < quantity) {
			return false;
		}
		return true;
	}
	
	public function toString(Void):String {
		if (minimum == maximum) return minimum.toString();
		var interval:String = "[";
		if (minimum == Number.POSITIVE_INFINITY) interval += "∞";
		else interval += minimum.toString();
		interval += ",";
		if (maximum == Number.POSITIVE_INFINITY) interval += "∞";
		else interval += maximum.toString();
		interval += "]";
		return interval;
	}
	
}