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
import org.as2lib.util.string.Stringifier;
import org.as2lib.test.unit.error.AssertIsNotEmptyException;

/**
 * Stringifier for a AssertIsNotEmptyException.
 * 
 * @see Failure
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.stringifier.AssertIsNotEmptyStringifier extends BasicClass implements Stringifier {
	
	/**
	 * Returns a AssertIsNotEmptyException as string.
	 * 
	 * @return AssertIsNotEmptyException as string.
	 */
	public function execute (object):String {
		var exception:AssertIsNotEmptyException = AssertIsNotEmptyException(object);
		var result:String = "assertNotEmpty failed";
		if(exception.getMessage().length > 0) {
			result += " with message: "+exception.getMessage();
		}
		result += "\n  empty object occured!";
		return(result);
	}
}