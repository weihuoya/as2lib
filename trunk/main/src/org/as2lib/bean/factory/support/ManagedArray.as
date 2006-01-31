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

import org.as2lib.bean.Mergable;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedArray extends Array implements Mergable {
	
	private var elementType:Function;
	private var mergeEnabled:Boolean;
	
	public function ManagedArray(Void) {
	}
	
	public function getElementType(Void):Function {
		return elementType;
	}
	
	public function setElementType(elementType:Function):Void {
		this.elementType = elementType;
	}
	
	public function isMergeEnabled(Void):Boolean {
		return mergeEnabled;
	}
	
	public function setMergeEnabled(mergeEnabled:Boolean):Void {
		this.mergeEnabled = mergeEnabled;
	}
	
	public function merge(parent):Void {
		if (parent instanceof Array) {
			unshift.apply(this, parent);
		}
	}
	
}