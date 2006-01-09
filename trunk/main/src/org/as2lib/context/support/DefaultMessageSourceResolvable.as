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

import org.as2lib.context.MessageSourceResolvable;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.context.support.DefaultMessageSourceResolvable extends BasicClass implements MessageSourceResolvable {
	
	private var codes:Array;
	private var arguments:Array;
	private var defaultMessage:String;
	
	public function DefaultMessageSourceResolvable(codes:Array, arguments:Array, defaultMessage:String) {
		this.codes = codes;
		this.arguments = arguments;
		this.defaultMessage = defaultMessage;
	}
	
	public function getCodes(Void):Array {
		return codes.concat();
	}
	
	/**
	 * Returns the default code of this resolvable, i.e. the last one in the codes
	 * array.
	 * 
	 * @return the default code of this resolvable
	 */
	public function getCode(Void):String {
		return (codes.length > 0 ? codes[codes.length - 1] : null);
	}
	
	public function getArguments(Void):Array {
		return arguments.concat();
	}
	
	public function getDefaultMessage(Void):String {
		return defaultMessage;
	}
	
}