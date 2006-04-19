/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
/**
 * Reflection Utils.
 * @author iiley
 */
class org.aswing.util.Reflection {
	
	/**
	 * Return the class object by the specified class name.
	 * <p>Then you can use this way to create a new instance of this class:
	 * <pre>
	 *     var classConstructor:Function = Reflection.getClass("your_class_name");
	 *     var instance:YourClass = YourClass(new classObj());
	 * </pre>
	 * Or call it's static method from this way:
	 * <pre>
	 *     var classConstructor:Function = Reflection.getClass("your_class_name");
	 *     classConstructor.itsStaticMethod(args);
	 * </pre>
	 * 
	 * @param fullname the class's full name include package. For example "org.aswing.Component"
	 * @return the class object of the name
	 */
	public static function getClass(fullname:String):Function{
		var parts:Array = fullname.split(".");
		var classObj:Object = _global;
		for(var i:Number=0; i<parts.length; i++){
			classObj = classObj[parts[i]];
		}
		return Function(classObj);
	}
	
	/**
	 * Returns is <code>subClass</code> is a sub class of <code>superClass</code>.
	 */
	public static function isSubClass(superClass:Function, subClass:Function):Boolean{
		var proto:Object = subClass.prototype;
		while(proto.__proto__ != undefined){
			if(proto.__proto__ === superClass.prototype){
				return true;
			}
			proto = proto.__proto__;
		}
		return false;
	}
}
