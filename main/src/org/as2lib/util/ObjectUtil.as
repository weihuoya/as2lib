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
import org.as2lib.Config;
import org.as2lib.util.ClassUtil;
//import org.as2lib.util.Call;

/**
 * ObjectUtil contains fundamental methods to efficiently and easily work
 * with any type of object.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.util.ObjectUtil extends BasicClass {
	
	/**
	 * Constant for objects of type string.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_STRING = "string";
	
	/**
	 * Constant for objects for type number.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_NUMBER = "number";
	
	/**
	 * Constant for objects of type object.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_OBJECT = "object";
	
	/**
	 * Constant for objects of type boolean.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_BOOLEAN = "boolean";
	
	/**
	 * Constant for objects of type movieclip.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_MOVIECLIP = "movieclip";
	
	/**
	 * Constant for objects of type function.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_FUNCTION = "function";
	
	/**
	 * Constant for the value undefined.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_UNDEFINED = "undefined";
	
	/**
	 * Constant for the value null.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_NULL = "null";
	
	/**
	 * Private constructor.
	 */
	private function ObjectUtil(Void) {
	}
	
	/**
	 * Stringifies the passed-in object using the stringifier returned by
	 * the static {@link Config#getObjectStringifier} method.
	 * 
	 * @param object the object to stringify
	 * @return the string representation of the passed-in object
	 */
	public static function stringify(object):String {
		return Config.getObjectStringifier().execute(object);
	}
	
	/**
	 * Returns the name of the reference on the target object that points
	 * to the member object.
	 *
	 * @param targetObject the target object that holds the reference
	 * @param memberObject the member object to find
	 * @return the name of the reference to the member object if it has been
	 * found else null
	 */
	public static function getChildName(targetObject, memberObject):String {
		for(var i:String in targetObject) {
			try {
				if(targetObject[i] == memberObject) {
					return i;
				}
			} catch(e) {
				// Catches the exception a property may throw.
			}
		}
		return null;
	}
	
	/**
	 * Checks if the type of the passed-in object matches the passed-in type.
	 * 
	 * <p>Every value (even 'null' and 'undefined') matches type "Object".
	 *
	 * <p>Instances as well as their primitive correspondent match the types
	 * {@link String}, {@link Number} or {@link Boolean}.
	 *
	 * @param object the object whose type to compare with the passed-in type
	 * @param type the type to use for the comparison
	 * @return true if the type of the object matches the passed-in type else
	 * false
	 */
	public static function typesMatch(object, type:Function):Boolean {
		if (type === Object) {
			return true;
		}
		if (isPrimitiveType(object)) {
			var t:String = typeof(object);
			// Workaround for former used: typesMatch(type(object), object);
			// Casting is not a good solution, it will break if the Constructor throws a error!
			// This solution is not the fastest but will not break by any exception.
			if((type === String || ClassUtil.isSubClassOf(type, String)) && t == TYPE_STRING) {
				return true;
			}
			if((type === Boolean || ClassUtil.isSubClassOf(type, Boolean)) && t == TYPE_BOOLEAN) {
				return true;
			}
			if((type === Number || ClassUtil.isSubClassOf(type, Number)) && t == TYPE_NUMBER) {
				return true;
			}
			return false;
		} else {
			return (isInstanceOf(object, type));
		}
	}
	
	/**
	 * Compares the results of an execution of the {@link #typeof} method
	 * applied to both passed-in objects.
	 *
	 * @param firstObject the first object of the comparison
	 * @param secondObject the second object of the comparison
	 * @return true if the execution to the {@link #typeof} method returns
	 * the same else false
	 */
	public static function compareTypeOf(firstObject, secondObject):Boolean {
		return (typeof(firstObject) == typeof(secondObject));
	}
	
	/**
	 * Checks if the passed-in object is a primitive type.
	 *
	 * <p>Primitive types are strings, numbers and booleans that are not
	 * created via the new operator. For example 'myString', 3 and true are
	 * primitive types. But "new String('myString')", "new Number(3)" and
	 * "new Boolean(true)" are not.
	 *
	 * @param object the object to check whether it is a prmitive type
	 * @return true if the object is a primitive type else false
	 */
	public static function isPrimitiveType(object):Boolean {
		var t:String = typeof(object);
		return (t == TYPE_STRING || t == TYPE_NUMBER || t == TYPE_BOOLEAN);
	}
	
	/**
	 * Checks if the result of an execution of the {@link #typeof} method
	 * on the passed-in object matches the passed-in type.
	 * 
	 * <p>All possible types are available as static constant.
	 *
	 * @param object the object whose type to check
	 * @param type the string representation of the type
	 * @return true if the object is of type the specified type
	 * @see #TYPE_STRING
	 * @see #TYPE_NUMBER
	 * @see #TYPE_OBJECT
	 * @see #TYPE_BOOLEAN
	 * @see #TYPE_MOVIECLIP
	 * @see #TYPE_NULL
	 * @see #TYPE_UNDEFINED
	 */
	public static function isTypeOf(object, type:String):Boolean {
		return (typeof(object) == type);
	}
	
	/**
	 * Checks if the passed-in object is an instance of the passed-in type.
	 *
	 * <p>If the passed-in type is {@link Object} true will be returned,
	 * because every object is an instance of {@link Object}, event null
	 * and undefined.
	 *
	 * @param object the object to check
	 * @param type the type used for the instance of check
	 * @return true if the passed-in object is an instance of the specified
	 * type else false
	 */
	public static function isInstanceOf(object, type:Function):Boolean {
		if (type === Object) {
			return true;
		}
		return (object instanceof type);
	}
	
	/**
	 * Checks if the passed-in object is an explicit instance of the passed-in
	 * class.
	 *
	 * <p>That means that true will only be returned if the object was instantiated
	 * from the specified class.
	 *
	 * @param object the object to check whether it is an explicit instance of
	 * the class
	 * @param clazz the class to use as the basis for the check
	 * @return true if the object is an explicit instance of the class else
	 * false
	 */
	public static function isExplicitInstanceOf(object, clazz:Function):Boolean {
		if (clazz == String) {
			return (typeof(object) == TYPE_STRING);
		}
		if (clazz == Number) {
			return (typeof(object) == TYPE_NUMBER);
		}
		if (clazz == Boolean) {
			return (typeof(object) == TYPE_BOOLEAN);
		}
		return (object instanceof clazz
					&& !(object.__proto__ instanceof clazz));
	}
	
	/**
	 * Checks if the passed-in object is empty.
	 *
	 * <p>The object is classified as empty when its value is either undefined
	 * or null.
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
		return (object != undefined);
	}
	
}