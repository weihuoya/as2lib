import org.as2lib.basic.OverloadHandler;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.basic.SimpleOverloadHandler implements OverloadHandler {
	private var args:Array;
	private var func:String;
	
	public function SimpleOverloadHandler(someArguments:Array, aFunction:String) {
		args = someArguments;
		func = aFunction;
	}
	
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
	private function isPrimitiveType(anObject:Object):Boolean {
		return (typeof(anObject) == "string"
				|| typeof(anObject) == "number"
				|| typeof(anObject) == "boolean");
	}
	private function typesDoNotMatch(firstObject:Object, secondObject:Object):Boolean {
		return (typeof(firstObject) != typeof(secondObject));
	}
	private function isNotInstanceOf(anObject:Object, aClass:Function):Boolean {
		return (!(anObject instanceof aClass));
	}
	
	public function execute(anObject:Object, someArguments:Array):Void {
		anObject[func].apply(null, someArguments);
	}
}