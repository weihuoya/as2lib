﻿import org.as2lib.core.BasicClass;

/**
 * ClassUtil contains fundamental operations to efficiently and easily work
 * with any class. All methods here are supposed to be used with functions treated
 * as classes.
 *
 * @author Martin heidegger
 */
class org.as2lib.util.ClassUtil extends BasicClass {
	/** Private constructor. */
	private function BasicClass(Void) {}
	
	/**
	 * Checks if the fistly passed class is extended by the secondly passed class.
	 * 
	 * @param subClass class that shall be checked.
	 * @param superClass class that shall be matched
	 * @return true if subClass is a subclass of superClass
	 */
	public static function isSubClassOf(subClass:Function, superClass:Function):Boolean {
		if(subClass == null || superClass == null) {
			return false;
		} else if (subClass.prototype instanceof superClass){
			return true;
		}
	}
	
	/**
	 * Checks if the passed class implements the interface.
	 * 
	 * @param class class that shall be checked.
	 * @param interfaceObject interface that the class shall implement
	 * @author Martin Heidegger
	 * @author Ralf Bokelberg (www.qlod.com)
	 */
	public static function isImplementationOf(clazz:Function, interfaceObject:Function):Boolean {
		var o:Object = new Object();
		o.__proto__ = clazz.prototype;
		return (o instanceof interfaceObject);
	}
}