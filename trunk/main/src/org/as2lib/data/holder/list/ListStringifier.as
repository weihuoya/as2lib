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
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.Iterator;

/**
 * ListStringifier is the default Stringifier used to stringify Lists.
 *
 * @author Christoph Atteneder
 * @see org.as2lib.data.holder.List
 */
class org.as2lib.data.holder.list.ListStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.util.string.Stringifier
	 */
	public function execute(target):String {
		var list:List = List(target);
		var result:String = "[";
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			result += iterator.next().toString();
			if (iterator.hasNext()) {
				result += ", ";
			}
		}
		result += "]";
		return result;
	}
}