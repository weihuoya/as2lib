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


/**
 * BasicInterface is the basic interface for each class in the as2lib
 * framework.
 * 
 * <p>It is recommended to always implement this interface in the classes
 * of your own project but it is not a necessity. You can use all 
 * functionality of the as2lib framework without implementing it.
 *
 * <p>In enables you to call the #theString method on instances that
 * have been casted to interfaces.
 *
 * <p>The default implementation BasicClass offers an enhanced #toString
 * method implementation that returns a better string representation
 * than the default Object#toString method of Flash.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 * @author Michael Hermann
 * @see org.as2lib.core.BasicClass for a default implementation
 */
interface org.as2lib.core.BasicInterface {       
	 
	/**
	 * Returns a String representation of this instance.
	 *
	 * @return the String representation of this instance
	 */
	public function toString(Void):String;
	
}