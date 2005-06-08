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
 
import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.Iterator;

/**
 * {@code List} holds values by index. Each value has its unique index.
 * 
 * <p>Example:
 * <code>
 *   var list:List = new MyList();
 *   list.insert("myValue1");
 *   list.insertFirst("myValue2");
 *   list.insertLast("myValue3");
 *   trace(list.contains("myValue2"));
 *   trace(list.remove(0));
 *   trace(list.contains("myValue2"));
 *   trace(list.removeLast());
 *   trace(list.get(0));
 *   list.clear();
 *   trace(list.size());
 * </code>
 * 
 * <p>Output:
 * <pre>
 *   true
 *   myValue2
 *   false
 *   myValue3
 *   myValue1
 *   0
 * </pre>
 * 
 * @author Simon Wacker
 */
interface org.as2lib.data.holder.List extends BasicInterface {
	
	/**
	 * Inserts {@code value} at the end of this list.
	 * 
	 * @param value the value to insert
	 * @see #insertLast
	 */
	public function insert(value):Void;
	
	/**
	 * Inserts {@code value} at the beginning of this list.
	 * 
	 * @param value the value to insert
	 */
	public function insertFirst(value):Void;
	
	/**
	 * Inserts {@code value} at the end of this list.
	 * 
	 * @param value the value to insert
	 * @see #insert
	 */
	public function insertLast(value):Void;
	
	/**
	 * Inserts all values contained in {@code list} to the end of this list.
	 * 
	 * @param list the values to insert
	 */
	public function insertAll(list:List):Void;
	
	/**
	 * @overload #removeByValue
	 * @overload #removeByIndex
	 */
	public function remove();
	
	/**
	 * Removes {@code value} from this list if it exists.
	 * 
	 * @param value the value to remove
	 */
	public function removeByValue(value):Void;
	
	/**
	 * Removes the value at given {@code index} from this list and returns it.
	 * 
	 * @param index the index of the value to remove
	 * @return the removed value that was originally at given {@code index}
	 */
	public function removeByIndex(index:Number);
	
	/**
	 * Removes the value at the beginning of this list.
	 * 
	 * @return the removed value
	 */
	public function removeFirst(Void);
	
	/**
	 * Removes the value at the end of this list.
	 * 
	 * @return the removed value
	 */
	public function removeLast(Void);
	
	/**
	 * Removes all values contained in {@code list}.
	 * 
	 * @param list the values to remove
	 */
	public function removeAll(list:List):Void;
	
	/**
	 * Sets {@code value} to given {@code index} on this list.
	 * 
	 * @param index the index of {@code value}
	 * @param value the {@code value} to set to given {@code index}
	 * @return the value that was orignially at given {@code index}
	 */
	public function set(index:Number, value);
	
	/**
	 * Sets all values contained in {@code list} to this list, starting from given
	 * {@code index}.
	 * 
	 * @param index the index to start at
	 * @param list the values to set
	 */
	public function setAll(index:Number, list:List):Void;
	
	/**
	 * Returns the value at given {@code index}.
	 * 
	 * @param index the index to return the value of
	 * @return the value that is at given {@code index}
	 */
	public function get(index:Number);
	
	/**
	 * Checks whether {@code value} is contained in this list.
	 * 
	 * @param value the value to check whether it is contained
	 * @return {@code true} if {@code value} is contained else {@code false}
	 */
	public function contains(value):Boolean;
	
	/**
	 * Checks whether all values of {@code list} are contained in this list.
	 * 
	 * @param list the values to check whether they are contained
	 * @return {@code true} if all values of {@code list} are contained else
	 * {@code false}
	 */
	public function containsAll(list:List):Boolean;
	
	/**
	 * Retains all values the are contained in {@code list} and removes all others.
	 * 
	 * @param list the list of values to retain
	 */
	public function retainAll(list:List):Void;
	
	/**
	 * Removes all values from this list.
	 */
	public function clear(Void):Void;
	
	/**
	 * Returns the number of added values.
	 * 
	 * @return the number of added values
	 */
	public function size(Void):Number;
	
	/**
	 * Returns whether this list is empty.
	 * 
	 * <p>This list is empty if it has no values assigned to it.
	 * 
	 * @return {@code true} if this list is empty else {@code false}
	 */
	public function isEmpty(Void):Boolean;
	
	/**
	 * Returns the iterator to iterate over this list.
	 * 
	 * @return the iterator to iterate over this list
	 */
	public function iterator(Void):Iterator;
	
	/**
	 * Returns the index of {@code value}.
	 * 
	 * @param value the value to return the index of
	 * @return the index of {@code value}
	 */
	public function indexOf(value):Number;
	
	/**
	 * Returns the array representation of this list.
	 * 
	 * @return the array representation of this list
	 */
	public function toArray(Void):Array;
	
}