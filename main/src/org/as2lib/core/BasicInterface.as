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

import org.as2lib.env.reflect.ClassInfo;

/**
 * BasicInterface is the basic interface for each class in the as2lib framework.
 * It is recommended to always implement this interface in the classes of your
 * own project but it is not a necessity. You can use all functionality of the 
 * as2lib framework without implementing it.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 * @author Michael Hermann
 * @see org.as2lib.core.BasicClass for a default implementation
 */
interface org.as2lib.core.BasicInterface {       
	/** 
	 * Returns a ClassInfo that represents the class the instance was instantiated
	 * from. 
	 * 
	 * @return a ClassInfo representing the class of the instance
	 */ 
	public function getClass(Void):ClassInfo;
	 
	/**
	 * Returns a String representation of the instance.
	 *
	 * @return a String representing the instance
	 */
	public function toString(Void):String;
}