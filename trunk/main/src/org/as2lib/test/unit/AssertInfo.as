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
 
import org.as2lib.core.BasicInterface;

/**
 * Definition for a Information about a Assertion.
 * All informations about assertions have to implement this interface.
 * 
 * @autor Martin Heidegger
 */
interface org.as2lib.test.unit.AssertInfo extends BasicInterface {
	
	/**
	 * @return true if the assertion failed.
	 */
	public function isFailed(Void):Boolean;
	
	/**
	 * Returns the message to the assertion.
	 * If this assertion failed it should return the errorinfo, else the successinfo.
	 * 
	 * @return Message to the assertion.
	 */
	public function getMessage(Void):String;
}