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

import org.as2lib.data.holder.Iterator;
import org.as2lib.core.BasicClass;

/**
 * Testimplemenation of a Iterator that saves which method was the latest executed method.
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.holder.TestIterator extends BasicClass implements Iterator {
	
	// Contains the name of the last executed method.
	private var lastExecuted:String;
	
	/**
	 * Constructs a new instance of this iterator.
	 */
	public function TestIterator(Void) {}
	
	/**
	 * Getter for the last executed method
	 * 
	 * @return "next"/"hasNext"/"remove" if one of these methods were executed.
	 */
	public function getLastExecuted(Void):String {
		return lastExecuted;
	}
	
	/**
	 * Implementation of Iterator.next. It will _always_ return "b"
	 * 
	 * @return b as static result.
	 */
	public function next(Void) {
		lastExecuted = "next";
		return "b";
	}
	
	/**
	 * Implementation of Iterator.hasNext. It will _always_ return true.
	 * 
	 * @return true as static result.
	 */
	public function hasNext(Void):Boolean {
		lastExecuted = "hasNext";
		return true;
	}
	
	/**
	 * Implementation of Iterator.remove. It will not do anything.
	 */
	public function remove(Void):Void {
		lastExecuted = "remove";
	}
}