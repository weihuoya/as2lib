
import org.as2lib.basic.ReflectionObject
import org.as2lib.basic.exceptions.*

class org.as2lib.basic.Reflections {
	public static var foundTypes:Array;
	public static var foundObjects:Array;
	public static var foundClasses:Array;
	private static var started:Boolean;
	
	public static function findObject (realObject):ReflectionObject {
		if(!started) {
			checkType(realObject, "org.as2lib.basic.Reflections", "findObject");
			// Reset previous Searches
			resetResults();
			// Search in all Paths
			startIndexAll();
			// Return if Found
			var foundObj = allReadyFound(realObject);
			if(!foundObj) {
				throw new ObjectNotFoundException("The Object was at no reachable place. Maybe the scope from the Object was set to an function.", "org.as2lib.basic.Reflections", "findObject", arguments);
			} else {
				return(foundObj);
			}
		}
	}
	
	public static function checkType (object, place:String, inFunction:String):Void {
		if(typeof object == "undefined" || object == "null") {
			throw new WrongArgumentException("It is not possible to search for "+object, place, inFunction, new Array(object));
		}
	}
	
	public static function resetResults (Void):Void {
		foundTypes = new Array();
		foundObjects = new Array();
		foundClasses = new Array();
	}
	
	public static function startIndexAll (Void):Void {
		started = true;
		var root = new ReflectionObject(_root);
		root.addReference("_root", "_root", null);
		var global = new ReflectionObject(_global);
		global.addReference("_global", "_global", null);
		started = false;
	}
	
	public static function getClass (realObject):ReflectionObject {
		var reflClass = allReadyFoundReflectionClass(realObject);
		if(reflClass) {
			return(reflClass);
		} else {
			return (new ReflectionObject(realObject));
		}
	}
	
	public static function allReadyFound (realObject):ReflectionObject {
		if(typeof realObject == "function") {
			return(allReadyFoundReflectionClass(realObject));
		} else {
			return(allReadyFoundReflectionObject(realObject));
		}
	}
	
	public static function getType (reflObj:ReflectionObject):String {
		var realObject = reflObj.realObject;
		var type:String;
		if(typeof realObject != "object") {
			type = typeof(realObject);
		} else {
			if(realObject.prototype != function(){} && realObject.prototype ) {
				// Recursive Point
				reflObj.instanceOf = getClass(realObject.prototype);
				reflObj.instanceOf.addInstance(reflObj);
			}
			type = "object";
		}
		if(!foundTypes) {
			foundTypes = new Array();
		}
		if(!foundTypes[type]) {
		  foundTypes[type] = new Array();
		}
		foundTypes[type].push(reflObj);
		return(type);
	}
	
	public static function allReadyFoundReflectionObject(realObject):ReflectionObject {
		if(!foundObjects) {
			foundObjects = new Array();
		}
		for(var i:String in foundObjects) {
			if(foundObjects[i].realObject === realObject) {
				return(foundObjects[i]);
			}
		}
	}
	
	public static function allReadyFoundReflectionClass (realObject):ReflectionObject {
		if(!foundClasses) {
			foundClasses = new Array();
		}
		for(var i:Number; i<foundClasses.length; i++ ) {
			if(foundClasses[i].realObject === realObject) {
				return(foundClasses[i]);
			}
		}
	}
}