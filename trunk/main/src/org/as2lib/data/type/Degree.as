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
 * Implementation of Angle for degrees
 * 
 * @author Martin Heidegger
 */
class org.as2lib.data.type.Degree extends Number implements Angle {
	
	/** Value of angle in degree */
	private var degree:Number;
	
	/**
	 * Constructcs a degree content
	 * 
	 * @param degree Value of degree for the instance.
	 */
	public function Degree(degree:Number) {
		this.degree = degree;
	}
	
	/**
	 * Value of the degree content
	 * 
	 * @return degrees value
	 */
	public function valueOf(Void):Number {
		return degree;
	}
	
	/**
	 * Getter for the degrees as radian
	 * 
	 * @return degrees as radian.
	 */
	public function toRadian(Void):Number {
		return degree*Math.PI/180;
	}
	
	/**
	 * Getter for the degrees
	 * 
	 * @return degrees
	 */
	public function toDegree(Void):Number {
		return degree;
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