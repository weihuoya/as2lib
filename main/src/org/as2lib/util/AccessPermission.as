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
 * <p>You can hide methods from for..in loops, protect them from
 * deletion and from being overwritten.
 *
 * <p>Note that no matter what access permissions you set they can be over-
 * written.
 *
 * <p>Also note that the access permissions are not applied to the object
 * but to the reference to the object. That means that the object can for
 * example be enumerable in one reference but not in another. Here's a little
 * example.
 *
 * <code>var object:Object = new Object();
 * object.myProperty = new Object();
 * object.mySecondReference = object.myProperty;
 * trace("myProperty:          Value: " + object.myProperty);
 * trace("mySecondReference:   Value: " + object.mySecondReference);
 * AccessPermission.set(object, ["myProperty"], AccessPermission.PROTECT_DELETE);
 * trace("myProperty:          Permission: " + AccessPermission.get(object, "myProperty"));
 * trace("mySecondReference:   Permission: " + AccessPermission.get(object, "mySecondReference"));
 * delete object.myProperty;
 * delete object.mySecondReference;
 * trace("myProperty:          Value: " + object.myProperty);
 * trace("mySecondReference:   Value: " + object.mySecondReference);</code>
 *
 * <p>The output of the above example looks as follows:
 * <pre>myProperty:          Value: [object Object]
 * mySecondReference:   Value: [object Object]
 * myProperty:          Permission: 2
 * mySecondReference:   Permission: 0
 * myProperty:          Value: [object Object]
 * mySecondReference:   Value: undefined</pre>
 *
 * <p>As you can see, the above statement holds true. We have two references
 * that reference the same object. We set the access permission of one
 * reference. We can then not delete the reference the access permission
 * was applied to, but the other reference.
 *
 * <p>Following is another example with a property in its normal state
 * and another protected property we applied the #ALLOW_NOTHING access
 * permission to.
 *
 * <code>var object:Object = new Object();
 * object.myNormalProperty = "myNormalPropertyValue";
 * object.myProtectedProperty = "myProtectedPropertyValue";
 * trace("myNormalProperty:      Default Permission: " + AccessPermission.get(object, "myNormalProperty"));
 * trace("myProtectedProperty:   Default Permission: " + AccessPermission.get(object, "myProtectedProperty"));
 * AccessPermission.set(object, ["myProtectedProperty"], AccessPermission.ALLOW_NOTHING);
 * trace("myProtectedProperty:   New Permission: " + AccessPermission.get(object, "myProtectedProperty"));
 * object.myNormalProperty = "newMyNormalPropertyValue";
 * object.myProtectedProperty = "newMyProtectedPropertyValue";
 * trace("myNormalProperty:      Value After Overwriting: " + object.myNormalProperty);
 * trace("myProtectedProperty:   Value After Overwriting: " + object.myProtectedProperty);
 * for (var i:String in object) {
 *   trace(i + ":      Found In For..In Loop, Value: " + object[i]);
 * }
 * delete object.myNormalProperty;
 * delete object.myProtectedProperty;
 * trace("myNormalProperty:      Value After Deletion: " + object.myNormalProperty);
 * trace("myProtectedProperty:   Value After Deletion: " + object.myProtectedProperty);</code>
 *
 * <p>The output of this example looks as follows:
 * <pre>myNormalProperty:      Default Permission: 0
 * myProtectedProperty:   Default Permission: 0
 * myProtectedProperty:   New Permission: 7
 * myNormalProperty:      Value After Overwriting: newMyNormalPropertyValue
 * myProtectedProperty:   Value After Overwriting: myProtectedPropertyValue
 * myNormalProperty:      Found In For..In Loop, Value: newMyNormalPropertyValue
 * myNormalProperty:      Value After Deletion: undefined
 * myProtectedProperty:   Value After Deletion: myProtectedPropertyValue</pre>
 *
 * <p>As you can see the protected property cannot be deleted, overwritten
 * and is hidden from for..in loops, while the non-protected property
 * can be deleted, can be overwritten and can be enumerated.
 *
 * <p>Besides the #get method you can check properties for specific
 * access permissions using the #isEnumerable, #isDeletable and #isOverwritable
 * methods.
 *
 * @author Simon Wacker
 */
class org.as2lib.util.AccessPermission extends BasicClass {
	
	/**
	 * Allow everything to be done with the object.
     */
	public static var ALLOW_ALL = 0;
	
	/**
	 * Hide an object from for..in loops.
     */
	public static var HIDE = 1;
	
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
	public static var ALLOW_NOTHING = 7;
	
	/**
	 * Sets the access permission of an object by an access value.
	 * 
	 * <p>Uses ASSetPropFlags to set the permissions of the object.
	 * You can apply the access values
	 * <table>
	 *   <tr>
	 *     <th>#HIDE</th>
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
	 *     <th>#ALLOW_EVERYTHING</th>
	 *     <td>Allows everything (reading, deleting, over-writing)</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#ALLOW_NOTHING</th>
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
	 * means using the constants #ALLOW_EVERYTHING, #ALLOW_NOTHING, #HIDE,
	 * #PROTECT_DELETE and #PROTECT_OVERWRITE. The returned number must be
	 * either of these constants or a bitwise or combination of them.
	 *
	 * @param target the target object the object resides in
	 * @param object the name of the object the access permission shall be returned for
	 * @return a number representing the access permission of the object
	 */
	public static function get(target, object:String):Number {
		var result:Number = 0;
		if (!isEnumerable(target, object)) result |= HIDE;
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
		if (tmp === undefined) return false;
		var enumerable:Boolean = isEnumerable(target, object);
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