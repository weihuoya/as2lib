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

/**
 * Interface to work with, if you want to work with Angles.
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.data.type.Angle extends BasicInterface {
	
	/**
	 * Getter for the angle value represented in radian.
	 * 
	 * @return Angle value in radian.
	 */
	public function toRadian(Void):Number;
	
	/**
	 * Getter for the angle value represented in degree.
	 * 
	 * @return Angle value in degree.
	 */
	public function toDegree(Void):Number;
}