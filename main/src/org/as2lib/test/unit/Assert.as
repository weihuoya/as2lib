import org.as2lib.core.BasicClass;
import org.as2lib.env.except.Exception;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.test.unit.error.*;
import org.as2lib.util.ObjectUtil;

/**
 * This class is a collectioon of utils to assert different cases.
 * It is usually used internal for the testunit-system but it may be
 * used outside as well.
 * 
 * All methods throw exceptions if the matching condition failed.
 * 
 * @author Martin Heidegger
 * @see org.as2lib.test.unit.TestCases
 * @see org.as2lib.test.unit.TestResult
 * @see org.as2lib.test.unit.TestCaseMethodInfo
 */
class org.as2lib.test.unit.Assert extends BasicClass {
	
	/** Private Constructor, not instanciatable */
	private function Assert (Void) {}
	
	/**
	 * overload
	 * @see #isTrueWithMessage
	 * @see #isTrueWithoutMessage
	 */
	public static function isTrue():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isTrueWithMessage);
		overload.addHandler([Object], isTrueWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks if the given value var1 is true.
	 *
	 * @see #isTrueWithMessage
	 * @see #isFalse
	 * @see #isFalseWithoutMessage
	 * @see #isFalseWithMessage
	 * @throws AssertIsTrueException if the assertion fails.
	 * @param var1		Var that should be true.
	 */
	public static function isTrueWithoutMessage (var1:Boolean):Void {
		isTrueWithMessage ("", var1);
	}

	/**
	 * Appends a Message to @see #isTrue.
	 *
	 * @see #isTrue
	 * @see #isFalse
	 * @see #isFalseWithMessage
	 * @throws AssertIsTrueException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param var1	Var that should be true.
	 */
	public static function isTrueWithMessage (message:String, var1):Void {
		if(var1 !== true) {
			throw new AssertIsTrueException(message, var1, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * overload
	 * @see #isFalseWithMessage
	 * @see #isFalseWithoutMessage
	 */
	public static function isFalse():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isFalseWithMessage);
		overload.addHandler([Object], isFalseWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks if the given value var1 is false.
	 * 
	 * @see #isTrue
	 * @see #isTrueWithoutMessage
	 * @see #isTrueWithMessage
	 * @see #isFalse
	 * @see #isFalseWithMessage
	 * @throws AssertIsFalseException if the assertion fails.
	 * @param var1	First var.
	 */
	public static function isFalseWithoutMessage (var1):Void {
		isFalseWithMessage ("", var1);
	}
	
	/**
	 * Uses a Message to @see #isFalse.
	 *
	 * @see #isTrue
	 * @see #isTrueWithMessage
	 * @see #isFalse
	 * @see #isFalseWithoutMessage
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1		First Var.
	 */
	public static function isFalseWithMessage (message:String, var1):Void {
		if(var1 !== false) {
			throw new AssertIsFalseException(message, var1, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * overload
	 * @see #isEqualWithMessage
	 * @see #isEqualWithoutMessage
	 */
	public static function isEqual():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object, Object], isEqualWithMessage);
		overload.addHandler([Object, Object], isEqualWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Compares two valus if they are the same.
	 * This method compares two variables if the content is equal by "==".
	 *
	 * @see #isEqual
	 * @see #isEqualWithMessage
	 * @see #isNotEqual
	 * @see #isNotEqualWithoutMessage
	 * @see #isNotEqualWithMessage
	 * 
	 * @throws AssertIsEqualException if the assertion fails.
	 * @param var1 First var.
	 * @param var2 Second var.
	 */
	public static function isEqualWithoutMessage (var1, var2):Void {
		isEqualWithMessage ("", var1, var2);
	}
	
	/**
	 * Appends a Message to @see #isEqual.
	 *
	 * @see #isEqual
	 * @see #isEqualWithMessage
	 * @see #isNotEqual
	 * @see #isNotEqualWithoutMessage
	 * @see #isNotEqualWithMessage
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1 First Var.
	 * @param var2 Second Var.
	 */
	public static function isEqualWithMessage (message:String, var1, var2):Void {
		if(var1 != var2) {
			throw new AssertIsEqualException(message, var1, var2, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * overload
	 * @see #isNotEqualWithoutMessage
	 * @see #isNotEqualWithMessage
	 */
	public static function isNotEqual():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object, Object], isNotEqualWithMessage);
		overload.addHandler([Object, Object], isNotEqualWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks if two given objects are not equal.
	 * This method compares two variables if the content is not equal by "==".
	 * 
	 * @see #isEqual
	 * @see #isEqualWithoutMessage
	 * @see #isEqualWithMessage
	 * @see #isNotEqual
	 * @see #isNotEqualWithMessage
	 * 
	 * @throws AssertIsNotEqualException if the assertion fails.
	 * @param var1 First var.
	 * @param var2 Second var.
	 */
	public static function isNotEqualWithoutMessage (var1, var2):Void {
		isEqualWithMessage ("", var1, var2);
	}
	
	/**
	 * Appends a Message to @see #isNotEqual.
	 *
	 * @see #isEqual
	 * @see #isEqualWithMessage
	 * @see #isEqualWithMessage
	 * @see #isNotEqual
	 * @see #isNotEqualWithoutMessage
	 * 
	 * @throws AssertIsNotEqualException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param var1 First Var.
	 * @param var1 Second Var.
	 */
	public static function isNotEqualWithMessage (message:String, var1, var2):Void {
		if(var1 == var2) {
			throw new AssertIsNotEqualException(message, var1, var2, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * overload
	 * @see #isSameWithMessage
	 * @see #isSameWithoutMessage
	 */
	public static function isSame():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object, Object], isSameWithMessage);
		overload.addHandler([Object, Object], isSameWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Compares two valus if they are the same.
	 * This method compares two variables if they are references
	 * to the same object by ===.
	 *
	 * @see #isSame
	 * @see #isSameWithMessage
	 * @see #isNotSame
	 * @see #isNotSameWithoutMessage
	 * @see #isNotSameWithMessage
	 * 
	 * @throws AssertIsSameException if the assertion fails.
	 * @param var1 First var.
	 * @param var2 Second var.
	 */
	public static function isSameWithoutMessage (var1, var2):Void {
		isSameWithMessage ("", var1, var2);
	}
	
	/**
	 * Appends a Message to @see #isSame.
	 *
	 * @see #isSame
	 * @see #isSameWithMessage
	 * @see #isNotSame
	 * @see #isNotSameWithoutMessage
	 * @see #isNotSameWithMessage
	 * 
	 * @throws AssertIsSameException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param var1 First Var.
	 * @param var2 Second Var.
	 */
	public static function isSameWithMessage (message:String, var1, var2):Void {
		if(var1 !== var2) {
			throw new AssertIsSameException(message, var1, var2, eval("th"+"is"), arguments);
		}
	}
	/**
	 * overload
	 * @see #isNotSameWithMessage
	 * @see #isNotSameWithoutMessage
	 */
	public static function isNotSame():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object, Object], isNotSameWithMessage);
		overload.addHandler([Object, Object], isNotSameWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Compares two valus if they are not the same.
	 * This method compares two variables if they are references
	 * to the same object by !==.
	 *
	 * @see #isNotSame
	 * @see #isNotSameWithMessage
	 * @see #isSame
	 * @see #isSameWithoutMessage
	 * @see #isSameWithMessage
	 * 
	 * @throws AssertIsSameException if the assertion fails.
	 * @param var1 First var.
	 * @param var2 Second var.
	 */
	public static function isNotSameWithoutMessage (var1, var2):Void {
		isNotSameWithMessage ("", var1, var2);
	}
	
	/**
	 * Appends a Message to @see #isNotSame.
	 *
	 * @see #isNotSame
	 * @see #isNotSameWithMessage
	 * @see #isSame
	 * @see #isSameWithoutMessage
	 * @see #isSameWithMessage
	 * 
	 * @throws AssertIsSameException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param var1 First Var.
	 * @param var2 Second Var.
	 */
	public static function isNotSameWithMessage (message:String, var1, var2):Void {
		if(var1 === var2) {
			throw new AssertIsNotSameException(message, var1, var2, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * overload
	 * @see #isNotNullWithoutMessage
	 * @see #isNotNullWithMessage
	 */
	public static function isNotNull():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, undefined], isNotNullWithMessage);
		overload.addHandler([String, Object], isNotNullWithMessage);
		overload.addHandler([Object], isNotNullWithoutMessage);
		overload.addHandler([undefined], isNotNullWithoutMessage);
		overload.addHandler([], isNotNullWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks if two given objects are not equal.
	 * This methods checks with "!=" if two given variables do not contain the same value.
	 *
	 * @see #isNotNull
	 * @see #isNotNullWithMessage
	 * @see #isNull
	 * @see #isNullWithoutMessage
	 * @see #isNullWithMessage
	 * 
	 * @throws AssertIsNotNullException if the assertion fails.
	 * @param var1 First var.
	 * @param var2 Second var.
	 */
	public static function isNotNullWithoutMessage (var1, var2):Void {
		isNotNullWithMessage ("", var1, var2);
	}
	
	/**
	 * Appends a Message to @see #isNotNull.
	 *
	 * @see #isNull
	 * @see #isNullWithMessage
	 * @see #isNullWithMessage
	 * @see #isNotNull
	 * @see #isNotNullWithoutMessage
	 * 
	 * @throws AssertIsNotNullException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param var1 First Var.
	 * @param var1 Second Var.
	 */
	public static function isNotNullWithMessage (message:String, var1):Void {
		if(var1 === null) {
			throw new AssertIsNotNullException(message, eval("th"+"is"), arguments);
		}
	}

	/**
	 * overload
	 * @see #isNullWithMessage
	 * @see #isNullWithoutMessage
	 * /
	private static function isNull():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isNullWithMessage);
		overload.addHandler([Object], isNullWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Asserts if an Var is Null.
	 *
	 * @see #isNotNull
	 * @see #isNotNullWithoutMessage
	 * @see #isNotNullWithMessage
	 * @see #isNull
	 * @see #isNullWithMessage
	 * 
	 * @param var1	Var that should be Null.
	 * /
	private static function isNullWithoutMessage (var1):Void {
		isNullWithMessage("", var1);
	}
	
	/**
	 * Adds a Message to #isNull.
	 *
	 * @see #isNotNull
	 * @see #isNotNullWithoutMessage
	 * @see #isNotNullWithMessage
	 * @see #isNull
	 * @see #isNullWithoutMessage
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1		Var that should not be Null.
	 * /
	private static function isNullWithMessage (message:String, var1):Void {
		if(var1 !== null) {
			//addError("isNull failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * overload
	 * @see #isNotUndefinedWithMessage
	 * @see #isNotUndefinedWithoutMessage
	 * /
	private static function isNotUndefined():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isNotUndefinedWithMessage);
		overload.addHandler([Object], isNotUndefinedWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Asserts if an Var is not Undefined.
	 *
	 * @see #isNotUndefinedWithMessage
	 * @see #isNotUndefined
	 * @see #isUndefined
	 * @see #isUndefinedWithoutMessage
	 * @see #isUndefinedWithMessage
	 * 
	 * @param var1	Var that should not be Undefined.
	 * /
	private static function isNotUndefinedWithoutMessage (var1):Void {
		isNotUndefinedWithMessage("", var1);
	}
	
	/**
	 * Adds a Message to #isNotUndefined.
	 *
	 * @see #isNotUndefined
	 * @see #isNotUndefinedWithoutMessage
	 * @see #isUndefined
	 * @see #isUndefinedWithoutMessage
	 * @see #isUndefinedWithMessage
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1		Var that should not be Undefined.
	 * /
	private static function isNotUndefinedWithMessage (message:String, var1):Void {
		if(var1 === undefined) {
			//addError("isNotUndefined failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * overload
	 * @see #isUndefinedWithMessage
	 * @see #isUndefinedWithoutMessage
	 * /
	private static function isUndefined():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isUndefinedWithMessage);
		overload.addHandler([Object], isUndefinedWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Asserts if an Var is undefined.
	 *
	 * @see #isNotUndefined
	 * @see #isNotUndefinedWithoutMessage
	 * @see #isNotUndefinedWithMessage
	 * @see #isUndefined
	 * @see #isUndefinedWithMessage
	 * 
	 * @param var1	Var that should be Undefined.
	 * /
	private static function isUndefinedWithoutMessage (var1):Void {
		isUndefinedWithMessage("", var1);
	}
	
	/**
	 * Adds a Message to #isUndefined.
	 *
	 * @see #isNotUndefined
	 * @see #isNotUndefinedWithoutMessage
	 * @see #isNotUndefinedWithMessage
	 * @see #isUndefined
	 * @see #isUndefinedWithoutMessage
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1		Var that should not be Undefined.
	 * /
	private static function isUndefinedWithMessage (message:String, var1):Void {
		if(var1 != undefined) {
			//addError("isUndefined failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * overload
	 * @see #isIsEmptyWithMessage
	 * @see #isIsEmptyWithoutMessage
	 * /
	private static function isIsEmpty():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isIsEmptyWithMessage);
		overload.addHandler([Object], isIsEmptyWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Asserts if an Var is empty.
	 *
	 * @see #isIsEmpty
	 * @see ObjectUtil#isEmpty
	 * @see #isIsEmptyWithMessage
	 * 
	 * @param var1		Var that should be empty.
	 * /
	private static function isIsEmptyWithoutMessage (var1):Void {
		isIsEmptyWithMessage("", var1);
	}
	
	/**
	 * Asserts if an Var is empty.
	 *
	 * @see #isIsEmpty
	 * @see ObjectUtil#isEmpty
	 * @see #isIsEmptyWithMessage
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1		Var that should be empty.
	 * /
	private static function isIsEmptyWithMessage (message:String, var1):Void {
		if(!ObjectUtil.isEmpty(var1)) {
			//addError("isIsEmpty failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * overload
	 * @see #isIsNotEmptyWithMessage
	 * @see #isIsNotEmptyWithoutMessage
	 * /
	private static function isIsNotEmpty():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isIsNotEmptyWithMessage);
		overload.addHandler([Object], isIsNotEmptyWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Asserts if an Var is not empty.
	 *
	 * @see #isIsNotEmpty
	 * @see ObjectUtil#isEmpty
	 * @see #isIsNotEmptyWithMessage
	 * 
	 * @param var1		Var that should be empty.
	 * /
	private static function isIsNotEmptyWithoutMessage (var1):Void {
		isIsNotEmptyWithMessage("", var1);
	}
	
	/**
	 * Asserts if an Var is empty.
	 *
	 * @see #isIsNotEmpty
	 * @see ObjectUtil#isEmpty
	 * @see #isIsNotEmptyWithMessage
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1		Var that should be empty.
	 * /
	private static function isIsNotEmptyWithMessage (message:String, var1):Void {
		if(ObjectUtil.isEmpty(var1)) {
			//addError("isIsNotEmpty failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * overload
	 * @see #isNotInfinityWithMessage
	 * @see #isNotInfinityWithoutMessage
	 * /
	private static function isNotInfinity():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isNotInfinityWithMessage);
		overload.addHandler([Object], isNotInfinityWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Asserts if an Var is Infinity.
	 *
	 * @see #isNotInifity
	 * @see #isNotInifityWithMessage
	 * @see #isInfinity
	 * @see #isInfinityWithoutMessage
	 * @see #isInfinityWithMessage
	 * 
	 * @param var1	Var that should not be Infinity.
	 * /	
	private static function isNotInfinityWithoutMessage (var1:Number):Void {
		isNotInfinityWithMessage("", var1);
	}

	/**
	 * Adds a Message to #isNotInfinity.
	 *
	 * @see #isNotInifity
	 * @see #isNotInifityWithoutMessage
	 * @see #isInfinity
	 * @see #isInfinityWithoutMessage
	 * @see #isInfinityWithMessage
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1		Var that should not be Infinity.
	 * /	
	private static function isNotInfinityWithMessage (message:String, var1:Number):Void {
		if(var1 != Infinity) {
			//addError("isNotInfinity failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * overload
	 * @see #isInfinityWithMessage
	 * @see #isInfinityWithoutMessage
	 * /
	private static function isInfinity():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, Object], isInfinityWithMessage);
		overload.addHandler([Object], isInfinityWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Asserts if an Var is not Infinity.
	 *
	 * @see #isNotInfinity
	 * @see #isNotInifityWithoutMessage
	 * @see #isNotInifityWithMessage
	 * @see #isInfinity
	 * @see #isInfinityWithMessage
	 * 
	 * @param var1	Var that should be Infinity.
	 * /	
	private static function isInfinityWithoutMessage (var1:Number):Void {
		isInfinityWithMessage("", var1);
	}

	/**
	 * Adds a Message to #isInfinity.
	 *
	 * @see #isNotInfinity
	 * @see #isNotInifityWithoutMessage
	 * @see #isNotInifityWithMessage
	 * @see #isInfinity
	 * @see #isInfinityWithoutMessage
	 * 
	 * @param message	Message to be displayed if an error occures.
	 * @param var1		Var that should be Infinity.
	 * /	
	private static function isInfinityWithMessage (message:String, var1:Number):Void {
		if(var1 == Infinity) {
			//addError("isInfinity failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * Asserts if an Exception is thrown by calling an Function.
	 * 
	 * @param exception	Class of the Exception that should be thrown.
	 * @param atObject	Object where the call should get called.
	 * @param theFunction	Function that should be called.
	 * @param parameters	Parameters to call.
	 * /
	private static function isThrows(exception:Function, atObject, theFunction:String, parameters:Array):Void {
		var exceptionThrown:Boolean = false;
		try {
			atObject[theFunction].apply(atObject, parameters);
		} catch (e) {
			exceptionThrown = true;
			if (!(e instanceof exception)) {
				//addError("isThrows: ["+ReflectUtil.getClassInfo(e).getFullName()+"] was thrown but ["+ReflectUtil.getClassInfo(new exception()).getName()+"] was expected by calling ."+theFunction+"("+parameters+")");
			}
		}
		if (!exceptionThrown) {
			//addError("isThrows: No exception was thrown but ["+ReflectUtil.getClassInfo(new exception()).getFullName()+"] was expected for ."+theFunction+"("+parameters+")");
		}
	}
	
	/**
	 * Asserts that no exception will be thrown @ a call.
	 * 
	 * @param atObject	Object where the call should get called.
	 * @param theFunction	Function that should be called.
	 * @param parameters	Parameters to call.
	 * /
	private static function isNotThrows(atObject, theFunction:String, parameters:Array):Void {
		var exceptionThrown:Boolean = false;
		try {
			atObject[theFunction].apply(atObject, parameters);
		} catch (e) {
			//addError("isNotThrows: ["+ReflectUtil.getClassInfo(e).getFullName()+"] was thrown but not expected with ."+theFunction+"("+parameters+")");
		}
	}
	*/
}