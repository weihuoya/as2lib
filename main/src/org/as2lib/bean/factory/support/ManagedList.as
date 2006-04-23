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

import org.as2lib.bean.Mergeable;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.List;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code ManagedList} represents a list that may include run-time bean references
 * and whose elements are converted to a specific type if given.
 * 
 * <p>Note that only the methods {@code insertByValue} and {@code toArray} of the
 * {@code List} interface are implemented by this list.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedList extends BasicClass implements List, Mergeable {
	
	/** The values added to this list. */
	private var values:Array;
	
	/** The required element type. */
	private var elementType:Function;
	
	/** Is merging enabled? */
	private var mergeEnabled:Boolean;
	
	/**
	 * Constructs a new {@code ManagedList} instance.
	 */
	public function ManagedList(Void) {
		values = new Array();
	}
	
	/**
	 * Returns the required type of this list's elements.
	 * 
	 * @return the required element type
	 */
	public function getElementType(Void):Function {
		return elementType;
	}
	
	/**
	 * Sets the required type of this list's elements.
	 * 
	 * @param elementType the required element type
	 */
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
		if (!mergeEnabled) {
			throw new IllegalStateException("Merging is not enabled for this managed list.", this, arguments);
		}
		if (!(parent instanceof List)) {
			throw new IllegalArgumentException("Cannot merge with instance of type [" +
					ReflectUtil.getTypeNameForInstance(parent) + "].", this, arguments);
		}
		var temp:Array = List(parent).toArray();
		values = temp.concat(values);
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