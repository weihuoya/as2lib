﻿/*
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
import org.as2lib.Config;
import org.as2lib.util.Call;

/**
 * ObjectUtil contains fundamental operations to efficiently and easily work
 * with any type of object.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.util.ObjectUtil extends BasicClass {
	/**
	 * Constant for allowing everything to an object.
	 * 
	 * @see #setAccessPermission()
     */
	public static var ACCESS_ALL_ALLOWED = 0;
	
	/**
	 * Constant for hiding an object from for-in loops.
	 * 
	 * @see #setAccessPermission()
     */
	public static var ACCESS_IS_HIDDEN = 1
	
	/**
	 * Constant to protect an object from deletion.
	 * 
	 * @see #setAccessPermission()
     */
	public static var ACCESS_PROTECT_DELETE = 2;
	
	/**
	 * Constant to protect an object from overwriting.
	 * 
	 * @see #setAccessPermission()
     */
	public static var ACCESS_PROTECT_OVERWRITE = 4;
	
	/**
	 * Constant for allowing nothing.
	 * 
	 * @see #setAccessPermission()
     */
	public static var ACCESS_NOTHING_ALLOWED = 7;
	
	/**
	 * Private constructor.
	 */
	private function ObjectUtil(Void) {
	}
	
	/**
	 * Stringifies the passed Object using the Stringifier returned by Config#getObjectStringifier().
	 * 
	 * @param object the Object to be stringified
	 * @return a String representation of the object
	 */
	public static function stringify(object):String {
		return Config.getObjectStringifier().execute(object);
	}
	
	/**
	 * Evaluates if an object is a child of another object. It evaluates only
	 * methods because properties could throw an exception.
	 * 
	 * @param inObject the parent object, where the method shall search in.
	 * @param object the object that shall be found.
	 * @return the name if it could be found else null
	 */
	public static function getChildName(inObject, object:Function):String {
		for(var i:String in inObject) {
			try {
				if(inObject[i] == object) {
					return i;
				}
			} catch(e) {
				// Catches the Exception a property could throw.
			}
		}
		return null;
	}
	
	/**
	 * Sets the access permission of an object by an access value.
	 * Uses ASSetPropFlags to set the permissions of the Object.
	 * You can apply the access values
	 * <table>
	 *   <tr>
	 *     <th>#ACCESS_IS_HIDDEN</th>
	 *     <td>Hides Object from for-in loops.</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#ACCESS_PROTECT_DELETE</th>
	 *     <td>Protects an Object from deletion</td>
	 *   </tr>
	 *   <tr>
	 *     <td>#ACCESS_PROTECT_OVERWRITE</th>
	 *     <td>Protects an Object from overwriting</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#ACCESS_ALL_ALLOWED</th>
	 *     <td>Allows everything (reading, deleting, over-writing)</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#ACCESS_NOTHING_ALLOWED</th>
	 *     <td>Allows nothing (reading, deleting, over-writing)</td>
	 *   </tr>
	 * </table>
	 * as fast references.
	 * 
	 * You can combine this values for proper using binary with:
	 * #ACCESS_PROTECT_DELETE | #ACCESS_PROTECT_OVERWRITE
	 * to apply two access permissions.
	 * 
	 * @param object the object that shall be modified.
	 * @param status the access permission that shall be applied.
	 */
	public static function setAccessPermission(target, objects:Array, access:Number):Void {
		_global.ASSetPropFlags(target, objects, access, true);
	}
	
	/**
	 * Returns the current access permission of the object. The permission is
	 * represented by a Number. Refer to http://chattyfig.figleaf.com/flashcoders-wiki/index.php?ASSetPropFlags
	 * for a listing of these numbers and the information they represent.
	 *
	 * @param target the target object the object resides in
	 * @param object the name of the object the access permission shall be returned for
	 * @return a Number representing the access permission of the object
	 */
	public static function getAccessPermission(target, object:String):Number {
		var result:Number = 0;
		if (!isEnumerable(target, object)) result |= ACCESS_IS_HIDDEN;
		if (!isOverwritable(target, object)) result |= ACCESS_PROTECT_OVERWRITE;
		if (!isDeletable(target, object)) result |= ACCESS_PROTECT_DELETE;
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
		var newVal = (target[object] == 0) ? 1 : 0;
		var tmp = target[object];
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
	 * Checks if the type of object matches the given type.
	 *
	 * @param aObject the object whose type shall be compared with the type
	 * @param aType the type that shall be used for the comparison
	 * @return true if the type of the object matches else false
	 */
	public static function typesMatch(anObject, aType:Function):Boolean {
		if (aType === Object) {
			return true;
		}
		if (isPrimitiveType(anObject)) {
			if (compareTypeOf(aType(anObject), anObject)) {
				return true;
			}
		} else {
			if (isInstanceOf(anObject, aType)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Compares the results of the #typeof() operation applied to both objects.
	 *
	 * @param firstObject the first object of the comparison
	 * @param secondObject the second object of the comparison
	 * @return true if the call to the #typeof() operation returns the same else false
	 */
	public static function compareTypeOf(firstObject, secondObject):Boolean {
		return (typeof(firstObject) == typeof(secondObject));
	}
	
	/**
	 * Checks if the object is of primitive type. Primitive types are String,
	 * Number and Boolean that are not created via the new operator.
	 *
	 * @param object the possible primitive type
	 * @return true if the object is of primitive type else false
	 */
	public static function isPrimitiveType(anObject):Boolean {
		return (typeof(anObject) == "string"
				|| typeof(anObject) == "number"
				|| typeof(anObject) == "boolean");
	}
	
	/**
	 * Checks if the result of the #typeof() execution on the passed in object
	 * matches the expression.
	 *
	 * @param object the object whose type shall be checked
	 * @param expression a string representing the type
	 * @return true if the object is of type expression
	 */
	public static function isTypeOf(object, expression:String):Boolean {
		return (typeof(object) == expression);
	}
	
	/**
	 * Checks if an object is an instance of a class.
	 *
	 * @param object the object that shall be checked
	 * @param class the class that shall be used
	 * @return true if the object is an instance of the class otherwise false
	 */
	public static function isInstanceOf(anObject, aClass:Function):Boolean {
		if (aClass === Object) {
			return true;
		}
		return (anObject instanceof aClass);
	}
	
	/**
	 * Checks if the object is an explicit instance of the class. That means
	 * that true will only be returned if the object is instantiated from the
	 * specified class.
	 *
	 * @param object
	 * @param class
	 * @return true if the object is an explicit instance of the class else false
	 */
	public static function isExplicitInstanceOf(object, clazz:Function):Boolean {
		return (isInstanceOf(object, clazz) &&
				!isInstanceOf(object.__proto__, clazz));
	}
	
	/**
	 * Checks if the passed in object is empty. The object is classified as
	 * empty when its value is either undefined or null.
	 *
	 * @param object the object that shall be checked for emptyness
	 * @return true if the object is empty else false
	 */
	public static function isEmpty(object):Boolean {
		return (object == undefined);
	}
	
	/**
	 * Checks if the passed in object is not empty and thus available.
	 *
	 * @param object the object that shall be checked for availability
	 * @return true if the object is available else false
	 */
	public static function isAvailable(object):Boolean {
		return !isEmpty(object);
	}
	
	/**
	 * Iterates through the passed Object using the for..in loop and executes
	 * the Call passing the found object.
	 *
	 * @param object the object to iterate over
	 * @param call the Call to be executed for each found object
	 */
	public static function forEach(object, call:Call):Void {
		var i:String;
		for (i in object) {
			call.execute([object[i]]);
		}
	}
}