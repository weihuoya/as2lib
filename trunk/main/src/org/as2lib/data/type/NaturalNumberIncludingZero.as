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

import org.as2lib.data.type.Integer;
import org.as2lib.data.type.NumberFormatException;

/**
 * Format for Natural Numbers.
 * This class works as definition class if your method only works with Natural Numbers and you would have to throw a exception if
 * this doesn't match. If you dont allow Zero then take NaturalNumber. 
 * 
 * Note: This difference is because of Definition problems with the term "Natural Number"
 * 
 * @author Martin Heidegger
 * @see org.as2lib.data.type.NaturalNumber
 */
class org.as2lib.data.type.NaturalNumberIncludingZero extends Integer {
	
	/**
	 * Constructs a new NaturalNumber.
	 * It crops post comma digits and throws a Exception if you use Infinity.
	 * Additionally it can't work with negative numbers.
	 * 
	 * @param number Number to be used as NaturalNumber.
	 * @throws NumberFormatException if you apply a negative number or (-)Infinity.
	 */
	public function NaturalNumberIncludingZero(number:Number) {
		super(number);
		if(int < 0) {
			throw new NumberFormatException("Natural numbers don't inlude negative numbers like: "+number+".", this, arguments);
		}
	}
}