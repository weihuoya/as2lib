import test.Failure

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

class test.Test {
	
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
	
	/**
	 * Basic Method for Testruns. path Should be a String of Classes
	 * where the Test should run. All Objects that extend This Class will be used.
	 *
	 * @see #runPath
	 *
	 * @param path	Path where the Testcase should run (for example: test.org.as2lib)
	 */
	public static function run(path:String):Void {
		startTime = getTimer();
		errors = new Array();
		paths = new Array();
		runPath(eval("_global."+path));
		printResult(path);
	}
	
	/**
	 * Internal Method to Run all TestcaseMethods inside an Object. The Methods are
	 * defined with "test" in the Name at beginning.
	 * (this Function also checks if the Object is an Instance of this Class.)
	 *
	 * @param pathObject	Object where testMethods should be inside
	 */
	private static function runPath(pathObject:Object):Void {
		for(var i:String in pathObject) {
			if(typeof pathObject[i] == "function") {
				var tempVar = new pathObject[i]();
				if(tempVar instanceof test.Test) {
					var myObject = tempVar.__proto__;
					atClass = i;
					paths.push(i);
					
					// Setting the right Properties to get all Functions!
					_global.ASSetPropFlags(myObject,null,6,true);					
					for(var j:String in myObject) {
						if(j.indexOf("test") == 0 && typeof myObject[j] == "function") {
							atFunction = j;
							myObject[j]();
							paths.push(i+"."+j+"()");
						}
					}
				}
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
	private static function printResult(path:String):Void {
		trace(" Testcaseresult for "+path+" ["+(getTimer()-startTime)+"ms]:");
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
			trace("  -- No Testcases found @ "+path+" --");
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
	 * Asserts if two Vars are the same.
	 *
	 * @see #assertTrueWithMessage
	 * @see #assertFalse
	 * @see #assertFalseWithMessage
	 * 
	 * @param var1	First Var.
	 * @param var2	Second Var.
	 */
	private static function assertTrue (var1, var2):Void {
		assertTrueWithMessage ("undefined", var1, var2);
	}

	/**
	 * Uses a Message to #assertTrue.
	 *
	 * @see #assertTrue
	 * @see #assertFalse
	 * @see #assertFalseWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		First Var.
	 * @param var2		Second Var.
	 */
	private static function assertTrueWithMessage (message:String, var1, var2):Void {
		if(var1 != var2) {
			addError("assertTrue failed: "+var1+" != "+var2+" message: "+message);
		}
	}
	
	/**
	 * Asserts if two Vars are Not the same.
	 * 
	 * @see #assertTrue
	 * @see #assertTrueWithMessage
	 * @see #assertFalseWithMessage
	 *
	 * @param var1	First var.
	 * @param var2	Second var.
	 */
	private static function assertFalse (var1, var2):Void {
		assertFalseWithMessage ("undefined", var1, var2);
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
	 * @param var2		Second Var.
	 */
	private static function assertFalseWithMessage (message:String, var1, var2):Void {
		if(var1 == var2) {
			addError("assertFalse failed: "+var1+" == "+var2+" message: "+message);
		}
	}
	
	/**
	 * Asserts if an Var is not Null.
	 *
	 * @see assertNotNullWithMessage
	 * @see assertNull
	 * @see assertNullWithMessage
	 * 
	 * @param var1	Var that should be Null.
	 */
	private static function assertNotNull (var1):Void {
		assertNotNullWithMessage("undefined", var1);
	}	
	
	/**
	 * Adds a Message to #assertNotNull.
	 *
	 * @see assertNotNull
	 * @see assertNull
	 * @see assertNullWithMessage
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
	 * @see assertNotNull
	 * @see assertNotNullWithMessage
	 * @see assertNullWithMessage
	 * 
	 * @param var1	Var that should be Null.
	 */
	private static function assertNull (var1) {
		assertNullWithMessage("undefined", var1);
	}
	
	/**
	 * Adds a Message to #assertNull.
	 *
	 * @see assertNotNull
	 * @see assertNull
	 * @see assertNullWithMessage
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
	 * @see assertNotUndefinedWithMessage
	 * @see assertUndefined
	 * @see assertUndefinedWithMessage
	 * 
	 * @param var1	Var that should not be Undefined.
	 */
	private static function assertNotUndefined (var1) {
		assertNotUndefinedWithMessage("undefined", var1);
	}
	
	/**
	 * Adds a Message to #assertNotUndefined.
	 *
	 * @see assertNotUndefined
	 * @see assertUndefined
	 * @see assertUndefinedWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should not be Undefined.
	 */
	private static function assertNotUndefinedWithMessage (message:String, var1) {
		if(var1 == undefined) {
			addError("assertNotUndefined failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * Asserts if an Var is undefined.
	 *
	 * @see assertNotUndefined
	 * @see assertNotUndefinedWithMessage
	 * @see assertUndefinedWithMessage
	 * 
	 * @param var1	Var that should be Undefined.
	 */
	private static function assertUndefined (var1) {
		assertUndefinedWithMessage("undefined", var1);
	}
	
	/**
	 * Adds a Message to #assertUndefined.
	 *
	 * @see assertNotUndefinedWithMessage
	 * @see assertNotUndefined
	 * @see assertUndefined
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should not be Undefined.
	 */
	private static function assertUndefinedWithMessage (message:String, var1) {
		if(var1 != undefined) {
			addError("assertUndefined failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * Asserts if an Var is Infinity.
	 *
	 * @see assertNotInifityWithMessage
	 * @see assertInfinity
	 * @see assertInfinityWithMessage
	 * 
	 * @param var1	Var that should not be Infinity.
	 */	
	private static function assertNotInfinity (var1:Number) {
		assertNotInfinityWithMessage("undefined", var1);
	}

	/**
	 * Adds a Message to #assertNotInfinity.
	 *
	 * @see assertNotInifity
	 * @see assertInfinity
	 * @see assertInfinityWithMessage
	 * 
	 * @param message	Message to be displayed when an Error occured
	 * @param var1		Var that should not be Infinity.
	 */	
	private static function assertNotInfinityWithMessage (message:String, var1:Number) {
		if(var1 == Infinity) {
			addError("assertNotInfinity failed: "+var1+" message: "+message);
		}
	}
	
	
	/**
	 * Asserts if an Var is not Infinity.
	 *
	 * @see assertNotInfinity
	 * @see assertNotInifityWithMessage
	 * @see assertInfinityWithMessage
	 * 
	 * @param var1	Var that should be Infinity.
	 */	
	private static function assertInfinity (var1:Number) {
		assertInfinityWithMessage("undefined", var1);
	}

	/**
	 * Adds a Message to #assertInfinity.
	 *
	 * @see assertNotInifity
	 * @see assertNotInfinityWithMessage
	 * @see assertInfinity
	 * 
	 * @param message	Message to be displayed when an Error occured.
	 * @param var1		Var that should not be Infinity.
	 */	
	private static function assertInfinityWithMessage (message:String, var1:Number) {
		if(var1 == Infinity) {
			addError("assertInfinity failed: "+var1+" message: "+message);
		}
	}
	
	/**
	 * Adds a user-defined Error to the Error-List.
	 *
	 * @param message	Message that should be called with the Error.
	 */
	private static function fail (message:String) {
		addError("Failure: "+message);
	}
}