import org.as2lib.test.unit.Failure

/**
 * Basic Class to be Extended by all Testcases.
 * This class provides all Function to be used by traditional Testcases.
 * It should used by all Testcases. It uses the Class "test.Failure" for Errors.
 * This is a Subproject from www.as2lib.org.
 *
 * @autor Martin Heidegger
 * @date 16.11.2003
 * 
 * @see Failure
 */

class org.as2lib.test.unit.Test {
	
	// Classname of the actual Class
	private static var atClass:String = "";
	// Function of the actual Function
	private static var atFunction:String = "";
	// Errors that occured
	private static var errors:Array;
	// Paths that has been found
	private static var paths:Array;
	// Starttime for a run
	private static var startTime:Number;
	// Function that started the Test
	private static var startedAt:String;
	// Path where the Action Started
	private static var startedPath:String;
	// Var to view the actual running case from outside
	public static var runningTest;
	
	/**
	 * Starts a Testcase (useful with different Methods to start an Testcase)
	 *
	 * @see #exitTest
	 *
	 * @param at	Method that starts the Testcase
	 * @param path	Path where the Testcase has started
	 */
	private static function initTest (at:String, path:String):Void {
		if(!startTime) {
			startedAt = at;
			if(!path) {
				startedPath = "unknown";
			} else {
				startedPath = path;
			}
			startTime = getTimer();
			errors = new Array();
			paths = new Array();
		}
	}
	
	/**
	 * Exits an started Testcase if it started within the same method
	 * 
	 * @see #initTest
	 *
	 * @param at	Method where the Testcase should have started
	 */
	private static function exitTest (at:String):Void {
		if(at == startedAt) {
			printResult();
			delete(startedPath);
			delete(startedAt);
			delete(startTime);
			delete(errors);
			delete(paths);
		}
	}
	
	/**
	 * Basic Method for Testruns. path Should be a String of Classes
	 * where the Test should run. All Objects that extend This Class will be used.
	 * The Method checks if the Object to this Path is an Method (Class) or an Object (Instance)
     * So you can use "run(test.className)" or "run(test)".
	 *
	 * @see #runPath
	 *
	 * @param path	Path where the Testcase should run (for example: test.org.as2lib)
	 */
	public static function run(path:String):Void {
		initTest("run", path);
		var myObject = eval("_global."+path);
		if(typeof myObject == "object") {
			runObject(myObject, path);
		} else if(typeof myObject == "function") {
			runClass(myObject, path);
		}
		exitTest("run");
	}
	
	/**
	 * Method to run a Testcase for Classes (type == function).
	 * This Method creates an Instance of the Class and runs a Testcase for that.
	 *
	 * @param useClass	
	 */
	public static function runClass(useClass, myPath:String):Void {
		initTest("runClass");
		if(myPath.indexOf("__constructor__") < 0 || !myPath) {
			var tempVar = new useClass();
			runObject(tempVar, myPath);
		}
		exitTest("runClass");
	}
	
	/**
	 * Method to run a Testcase for an Object.
	 *
	 * @pathObject	Object that should be used for an Testcase.
	 * @myPath		Pathstring to check.
	 */
	public static function runObject(pathObject, myPath:String):Void {
		initTest("runObject");
		var that = eval("th"+"is");
		if(pathObject instanceof that) {
			runTest(pathObject, myPath);
		} else {
			for(var i:String in pathObject) {
				if(typeof pathObject[i] == "function") {
					runClass (pathObject[i], myPath+"."+i);
				} else if (typeof pathObject[i] == "object") {
					runObject (pathObject[i], myPath+"."+i);
				}
			}
		}
		exitTest("runObject");
	}
	
	/**
	 * Method to run an Test.
	 *
	 * @pathObject	Test that should be run.
	 * @myPath		Path where the Test runs.
	 */
	private static function runTest (pathObject, myPath:String):Void {
		if(!myPath) {
			myPath = "unknown";
		}
		paths.push(myPath);
		
		var toMyObject = pathObject.__proto__;
		atClass = pathObject;
		
		runningTest = toMyObject;
		
		
		
		// Setting the right Properties to get all Functions!
		_global.ASSetPropFlags(toMyObject,null,6,true);			
		
		for(var j:String in toMyObject) {
			if(j.indexOf("test") == 0 && typeof toMyObject[j] == "function") {
				atFunction = j;
				pathObject[j]();
				paths.push(myPath+"."+j+"()");
			}
		}
	}
	
