﻿import org.as2lib.core.BasicClass;
import org.as2lib.core.string.ObjectStringifier;
import org.as2lib.core.string.Stringifier;

/**
 * ObjectUtil contains fundamental operations to efficiently and easily work
 * with any type of object.
 *
 * @author: Simon Wacker, Martin Heidegger
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.util.ObjectUtil extends BasicClass{
	/** Private holder for a Stringifier for objects */
	private static var stringifier:Stringifier = new ObjectStringifier();
	
	/**
	 * Constant for hiding a object from for-in loops.
	 * 
	 * @see #setStatus()
        */
	public static var STATUS_IS_HIDDEN = 1
	
	/**
	 * Constant for setting an object deletable.
	 * 
	 * @see #setStatus()
        */
	public static var STATUS_CAN_DELETE = 2;
	
	/**
	 * Constant for setting an object overwritable.
	 * 
	 * @see #setStatus()
        */
	public static var STATUS_CAN_OVERWRITE = 4;
	
	/**
	 * Constant for allowing everything to an object.
	 * 
	 * @see #setStatus()
        */
	public static var STATUS_ALL_ALLOWED = STATUS_CAN_DELETE | STATUS_CAN_OVERWRITE;
	
	/**
	 * Constant for allowing nothing..
	 * 
	 * @see #setStatus()
        */
	public static var STATUS_NOTHING_ALLOWED = STATUS_IS_HIDDEN;
	
	/**
	 * Private constructor.
	 */
	private function ObjectUtil(Void) {
	}
	
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	public static function getStringifier(Void):Stringifier {
		return stringifier;
	}
	
	/**
	 * Evaluates if a object is a child of another object.
	 * It evaluates only methods because parameters could throw an exception.
	 * 
	 * @param inObject The parent-object, where the method should search in.
	 * @param object The object that should be found.
	 * @return The name if it was found. Null if it wasn't found.
	 */
	public static function getChildName(inObject, object:Function):String {
		for(var i:String in inObject) {
			try {
				if(inObject[i] == object) {
					return i;
				}
			} catch(e) {
				// Catching if an getter throws an exception
			}
		}
		return null;
	}
	
	/**
	 * Sets the Access permission to a object by a status-value.
	 * Uses ASSetPropFlags to set the permissions of the Object.
	 * You can apply the static values:
	 * <table>
	 *   <tr>
	 *     <th>#STATUS_IS_HIDDEN</th>
	 *     <td>Hides Object from for-in loops.</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#STATUS_CAN_DELETE</th>
	 *     <td>Marks the Object as Deleteable</td>
	 *   </tr>
	 *   <tr>
	 *     <td>#STATUS_CAN_OVERWRITE</th>
	 *     <td>Marks the Object as Overwriteable</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#STATUS_ALL_ALLOWED</th>
	 *     <td>Allows everything (reading, deleting, over-writing)</td>
	 *   </tr>
	 *   <tr>
	 *     <th>#STATUS_NOTHING_ALLOWED</th>
	 *     <td>Allows nothing (reading, deleting, over-writing)</td>
	 *   </tr>
	 * </table>
	 * as fast references.
	 * 
	 * You can combine this values for proper uses binary with:
	 * #STATUS_CAN_DELETE | #STATUS_CAN_OVERWRITE
	 * to apply only two status.
	 * 
	 * @param object The object that should be modified.
	 * @param status Status that should apply.
	 */
	public static function setAccessPermissions(object, status:Number):Void {
		_global.ASSetPropFlags(object, null, status, true);
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
		if((typeof anObject == "string" || typeof anObject ==  "number" || typeof anObject ==  "movieclip") && aClass == Object) {
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
		if (object == undefined) return true;
		if (object == null) return true;
		return false;
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
}