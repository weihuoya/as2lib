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
import org.as2lib.test.unit.error.IllegalTypeThrownException;
import org.as2lib.util.StringUtil;

/**
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.stringifier.IllegalTypeThrownExceptionStringifier extends BasicClass implements Stringifier {
	
	/**
	 * Returns a IllegalTypeThrownException as string.
	 * 
	 * @return IllegalTypeThrownException as string.
	 */
	public function execute (object):String {
		var failure:IllegalTypeThrownException = IllegalTypeThrownException(object);
		var result:String = "assertThrows failed";
		if(failure.getMessage().length > 0) result += " with message: "+failure.getMessage();
		result += "\n  Unexpected exception was thrown by calling "+failure.getCall().toString()+" with arguments ["+failure.getCallArguments()+"]";
		result += "\n  The exception was: \n"+StringUtil.addSpaceIndent(failure.getNestedException().toString(), 4);
		return(result);
	}
}