	/**
	 * Prints the Result of the Testcase.
	 *
	 * @see #run
	 * 
	 * @param path	Initial Runpath of the Testcase
	 */
	private static function printResult(Void):Void {
		trace(" Testcaseresult for "+startedPath+" ["+(getTimer()-startTime)+"ms]:");
		if(paths.length > 0) {
			for(var i:Number = 0; i<paths.length ; i++) {
				trace("  Testcase found:"+paths[i]);
			}
			trace("");
			if(errors.length > 0) {
				trace("  "+errors.length+" Errors occured");
				for(var i:Number = 0; i< errors.length; i++) {
					trace(errors[i].toString());
				}			
			} else {
				trace("  -- No Error occured --");
			}
		} else {
			trace("  -- No Testcases found @ "+startedPath+"--");
		}
		trace("");
	}
	
	/**
	 * Adds an Error to the Errorlist.
	 * It fills the Error with the Values of the actual Function, Class Time.
	 *
	 * @param message	Message to the Error.
	 */
	private static function addError (message:String):Void {
		errors.push(new Failure(atFunction, atClass, getTimer()-startTime, message));
	}
	
	/**
	 * Asserts if one var is shurly True.
	 *
	 * @see #assertTrueWithMessage
	 * @see #assertFalse
	 * @see #assertFalseWithMessage
	 * 
	 * @param var1		Var that should be true.
	 */
	private static function assertTrue (var1):Void {
		assertTrueWithMessage ("undefined", var1);
	}

	/**
	 * Uses a Message to #assertTrue.
	 *
	 * @see #assertTrue
	 * @see #assertFalse
	 * @see #assertFalseWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should be true.
	 */
	private static function assertTrueWithMessage (message:String, var1):Void {
		if(var1 != true) {
			addError("assertTrue failed: "+var1+" != true message: "+message);
		}
	}
	
	/**
	 * Asserts if one var is shurly False.
	 * 
	 * @see #assertTrue
	 * @see #assertTrueWithMessage
	 * @see #assertFalseWithMessage
	 *
	 * @param var1	First var.
	 */
	private static function assertFalse (var1):Void {
		assertFalseWithMessage ("undefined", var1);
	}
	
	
	/**
	 * Uses a Message to #assertFalse.
	 *
	 * @see #assertTrue
	 * @see #assertTrueWithMessage
	 * @see #assertFalse
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		First Var.
	 */
	private static function assertFalseWithMessage (message:String, var1):Void {
		if(var1 != false) {
			addError("assertFalse failed: "+var1+" != false message: "+message);
		}
	}
	
	/**
	 * Asserts if two Vars are the same.
	 *
	 * @see #assertEqualsWithMessage
	 * @see #assertNotEquals
	 * @see #assertNotEqualsWithMessage
	 * 
	 * @param var1	First Var.
	 * @param var2	Second Var.
	 */
	private static function assertEquals (var1, var2):Void {
		assertEqualsWithMessage ("undefined", var1, var2);
	}

	/**
	 * Uses a Message to #assertEquals.
	 *
	 * @see #assertEquals
	 * @see #assertNotEquals
	 * @see #assertNotEqualsWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		First Var.
	 * @param var2		Second Var.
	 */
	private static function assertEqualsWithMessage (message:String, var1, var2):Void {
		if(var1 != var2) {
			addError("assertEquals failed: "+var1+" != "+var2+" message: "+message);
		}
	}
	
	/**
	 * Asserts if two Vars are Not the same.
	 * 
	 * @see #assertEquals
	 * @see #assertEqualsWithMessage
	 * @see #assertNotEqualsWithMessage
	 *
	 * @param var1	First var.
	 * @param var2	Second var.
	 */
	private static function assertNotEquals (var1, var2):Void {
		assertNotEqualsWithMessage ("undefined", var1, var2);
	}
	
	
	/**
	 * Uses a Message to #assertNotEquals.
	 *
	 * @see #assertEquals
	 * @see #assertEqualsWithMessage
	 * @see #assertNotEquals
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		First Var.
	 * @param var2		Second Var.
	 */
	private static function assertNotEqualsWithMessage (message:String, var1, var2):Void {
		if(var1 == var2) {
			addError("assertNotEquals failed: "+var1+" == "+var2+" message: "+message);
		}
	}
	
	/**
	 * Asserts if an Var is not Null.
	 *
	 * @see #assertNotNullWithMessage
	 * @see #assertNull
	 * @see #assertNullWithMessage
	 * 
	 * @param var1	Var that should be Null.
	 */
	private static function assertNotNull (var1):Void {
		assertNotNullWithMessage("undefined", var1);
	}	
	
