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

/**
 * AccessPermission lets you adjust the access permissions of members like
 * methods and properties in one specific context.
 *
 * <p>You can for example hide methods from for..in loops or protect them
 * from deletion.
 *
 * <p>Note that no matter what access permissions you set they can be over-
 * written.
 *
 * <p>Also note that the access permissions are not applied to the object but
 * for the reference to the object. That means that the object can for
 * example be enumerable in one reference but not in another.
 *
 * @author Simon Wacker
 */
class org.as2lib.util.AccessPermission extends BasicClass {
	
	/**
	 * Allow everything to be done with the object.
     */
	public static var ALL_ALLOWED = 0;
	
	/**
	 * Hide an object from for..in loops.
     */
	public static var IS_HIDDEN = 1
	
	/**
	 * Protect an object from deletion.
     */
	public static var PROTECT_DELETE = 2;
	
	/**
	 * Protect an object from overwriting.
     */
	public static var PROTECT_OVERWRITE = 4;
	
	/**
	 * Allow nothing to be done with the object.
     */
	public static var NOTHING_ALLOWED = 7;
	
	/**
	 * Sets the access permission of an object by an access value.
	 * 
	 * <p>Uses ASSetPropFlags to set the permissions of the object.
	 * You can apply the access values
	 * <table>
	 *   <tr>
	 *     <th>#IS_HIDDEN</th>
	 *     <td>Hides object from for-in loops.</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#PROTECT_DELETE</th>
	 *     <td>Protects an object from deletion</td>
	 *   </tr>
	 *   <tr>
	 *     <td>#PROTECT_OVERWRITE</th>
	 *     <td>Protects an object from overwriting</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#ALL_ALLOWED</th>
	 *     <td>Allows everything (reading, deleting, over-writing)</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#NOTHING_ALLOWED</th>
	 *     <td>Allows nothing (reading, deleting, over-writing)</td>
	 *   </tr>
	 * </table>
	 * as fast references.
	 * 
	 * You can combine these values as follows:
	 * #PROTECT_DELETE | #PROTECT_OVERWRITE
	 * to apply two access permissions.
	 *
	 * @param target the object that holds references to the objects the access permissions shall be applied
	 * @param objects the array of reference names the access permission shall be applied to
	 * @param access the access permissions that shall be applied.
	 */
	public static function set(target, objects:Array, access:Number):Void {
		_global.ASSetPropFlags(target, objects, access, true);
	}
	
	/**
	 * Returns the current access permission of the object. The permission is
	 * represented by a Number. Refer to http://chattyfig.figleaf.com/flashcoders-wiki/index.php?ASSetPropFlags
	 * for a listing of these numbers and the information they represent.
	 *
	 * <p>You can also find out what the returned access permission number
	 * means using the constants #ALL_ALLOWED, #NOTHING_ALLOWED, #IS_HIDDEN,
	 * #PROTECT_DELETE and #PROTECT_OVERWRITE. The returned number must be
	 * either of these constants or a bitwise or combination of them.
	 *
	 * @param target the target object the object resides in
	 * @param object the name of the object the access permission shall be returned for
	 * @return a number representing the access permission of the object
	 */
	public static function get(target, object:String):Number {
		var result:Number = 0;
		if (!isEnumerable(target, object)) result |= IS_HIDDEN;
		if (!isOverwritable(target, object)) result |= PROTECT_OVERWRITE;
		if (!isDeletable(target, object)) result |= PROTECT_DELETE;
		return result;
	}
	
	/**
	 * Returns whether the object is enumerable.
	 *
	 * @param target the target object the object resides in
	 * @param object the name of the object that shall be checked for enumerability
	 * @return true if the object is enumerable else false
	 * @link http://chattyfig.figleaf.com/flashcoders-wiki/index.php?ASSetPropFlags
	 */
	public static function isEnumerable(target, object:String):Boolean {
		// Why not use target.isPropertyEnumerable(object)?
		for(var i:String in target){
			if(i == object) return true;
		}
		return false;
	}
	
	/**
	 * Returns whether the object is overwritable.
	 * 
	 * @param target the target object the object resides in
	 * @param object the name of the object that shall be checked for overwritability
	 * @return true if the object is overwritable else false
	 * @link http://chattyfig.figleaf.com/flashcoders-wiki/index.php?ASSetPropFlags
	 */
	public static function isOverwritable(target, object:String):Boolean {
		var tmp = target[object];
		var newVal = (tmp == 0) ? 1 : 0;
		target[object] = newVal;
		if(target[object] == newVal){
			target[object] = tmp;
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * Returns whether the object is deletable.
	 * 
	 * @param target the target object the object resides in
	 * @param object the name of the object that shall be checked for deletability
	 * @return true if the object is deletable else false
	 * @link http://chattyfig.figleaf.com/flashcoders-wiki/index.php?ASSetPropFlags
	 */
	public static function isDeletable(target, object:String):Boolean {
		var tmp = target[object];
		if(tmp === undefined) return false;
		var enumerable:Boolean = target.isEnumerable(object);
		delete target[object];
		if(target[object] === undefined){
			target[object] = tmp;
			_global.ASSetPropFlags(target, object, !enumerable, 1);
			return true;
		}
		return false;
	}
	
	/**
	 * Private constructor.
	 */
	private function AccessPermission(Void) {
	}
	
}