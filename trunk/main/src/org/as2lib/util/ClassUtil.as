import org.as2lib.core.BasicClass;

/**
 * ClassUtil contains fundamental operations to efficiently and easily work
 * with any type of function(class).
 * All methods here are supposed to be used with functions treaten as classes.
 *
 * @author: Martin heidegger
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.util.ClassUtil extends BasicClass {
	
	private function BasicClass (Void) {}
	
	/**
	 * Checks if the passed class is extended by another class.
	 * 
	 * @param subClass Class that should get checked.
	 * @param superClass Class that should be matched
	 * @return true if the class is a subclass of the other class.
	 */
	public static function isSubClassOf(subClass:Function, superClass:Function):Boolean {
		if(subClass == null || superClass == null) {
			return false;
		} else if (subClass.prototype instanceof superClass){
			return true;
		}
	}
	
	/**
	 * Checks if the passed classes implements an interfaces.
	 * 
	 * @param class Class that should get checked.
	 * @param interfaceObject Interface that the class should implement
	 * @autor Martin Heidegger, Ralf Bokelberg (www.qlod.com)
	 */
	public static function isImplementationOf(clazz:Function, interfaceObject:Function):Boolean {
		var o:Object = new Object();
		o.__proto__ = clazz..prototype;
		return (o instanceof interfaceObject);
	}
}