	/**
	 * Adds a Message to #assertNotNull.
	 *
	 * @see #assertNotNull
	 * @see #assertNull
	 * @see #assertNullWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should not be Null.
	 */
	private static function assertNotNullWithMessage (message:String, var1):Void {
		if(var1 == null) {
			addError("assertNotNull failed: "+var1+" message: "+message);
		}
	}

	
	/**
	 * Asserts if an Var is Null.
	 *
	 * @see #assertNotNull
	 * @see #assertNotNullWithMessage
	 * @see #assertNullWithMessage
	 * 
	 * @param var1	Var that should be Null.
	 */
	private static function assertNull (var1):Void {
		assertNullWithMessage("undefined", var1);
	}
	
	/**
	 * Adds a Message to #assertNull.
	 *
	 * @see #assertNotNull
	 * @see #assertNull
	 * @see #assertNullWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should not be Null.
	 */
	private static function assertNullWithMessage (message:String, var1):Void {
		if(var1 != null) {
			addError("assertNull failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * Asserts if an Var is not Undefined.
	 *
	 * @see #assertNotUndefinedWithMessage
	 * @see #assertUndefined
	 * @see #assertUndefinedWithMessage
	 * 
	 * @param var1	Var that should not be Undefined.
	 */
	private static function assertNotUndefined (var1):Void {
		assertNotUndefinedWithMessage("undefined", var1);
	}
	
	/**
	 * Adds a Message to #assertNotUndefined.
	 *
	 * @see #assertNotUndefined
	 * @see #assertUndefined
	 * @see #assertUndefinedWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should not be Undefined.
	 */
	private static function assertNotUndefinedWithMessage (message:String, var1):Void {
		if(var1 == undefined) {
			addError("assertNotUndefined failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * Asserts if an Var is undefined.
	 *
	 * @see #assertNotUndefined
	 * @see #assertNotUndefinedWithMessage
	 * @see #assertUndefinedWithMessage
	 * 
	 * @param var1	Var that should be Undefined.
	 */
	private static function assertUndefined (var1):Void {
		assertUndefinedWithMessage("undefined", var1);
	}
	
	/**
	 * Adds a Message to #assertUndefined.
	 *
	 * @see #assertNotUndefinedWithMessage
	 * @see #assertNotUndefined
	 * @see #assertUndefined
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should not be Undefined.
	 */
	private static function assertUndefinedWithMessage (message:String, var1):Void {
		if(var1 != undefined) {
			addError("assertUndefined failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * Asserts if an Var is Infinity.
	 *
	 * @see #assertNotInifityWithMessage
	 * @see #assertInfinity
	 * @see #assertInfinityWithMessage
	 * 
	 * @param var1	Var that should not be Infinity.
	 */	
	private static function assertNotInfinity (var1:Number):Void {
		assertNotInfinityWithMessage("undefined", var1);
	}

	/**
	 * Adds a Message to #assertNotInfinity.
	 *
	 * @see #assertNotInifity
	 * @see #assertInfinity
	 * @see #assertInfinityWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should not be Infinity.
	 */	
	private static function assertNotInfinityWithMessage (message:String, var1:Number):Void {
		if(var1 == Infinity) {
			addError("assertNotInfinity failed: "+var1+" message: "+message);
		}
	}
	
	
	/**
	 * Asserts if an Var is not Infinity.
	 *
	 * @see #assertNotInfinity
	 * @see #assertNotInifityWithMessage
	 * @see #assertInfinityWithMessage
	 * 
	 * @param var1	Var that should be Infinity.
	 */	
	private static function assertInfinity (var1:Number):Void {
		assertInfinityWithMessage("undefined", var1);
	}

	/**
	 * Adds a Message to #assertInfinity.
	 *
	 * @see #assertNotInifity
	 * @see #assertNotInfinityWithMessage
	 * @see #assertInfinity
	 * 
	 * @param message	Message to be displayed when an Error occured.
	 * @param var1		Var that should not be Infinity.
	 */	
	private static function assertInfinityWithMessage (message:String, var1:Number):Void {
		if(var1 == Infinity) {
			addError("assertInfinity failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * Adds a user-defined Error to the Error-List.
	 *
	 * @param message	Message that should be called with the Error.
	 */
	private static function fail (message:String):Void {
		addError("Failure: "+message);
	}
	
	/**
	 * Asserts if an Exception is thrown by calling an Function.
	 * 
	 * @param exception		Class of the Exception that should be thrown.
	 * @param theFunction	Function that should be called.
	 * @param parameters	Parameters to call the Array.
	 */
	private static function assertThrows(exception:Function, theFunction:Function, parameters:Array):Void {
		var exceptionThrown:Boolean = false;
		try {
			theFunction.apply(null, parameters);
		} catch (e:Error) {
			if (e instanceof exception) {
				exceptionThrown = true;
			}
		}
		if (!exceptionThrown) {
			addError("assertThrows: The expected Exception was not thrown.");
		}
	}
}