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
import org.as2lib.util.string.Stringifier;
import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.iterator.Iterator;

/**
 * MapStringifier is the default Stringifier used to stringify Maps.
 *
 * @author Simon Wacker
 * @see org.as2lib.data.holder.Map
 */
class org.as2lib.data.holder.string.MapStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.util.string.Stringifier
	 */
	public function execute(target):String {
		var map:Map = Map(target);
		var result:String = "{";
		var valueIterator:Iterator = new ArrayIterator(map.getValues());
		var keyIterator:Iterator = new ArrayIterator(map.getKeys())
		while (keyIterator.hasNext()) {
			result += keyIterator.next().toString() + "=" + valueIterator.next().toString();
			if (keyIterator.hasNext()) {
				result += ", ";
			}
		}
		result += "}";
		return result;
	}
}