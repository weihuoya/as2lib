import org.as2lib.core.BasicClass;
import org.as2lib.core.string.ObjectStringifier;
import org.as2lib.core.string.Stringifier;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.util.ObjectUtil extends BasicClass{
	private static var stringifier:Stringifier = new ObjectStringifier();
	
	/**
	 * private constructor.
	 */
	private function ObjectUtil(Void) {
	}
	
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	public static function stringify(object:Object):String {
		return stringifier.execute(object);
	}
	
	/**
	 * Checks if the type of object matches the given type.
	 * @param anObject
	 * @param aType
	 * @return true if the type of the object matches else false
	 */
	public static function typesMatch(anObject:Object, aType:Function):Boolean {
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
	
	public static function compareTypeOf(firstObject:Object, secondObject:Object):Boolean {
		return (typeof(firstObject) == typeof(secondObject));
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
	public static function isTypeOf(object:Object, expression:String):Boolean {
		return (typeof(object) == expression);
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
	
	/**
	 *
	 */
	public static function isExplicitInstanceOf(object:Object, clazz:Function):Boolean {
		return (isInstanceOf(object, clazz) &&
				!isInstanceOf(object.__proto__, clazz));
	}
	
	/**
	 *
	 */
	public static function isEmpty(object:Object):Boolean {
		if (object == undefined) return true;
		if (object == null) return true;
		return false;
	}
	
	/**
	 *
	 */
	public static function isAvailable(object:Object):Boolean {
		return !isEmpty(object);
	}
}