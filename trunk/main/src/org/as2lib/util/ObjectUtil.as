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
 * ObjectUtil contains fundamental operations to efficiently and easily work
 * with any type of object.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.util.ObjectUtil extends BasicClass {
	
	/**
	 * Constant for the type of string.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_STRING = "string";
	
	/**
	 * Constant for the type of number.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_NUMBER = "number";
	
	/**
	 * Constant for the type of object.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_OBJECT = "object";
	
	/**
	 * Constant for the type of boolean.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_BOOLEAN = "boolean";
	
	/**
	 * Constant for the type of movieclip.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_MOVIECLIP = "movieclip";
	
	/**
	 * Constant for the type of function.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_FUNCTION = "function";
	
	/**
	 * Constant for the type of undefined.
	 * 
	 * @see #isTypeOf
	 */
	public static var TYPE_UNDEFINED = "undefined";
	
	/**
	 * Constant for the type of null.
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
	public static function getChildName(inObject, object):String {
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
	 * Checks if the type of object matches the given type.
	 * Every value (even "null" & "undefined") matches type "Object".
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
			var t:String = typeof(anObject);
			// Workaround for former used: typesMatch(aType(anObject), anObject);
			// Casting is not a good solution, it will break if the Constructor throws a error!
			// This solution is not the fastest but will not break by any exception.
			if((aType === String || ClassUtil.isSubClassOf(aType, String)) && t == TYPE_STRING) {
				return true;
			}
			if((aType === Boolean || ClassUtil.isSubClassOf(aType, Boolean)) && t == TYPE_BOOLEAN) {
				return true;
			}
			if((aType === Number || ClassUtil.isSubClassOf(aType, Number)) && t == TYPE_NUMBER) {
				return true;
			}
			return false;
		} else {
			return (isInstanceOf(anObject, aType));
		}
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
		var t:String = typeof(anObject);
		return (t == TYPE_STRING || t == TYPE_NUMBER || t == TYPE_BOOLEAN);
	}
	
	/**
	 * Checks if the result of the typeof execution on the passed in object
	 * matches the expression.
	 * 
	 * All possible types are available as static constant.
	 *
	 * @param object the object whose type shall be checked
	 * @param expression a string representing the type
	 * @return true if the object is of type expression
	 * 
	 * @see #TYPE_STRING
	 * @see #TYPE_NUMBER
	 * @see #TYPE_OBJECT
	 * @see #TYPE_BOOLEAN
	 * @see #TYPE_MOVIECLIP
	 * @see #TYPE_NULL
	 * @see #TYPE_UNDEFINED
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
		if (clazz == String) {
			return (typeof(object) == TYPE_STRING);
		}
		if (clazz == Number) {
			return (typeof(object) == TYPE_NUMBER);
		}
		if (clazz == Boolean) {
			return (typeof(object) == TYPE_BOOLEAN);
		}
		return (object instanceof clazz &&
				!(object.__proto__ instanceof clazz));
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
		return (object != undefined);
	}
	
	/**
	 * Iterates through the passed Object using the for..in loop and executes
	 * the Call passing the found object and the name of the object.
	 * 
	 * Example:
	 * <CODE>
	 *   class MyClass {
	 * 
     *      private var a:String;
     *      private var b:String;
     *      private var c:String;
	 * 
	 *      public function MyClass() {
	 *          a = "1";
	 *          b = "2";
	 *          c = "2";
	 *      }
	 *      
	 *      public function traceObject(value, name:String):Void {
	 *          trace(name+": "+value);
	 *      }
	 * 
	 *      public function listAll() {
     *          var call:Call = new Call(this, traceObject);
	 *          ObjectUtil.forEach(this, call);
	 *      }
	 *   }
	 * </CODE>
	 *  
	 * @param object the object to iterate over
	 * @param call the Call to be executed for each found object
	 */
	/*public static function forEach(object, call:Call):Void {
		var i:String;
		for (i in object) {
			call.execute([object[i], i]);
		}
	}*/
	
}