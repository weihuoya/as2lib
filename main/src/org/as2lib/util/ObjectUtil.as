﻿/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.util.ObjectUtil {
	/**
	 * private constructor.
	 */
	private function ObjectUtil(Void) {
	}
	
	/**
	 * Checks if the type of object matches the given type.
	 * @param anObject
	 * @param aType
	 * @return true if the type of the object matches else false
	 */
	public static function typesMatch(anObject:Object, aType:Function):Boolean {
		if (ObjectUtil.isPrimitiveType(anObject)) {
			if (ObjectUtil.isTypeOf(aType(anObject), anObject)) {
				return true;
			}
		} else {
			if (ObjectUtil.isInstanceOf(anObject, aType)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Checks if the object is a primitive type.
	 * @param anObject
	 * @return true if the object is a primitive type else false
	 */
	public static function isPrimitiveType(anObject:Object):Boolean {
		return (typeof(anObject) == "string"
				|| typeof(anObject) == "number"
				|| typeof(anObject) == "boolean");
	}
	
	/**
	 * Checks if the type of the first object matches the type of the second object.
	 * @param firstObject
	 * @param secondObject
	 * @return true if the types do match else false
	 */
	public static function isTypeOf(firstObject:Object, secondObject:Object):Boolean {
		return (typeof(firstObject) == typeof(secondObject));
	}
	
	/**
	 * Checks if an object is an instance of a class.
	 * @param anObject
	 * @param aClass
	 * @return true if the object is an instance of the class otherwise false
	 */
	public static function isInstanceOf(anObject:Object, aClass:Function):Boolean {
		return (anObject instanceof aClass);
	}
}