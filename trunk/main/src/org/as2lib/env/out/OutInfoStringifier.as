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

import org.as2lib.core.BasicClass;
import org.as2lib.util.Stringifier;
import org.as2lib.env.out.OutInfo;
import org.as2lib.env.out.OutLevel;
import org.as2lib.env.reflect.ClassInfo;

/**
 * OutInfoStringifier is the default Stringifier used to Stringify OutInfos.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.out.OutInfoStringifier extends BasicClass implements Stringifier {
	
	/**
	 * @see org.as2lib.util.string.Stringifier
	 */
	public function execute(target):String {
		var info:OutInfo = target;
		return ("** " + getLevelName(info.getLevel()) + " ** \n" 
				+ info.getMessage());
	}
	
	private function getLevelName(level:OutLevel):String {
		return ClassInfo.forInstance(level).getName();
	}
	
}