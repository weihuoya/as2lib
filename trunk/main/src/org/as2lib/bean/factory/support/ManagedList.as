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
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.List;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedList extends BasicClass implements List, Mergable {
	
	private var values:Array;
	private var elementType:Function;
	private var mergeEnabled:Boolean;
	
	public function ManagedList(Void) {
		values = new Array();
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
		if (parent instanceof List) {
			var temp:Array = List(parent).toArray();
			values = temp.concat(values);
		}
	}
	
	public function insertByValue(value):Void {
		values.push(value);
	}
	
	public function toArray(Void):Array {
		return values;
	}
	
	public function insert():Void {
	}
	
	public function insertByIndexAndValue(index:Number, value):Void {
	}
	
	public function insertFirst(value):Void {
	}
	
	public function insertLast(value):Void {
	}
	
	public function insertAll():Void {
	}
	
	public function insertAllByList(list:List):Void {
	}
	
	public function insertAllByIndexAndList(index:Number, list:List):Void {
	}
	
	public function remove() {
	}
	
	public function removeByValue(value):Number {
		return null;
	}
	
	public function removeByIndex(index:Number) {
	}
	
	public function removeFirst(Void) {
	}
	
	public function removeLast(Void) {
	}
	
	public function removeAll(list:List):Void {
	}
	
	public function set(index:Number, value) {
	}
	
	public function setAll(index:Number, list:List):Void {
	}
	
	public function get(index:Number) {
	}
	
	public function contains(value):Boolean {
		return null;
	}
	
	public function containsAll(list:List):Boolean {
		return null;
	}
	
	public function retainAll(list:List):Void {
	}
	
	public function subList(fromIndex:Number, toIndex:Number):List {
		return null;
	}
	
	public function clear(Void):Void {
	}
	
	public function size(Void):Number {
		return null;
	}
	
	public function isEmpty(Void):Boolean {
		return null;
	}
	
	public function iterator(Void):Iterator {
		return null;
	}
	
	public function indexOf(value):Number {
		return null;
	}
	
}