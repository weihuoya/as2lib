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
 * @see org.as2lib.test.unit.TestCase
 * @see org.as2lib.test.unit.TestResult
 * @see org.as2lib.test.unit.TestCaseMethodInfo
 */
class org.as2lib.test.unit.Assert extends BasicClass {
	
	/** Private Constructor, not instanciatable */
	private function Assert (Void) {}

	/**
	 * Checks if the given object is the same like true.
	 * Throws a exception if the check fails.
	 * 
	 * Appends a Message to @see #isTrue.
	 *
	 * @see #isTrue
	 * @see #isFalse
	 * @see #isFalseWithMessage
	 * @throws AssertIsTrueException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param object	Object that should be true.
	 */
	public static function isTrue (message:String, object):Void {
		if(object !== true) {
			throw new AssertIsTrueException(message, object, eval("th"+"is"), arguments);
		}
	}
	
	
	/**
	 * Checks if the given object is the same like false.
	 * Throws a exception if the check fails.
	 *
	 * @see #isTrue
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param object	Object that should be false.
	 */
	public static function isFalse (message:String, object):Void {
		if(object !== false) {
			throw new AssertIsFalseException(message, object, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * Compares two valus if they are the same.
	 * This method compares two variables if the content is equal by "==".
	 *
	 * Throws a exception if the check fails.
	 *
	 * @see #isNotEqual
	 * 
	 * @param message	Message to be displayed if an error occures
	 * @param var1		First Var.
	 * @param var2		Second Var.
	 */
	public static function isEqual (message:String, var1, var2):Void {
		if(var1 != var2) {
			throw new AssertIsEqualException(message, var1, var2, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * Checks if two given objects are not equal.
	 * This method compares two variables if the content is not equal by "==".
	 *
	 * Throws a exception if the check fails.
	 * 
	 * @see #isEqual
	 * 
	 * @throws AssertIsNotEqualException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param var1		First Var.
	 * @param var1		Second Var.
	 */
	public static function isNotEqual (message:String, var1, var2):Void {
		if(var1 == var2) {
			throw new AssertIsNotEqualException(message, var1, var2, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * Compares two valus if they are the same.
	 * This method compares two variables if they are references
	 * to the same object by ===.
	 * 
	 * Throws a exception if the check fails.
	 *
	 * @see #isNotSame
	 * 
	 * @throws AssertIsSameException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param var1		First Var.
	 * @param var2		Second Var.
	 */
	public static function isSame (message:String, var1, var2):Void {
		if(var1 !== var2) {
			throw new AssertIsSameException(message, var1, var2, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * Compares two valus if they are not the same.
	 * This method compares two variables if they are references
	 * to the same object by !==.
	 * 
	 * Throws a exception if the check fails.
	 *
	 * @see #isSame
	 * 
	 * @throws AssertIsSameException if the assertion fails.
	 * @param message	Message to be displayed if an error occures
	 * @param var1		First Var.
	 * @param var2		Second Var.
	 */
	public static function isNotSame (message:String, var1, var2):Void {
		if(var1 === var2) {
			throw new AssertIsNotSameException(message, var1, var2, eval("th"+"is"), arguments);
		}
	}

	/**
	 * Checks that a variable is a reference to null.
	 * Checks with a === that a variable is null.
	 * Throws a exception if the check fails.
	 *
	 * @see #isNotNull
	 * 
	 * @throws AssertIsNullException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param object	Object that should be null.
	 */
	public static function isNull (message:String, object):Void {
		if(object !== null) {
			throw new AssertIsNullException(message, eval("th"+"is"), arguments, object);
		}
	}
	
	/**
	 * Checks that a variable does not contain null.
	 * Checks with a !== that a variable is not null.
	 * Throws a exception if the check fails.
	 *
	 * @see #isNull
	 * 
	 * @throws AssertIsNotNullException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param object	Object that should not be null.
	 */
	public static function isNotNull (message:String, object):Void {
		if(object === null) {
			throw new AssertIsNotNullException(message, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * Checks that a value contains undefined.
	 * Checks with a === that a variable is undefined.
	 * Throws a exception if the check fails.
	 * 
	 * @see #isNotUndefined
	 * 
	 * @throws AssertIsUndefinedException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param object	Object that should be undefined.
	 */
	public static function isUndefined (message:String, object):Void {
		if(object !== undefined) {
			throw new AssertIsUndefinedException(message, eval("th"+"is"), arguments, object);
		}
	}
	
	/**
	 * Checks that a value does not contain undefined.
	 * Checks with a !== that a variable is not undefined.
	 * Throws a exception if the check fails.
	 *
	 * @see #isUndefined
	 * 
	 * @throws AssertIsNotUndefinedException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param object	Object that should be undefined.
	 */
	public static function isNotUndefined (message:String, object):Void {
		if(object === undefined) {
			throw new AssertIsNotUndefinedException(message, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * Checks that a variable is a reference to Infinity.
	 * Checks with a === that a variable is Infinity.
	 * Throws a exception if the check fails.
	 *
	 * @see #isNotInfinity
	 * 
	 * @throws AssertIsInfinityException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs.
	 * @param object		Object that should be Infinity.
	 */
	public static function isInfinity (message:String, object):Void {
		if(object !== Infinity) {
			throw new AssertIsInfinityException(message, eval("th"+"is"), arguments, object);
		}
	}
	
	/**
	 * Checks that a variable is not a reference to Infinity.
	 * Checks with a !== that a variable is not Infinity.
	 * Throws a exception if the check fails.
	 * 
	 * @see #isInfinity
	 * 
	 * @throws AssertIsNotInfinityException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param object	Object that should not be Infinity.
	 */
	public static function isNotInfinity (message:String, object):Void {
		if(object === Infinity) {
			throw new AssertIsNotInfinityException(message, eval("th"+"is"), arguments, object);
		}
	}
	
	/**
	 * Checks that a variable is undefined or null.
	 * Checks with a != that a variable is not undefined or null.
	 * Throws a exception if the check fails.
	 * 
	 * @see #isNotEmpty
	 * 
	 * @throws AssertIsEmptyException if the assertion fails.
	 * @param message	Message to be displayed if an error occurs
	 * @param object	Object that should be empty.
	 */
	public static function isEmpty (message:String, object):Void {
		if(!ObjectUtil.isEmpty(object)) {
			throw new AssertIsEmptyException(message, eval("th"+"is"), arguments, object);
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
	 * @param object	Object that should not be empty.
	 */
	public static function isNotEmpty (message:String, object):Void {
		if(ObjectUtil.isEmpty(object)) {
			throw new AssertIsNotEmptyException(message, eval("th"+"is"), arguments, object);
		}
	}
	
	/**
	 * Checks if a call throws a exception type.
	 * Executes the given call and checks if it throws an defined error else it will throw an exception.
	 * 
	 * @see #isNotThrowing
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
	
	/**
	 * Checks if a call throws any exception type.
	 * Executes the given call and checks if it throws any error, else it will throw an exception.
	 * 
	 * @see #isNotThrowing
	 * 
	 * @throws NothingThrownException if nothing was thrown.
	 * @param message	Message that should be submitted if it fails.
	 * @param call		Call that should be executed.
	 * @param args		Arguments for the call.
	 */
	public static function isThrowingWithoutType(message:String,  call:Call, args):Void {
		try {
			call.execute(args);
			throw new NothingThrownException(message, eval("th"+"is"), arguments, call, args);
		} catch(e:org.as2lib.test.unit.error.NothingThrownException){
			throw e;
		} catch(e) {
		}
	}
	
	/**
	 * Checks if a call doesn't throw a expected exception type.
	 * Executes the given call and checks if it doesn't throw an defined error else it will throw an exception.
	 * 
	 * @see #isThrowing
	 * 
	 * @throws ExpectedTypeThrownException if the exception was thrown.
	 * @param message	Message that should be submitted if it fails.
	 * @param type		Exceptiontype that should be thrown.
	 * @param call		Call that should be executed.
	 * @param args		Arguments for the call.
	 */
	public static function isNotThrowing(message:String, type, call:Call, args):Void {
		try {
			call.execute(args);
		} catch(e) {
			if(ObjectUtil.isInstanceOf(e, type)) {
				throw new ExpectedTypeThrownException(message, eval("th"+"is"), arguments, call, args, e);
			}
		}
	}
	
	/**
	 * Checks if a call doesn't throw any exception.
	 * Executes the given call and checks if it doesn't throw anything, else it will throw an exception.
	 * 
	 * @see #isNotThrowing
	 * 
	 * @throws ExceptionThrownException if the exception was thrown.
	 * @param message	Message that should be submitted if it fails.
	 * @param call		Call that should be executed.
	 * @param args		Arguments for the call.
	 */
	public static function isNotThrowingWithoutType(message:String, call:Call, args):Void {
		try {
			call.execute(args);
		} catch(e) {
			throw new ExceptionThrownException(message, eval("th"+"is"), arguments, call, args, e);
		}
	}
}