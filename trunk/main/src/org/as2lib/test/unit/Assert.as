import org.as2lib.core.BasicClass;
import org.as2lib.env.except.Exception;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.test.unit.error.*;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.Call;

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
	 * @see #isNullWithoutMessage
	 * @see #isNullWithMessage
	 */
	public static function isNull():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, undefined], isNullWithMessage);
		overload.addHandler([String, Object], isNullWithMessage);
		overload.addHandler([Object], isNullWithoutMessage);
		overload.addHandler([undefined], isNullWithoutMessage);
		overload.addHandler([], isNullWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks that a variable is a reference to null.
	 * Checks with a === that a variable is null.
	 *
	 * @see #isNull
	 * @see #isNullWithMessage
	 * @see #isNotNull
	 * @see #isNotNullWithoutMessage
	 * @see #isNotNullWithMessage
	 * 
	 * @throws AssertIsNullException if the assertion fails.
	 * @param var1 Variable that should be null
	 */
	public static function isNullWithoutMessage (var1):Void {
		isNullWithMessage ("", var1);
	}
	
	/**
	 * Appends a Message to @see #isNull.
	 *
	 * @see #isNull
	 * @see #isNullWithMessage
	 * @see #isNullWithMessage
	 * @see #isNotNull
	 * @see #isNotNullWithoutMessage
	 * 
	 * @throws AssertIsNullException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param var1 Variable that should be null.
	 */
	public static function isNullWithMessage (message:String, var1):Void {
		if(var1 !== null) {
			throw new AssertIsNullException(message, eval("th"+"is"), arguments, var1);
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
	 * Checks that a variable does not contain null.
	 * Checks with a !== that a variable is not null.
	 *
	 * @see #isNotNull
	 * @see #isNotNullWithMessage
	 * @see #isNull
	 * @see #isNullWithoutMessage
	 * @see #isNullWithMessage
	 * 
	 * @throws AssertIsNotNullException if the assertion fails.
	 * @param var1 Variable that should not be null.
	 */
	public static function isNotNullWithoutMessage (var1):Void {
		isNotNullWithMessage ("", var1);
	}
	
	/**
	 * Appends a Message to @see #isNotNull.
	 *
	 * @see #isNull
	 * @see #isNullWithoutMessage
	 * @see #isNotNull
	 * @see #isNotNullWithMessage
	 * @see #isNotNullWithoutMessage
	 * 
	 * @throws AssertIsNotNullException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param var1 Variable that should not be null.
	 */
	public static function isNotNullWithMessage (message:String, var1):Void {
		if(var1 === null) {
			throw new AssertIsNotNullException(message, eval("th"+"is"), arguments);
		}
	}

	/**
	 * overload
	 * @see #isUndefinedWithoutMessage
	 * @see #isUndefinedWithMessage
	 */
	public static function isUndefined():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, undefined], isUndefinedWithMessage);
		overload.addHandler([String, Object], isUndefinedWithMessage);
		overload.addHandler([Object], isUndefinedWithoutMessage);
		overload.addHandler([undefined], isUndefinedWithoutMessage);
		overload.addHandler([], isUndefinedWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks that a value contains undefined.
	 * Checks with a === that a variable is undefined.
	 *
	 * @see #isUndefined
	 * @see #isUndefinedWithMessage
	 * @see #isNotUndefined
	 * @see #isNotUndefinedWithoutMessage
	 * @see #isNotUndefinedWithMessage
	 * 
	 * @throws AssertIsUndefinedException if the assertion fails.
	 * @param var1 Variable that should be null
	 */
	public static function isUndefinedWithoutMessage (var1):Void {
		isUndefinedWithMessage ("", var1);
	}
	
	/**
	 * Appends a Message to @see #isUndefined.
	 *
	 * @see #isUndefined
	 * @see #isUndefinedWithMessage
	 * @see #isNotUndefined
	 * @see #isNotUndefinedWithMessage
	 * @see #isNotUndefinedWithoutMessage
	 * 
	 * @throws AssertIsUndefinedException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param var1 Variable that should be undefined.
	 */
	public static function isUndefinedWithMessage (message:String, var1):Void {
		if(var1 !== undefined) {
			throw new AssertIsUndefinedException(message, eval("th"+"is"), arguments, var1);
		}
	}

	/**
	 * overload
	 * @see #isNotUndefinedWithoutMessage
	 * @see #isNotUndefinedWithMessage
	 */
	public static function isNotUndefined():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, undefined], isNotUndefinedWithMessage);
		overload.addHandler([String, Object], isNotUndefinedWithMessage);
		overload.addHandler([Object], isNotUndefinedWithoutMessage);
		overload.addHandler([undefined], isNotUndefinedWithoutMessage);
		overload.addHandler([], isNotUndefinedWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks that a value does not contain undefined.
	 * Checks with a !== that a variable is not undefined.
	 *
	 * @see #isNotUndefined
	 * @see #isNotUndefinedWithMessage
	 * @see #isUndefined
	 * @see #isUndefinedWithoutMessage
	 * @see #isUndefinedWithMessage
	 * 
	 * @throws AssertIsNotUndefinedException if the assertion fails.
	 * @param var1 Variable that should not be undefined
	 */
	public static function isNotUndefinedWithoutMessage (var1):Void {
		isNotUndefinedWithMessage ("", var1);
	}
	
	/**
	 * Appends a Message to @see #isNotUndefined.
	 *
	 * @see #isNotUndefined
	 * @see #isNotUndefinedWithoutMessage
	 * @see #isUndefined
	 * @see #isUndefinedWithMessage
	 * @see #isUndefinedWithoutMessage
	 * 
	 * @throws AssertIsNotUndefinedException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param var1 Variable that should be undefined.
	 */
	public static function isNotUndefinedWithMessage (message:String, var1):Void {
		if(var1 === undefined) {
			throw new AssertIsNotUndefinedException(message, eval("th"+"is"), arguments);
		}
	}

	/**
	 * overload
	 * @see #isInfinityWithoutMessage
	 * @see #isInfinityWithMessage
	 */
	public static function isInfinity():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, undefined], isInfinityWithMessage);
		overload.addHandler([String, Object], isInfinityWithMessage);
		overload.addHandler([Object], isInfinityWithoutMessage);
		overload.addHandler([undefined], isInfinityWithoutMessage);
		overload.addHandler([], isInfinityWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks that a variable is a reference to Infinity.
	 * Checks with a === that a variable is Infinity.
	 *
	 * @see #isInfinity
	 * @see #isInfinityWithMessage
	 * @see #isNotInfinity
	 * @see #isNotInfinityWithoutMessage
	 * @see #isNotInfinityWithMessage
	 * 
	 * @throws AssertIsInfinityException if the assertion fails.
	 * @param var1 Variable that should be Infinity.
	 */
	public static function isInfinityWithoutMessage (var1):Void {
		isInfinityWithMessage ("", var1);
	}
	
	/**
	 * Appends a Message to @see #isInfinity.
	 *
	 * @see #isInfinity
	 * @see #isInfinityWithoutMessage
	 * @see #isNotInfinity
	 * @see #isNotInfinityWithMessage
	 * @see #isNotInfinityWithoutMessage
	 * 
	 * @throws AssertIsInfinityException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs.
	 * @param var1		Variable that should be Infinity.
	 */
	public static function isInfinityWithMessage (message:String, var1):Void {
		if(var1 !== Infinity) {
			throw new AssertIsInfinityException(message, eval("th"+"is"), arguments, var1);
		}
	}

	/**
	 * overload
	 * @see #isNotInfinityWithoutMessage
	 * @see #isNotInfinityWithMessage
	 */
	public static function isNotInfinity():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, undefined], isNotInfinityWithMessage);
		overload.addHandler([String, Object], isNotInfinityWithMessage);
		overload.addHandler([Object], isNotInfinityWithoutMessage);
		overload.addHandler([undefined], isNotInfinityWithoutMessage);
		overload.addHandler([], isNotInfinityWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks that a variable is not a reference to Infinity.
	 * Checks with a !== that a variable is not Infinity.
	 *
	 * @see #isNotInfinity
	 * @see #isNotInfinityWithMessage
	 * @see #isInfinity
	 * @see #isInfinityWithoutMessage
	 * @see #isInfinityWithMessage
	 * 
	 * @throws AssertIsNotInfinityException if the assertion fails.
	 * @param var1 Variable that should not be Infinity.
	 */
	public static function isNotInfinityWithoutMessage (var1):Void {
		isNotInfinityWithMessage ("", var1);
	}
	
	/**
	 * Appends a Message to @see #isNotInfinity.
	 *
	 * @see #isNotInfinity
	 * @see #isNotInfinityWithoutMessage
	 * @see #isInfinity
	 * @see #isInfinityWithMessage
	 * @see #isInfinityWithoutMessage
	 * 
	 * @throws AssertIsNotInfinityException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param var1 Variable that should not be Infinity.
	 */
	public static function isNotInfinityWithMessage (message:String, var1):Void {
		if(var1 === Infinity) {
			throw new AssertIsNotInfinityException(message, eval("th"+"is"), arguments, var1);
		}
	}

	/**
	 * overload
	 * @see #isEmptyWithoutMessage
	 * @see #isEmptyWithMessage
	 */
	public static function isEmpty():Void {
		var that = eval("th"+"is");
		var overload:Overload = new Overload(that);
		overload.addHandler([String, undefined], isEmptyWithMessage);
		overload.addHandler([String, Object], isEmptyWithMessage);
		overload.addHandler([Object], isEmptyWithoutMessage);
		overload.addHandler([undefined], isEmptyWithoutMessage);
		overload.addHandler([], isEmptyWithoutMessage);
		overload.forward(arguments);
	}
	
	/**
	 * Checks that a variable is undefined or null.
	 * Checks with a != that a variable is not undefined or null.
	 *
	 * @see #isEmpty
	 * @see #isEmptyWithMessage
	 * @see #isNotEmpty
	 * @see #isNotEmptyWithoutMessage
	 * @see #isNotEmptyWithMessage
	 * 
	 * @throws AssertIsEmptyException if the assertion fails.
	 * @param var1 Variable that should be empty.
	 */
	public static function isEmptyWithoutMessage (var1):Void {
		isEmptyWithMessage ("", var1);
	}
	
	/**
	 * Appends a Message to @see #isEmptyWithoutMessage.
	 * 
	 * @see #isEmpty.
	 * @see #isEmptyWithoutMessage
	 * @see #isNotEmpty
	 * @see #isNotEmptyWithMessage
	 * @see #isNotEmptyWithoutMessage
	 * 
	 * @throws AssertIsEmptyException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param var1 Variable that should be empty.
	 */
	public static function isEmptyWithMessage (message:String, var1):Void {
		if(!ObjectUtil.isEmpty(var1)) {
			throw new AssertIsEmptyException(message, eval("th"+"is"), arguments, var1);
		}
	}
	
	/**
	 * Checks that a variable is not undefined or null.
	 * Checks with a != that a variable is not undefined or null.
	 * Throws a exception if the check fails.
	 * 
	 * @see #isEmpty
	 * 
	 * @throws AssertIsNotEmptyException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param var1 Variable that should not be empty.
	 */
	public static function isNotEmpty (message:String, var1):Void {
		if(ObjectUtil.isEmpty(var1)) {
			throw new AssertIsNotEmptyException(message, eval("th"+"is"), arguments, var1);
		}
	}
	
	/**
	 * Checks if a call throws a exception type.
	 * Executes the given call and checks if it throws an defined error else it will throw an exception.
	 * 
	 * @throws NothingThrownException if nothing was thrown.
	 * @throws IllegalTypeThrownException if something different was thrown.
	 * @param message	Message that should be submitted if it fails.
	 * @param type		Exceptiontype that should be thrown.
	 * @param call		Call that should be executed.
	 * @param args		Arguments for the call.
	 */
	public static function isThrowing(message:String, type, call:Call, args):Void {
		try {
			call.execute(args);
			throw new NothingThrownException(message, eval("th"+"is"), arguments, call, args);
		} catch(e:org.as2lib.test.unit.error.NothingThrownException){
			throw e;
		} catch(e) {
			if(!ObjectUtil.isInstanceOf(e, type)) {
				throw new IllegalTypeThrownException(message, eval("th"+"is"), arguments, call, e, args);
			}
		}
	}
}