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

import org.as2lib.data.type.Angle;
import org.as2lib.util.ObjectUtil;

/**
 * Implementation of Angle for radian
 * 
 * @author Martin Heidegger
 */
class org.as2lib.data.type.Radian extends Number implements Angle {
	
	/** Value of the angle in radian */
	private var radian:Number;
	
	/**
	 * Constructcs a radian content
	 * 
	 * @param radian Value of radian for the instance.
	 */
	public function Radian(radian:Number) {
		this.radian = radian;
	}
	
	/**
	 * Value of the radian content
	 * 
	 * @return radian value
	 */
	public function valueOf(Void):Number {
		return radian;
	}
	
	/**
	 * Getter for the radian
	 * 
	 * @return radian
	 */
	public function toRadian(Void):Number {
		return radian;
	}
	
	/**
	 * Getter for the radian as degrees
	 * 
	 * @return radian as degrees.
	 */
	public function toDegree(Void):Number {
		return radian*180/Math.PI;
	}
	
	/**
	 * Returns a String representation of the instance. The String representation
	 * is obtained via the ObjectUtil#stringify() operation.
	 *
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return ObjectUtil.stringify(this);
	}
}