import org.as2lib.basic.OverloadHandler;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.basic.SimpleOverloadHandler implements OverloadHandler {
	/**
	 * Contains the arguments types of the function.
	 */
	private var args:Array;
	
	/**
	 * The name of the function.
	 */
	private var func:String;
	
	/**
	 * Constructs a new SimpleOverloadHandler instance.
	 * @param someArguments
	 * @param aFunction
	 */
	public function SimpleOverloadHandler(someArguments:Array, aFunction:String) {
		args = someArguments;
		func = aFunction;
	}
	
	/**
	 * @see org.as2lib.basic.OverloadHandler
	 */
	public function matches(someArguments:Array):Boolean {
		var l:Number = someArguments.length;
		if (l != args.length) {
			return false;
		}
		for (var i:Number = 0; i < l; i++) {
			if (isPrimitiveType(someArguments[i])) {
				if (typesDoNotMatch(args[i](someArguments[i]), someArguments[i])) {
					return false;
				}
			} else {
				if (isNotInstanceOf(someArguments[i], args[i])) {
					return false;
				}
			}
		}
		return true;
	}
	
	/**
	 * Checks if the object is a primitive type.
	 * @param anObject
	 * @return true if the object is a primitive type else false
	 */
	private function isPrimitiveType(anObject:Object):Boolean {
		return (typeof(anObject) == "string"
				|| typeof(anObject) == "number"
				|| typeof(anObject) == "boolean");
	}
	
	/**
	 * Checks if types fo the first object do not match the types of the second object.
	 * @param firstObject
	 * @param secondObject
	 * @return true if the types don't match else false
	 */
	private function typesDoNotMatch(firstObject:Object, secondObject:Object):Boolean {
		return (typeof(firstObject) != typeof(secondObject));
	}
	
	/**
	 * Checks if an object isn't an instance of a class.
	 * @param anObject
	 * @param aClass
	 * @return true if the object isn't an instance of the class otherwise false
	 */
	private function isNotInstanceOf(anObject:Object, aClass:Function):Boolean {
		return (!(anObject instanceof aClass));
	}
	
	/**
	 * @see org.as2lib.basic.OverloadHandler
	 */
	public function execute(anObject:Object, someArguments:Array):Void {
		anObject[func].apply(null, someArguments);
	}
}