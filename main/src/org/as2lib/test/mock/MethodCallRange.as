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
	
	/** The minimum that gets used if none has been specified. */
	public static var DEFAULT_MINIMUM:Number = 0;
	
	/** The maximum that gets used if none has been specified. */
	public static var DEFAULT_MAXIMUM:Number = Number.POSITIVE_INFINITY;
	
	/** The minimum. Can't be negative. */
	private var minimum:Number;
	
	/** The maximum. Can't be negative. */
	private var maximum:Number;
	
	/**
	 * @overload #MethodCallRangeByVoid(Void)
	 * @overload #MethodCallRangeByQuantity(Number)
	 * @overload #MethodCallRangeByMinimumAndMaximumQuantity(Number, Number)
	 */
	public function MethodCallRange() {
		var o:Overload = new Overload(this);
		o.addHandler([], MethodCallRangeByVoid);
		o.addHandler([Number], MethodCallRangeByQuantity);
		o.addHandler([Number, Number], MethodCallRangeByMinimumAndMaximumQuantity);
		o.forward(arguments);
	}
	
	/**
	 * Uses the default minimum and the default maximum value.
	 */
	private function MethodCallRangeByVoid(Void):Void {
		MethodCallRangeByMinimumAndMaximumQuantity(null, null);
	}
	
	/**
	 * Uses the passed-in quantity as minimum and maximum.
	 *
	 * <p>If the passed-in quantity is null the default minimum and default
	 * maximum gets used.
	 *
	 * @param quantity the quantity
	 */
	private function MethodCallRangeByQuantity(quantity:Number):Void {
		if (quantity == null) {
			MethodCallRangeByMinimumAndMaximumQuantity(null, null);
		}
		MethodCallRangeByMinimumAndMaximumQuantity(quantity, quantity);
	}
	
	/**
	 * Creates a new range with the passed-in minimum and maximum.
	 *
	 * <ul>
	 *   <li>If the minimum is null or undefined the default one will be used.</li>
	 *   <li>If the maximum is null or undefined the default one will be used.</li>
	 *   <li>If the minimum is negative it will be made positive.</li>
	 *   <li>If the maximum is negative it will be made positive.</li>
	 *   <li>If the minimum is bigger than the maximum the two values will be exchanged.</li>
	 * </ul>
	 *
	 * @param minimum the minimum
	 * @param maximum the maximum
	 */
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
	
	/**
	 * @return the set minimum
	 */
	public function getMinimum(Void):Number {
		return minimum;
	}
	
	/**
	 * @return the set maximum
	 */
	public function getMaximum(Void):Number {
		return maximum;
	}
	
	/**
	 * Checks whether the passed-in quantity is between the minimum
	 * and maximum.
	 *
	 * <p>The quantity will be made positive if it is negative.
	 *
	 * <p>False will be returned if:
	 * <ul>
	 *   <li>The passed-in quantity is null or undefined.</li>
	 *   <li>The passed-in quantity is smaller than the minimum.</li>
	 *   <li>The passed-in quantity is bigger than the maximum.</li>
	 * </ul>
	 *
	 * @param quantity the quantity
	 * @return true if the quantity is contained by the range else false
	 */
	public function contains(quantity:Number):Boolean {
		if (quantity == null) return false;
		if (quantity < 0) quantity = -quantity;
		if (minimum > quantity || maximum < quantity) {
			return false;
		}
		return true;
	}
	
	/**
	 * @see BasicInterface#toString(Void):String
	 */
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