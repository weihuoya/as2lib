import org.as2lib.basic.ReflectionObject
import org.as2lib.basic.exceptions.*

class org.as2lib.basic.Reflections {
	public static var foundTypes:Array;
	public static var foundObjects:Array;
	public static var foundClasses:Array;
	public static var __blockReflection__:Boolean = true;
	private static var started:Boolean;
	
	public static function findObject (realObject):ReflectionObject {
		if(!started) {
			var foundObj:ReflectionObject = allReadyFound(realObject);
			checkType(realObject, arguments);
			// Reset previous Searches
			resetResults();
			// Search in all Paths
			startIndexAll();
			return(foundObj);
		}
	}
	
	public static function getInfosFor(realObject):ReflectionObject {
		if(!started) {
			var foundObj:ReflectionObject = allReadyFound(realObject);
			checkType(realObject, arguments);
			// Reset previous Searches
			resetResults();
			// Search in all Paths
			startIndexAll();
			return(foundObj);
		}
	}
	
	public static function checkType (object, path, name, parent, infoArguments:Array):Void {
		if(typeof object == "undefined" || object == "null") {
			throw new WrongArgumentException("It is not possible to search for '"+object+"'. It's only possible to search for existing Values!", infoArguments);
		}
	}
	
	public static function resetResults (Void):Void {
		delete(foundTypes);
		delete(foundObjects);
		delete(foundClasses);
	}
	
	public static function startIndexAll (Void):Void {
		if(!started) {
			started = true;
			var root = new ReflectionObject(_root);
			root.addReference("_root", "_root", null);
			var global = new ReflectionObject(_global);
			global.addReference("_global", "_global", null);
			started = false;
		}
	}
	
	public static function getClass (realObject):ReflectionObject {
		var reflClass = allReadyFoundReflectionClass(realObject);
		if(reflClass) {
			return (reflClass);
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
		return(new ReflectionObject(realObject));
	}
	
	public static function allReadyFoundReflectionClass (realObject):ReflectionObject {
		if(!foundClasses) {
			foundClasses = new Array();
		}
		//for(var i:Number; i<foundClasses.length; i++ ) {
		for(var i:String in foundClasses) {	
			if(foundClasses[i].realObject === realObject) {
				return(foundClasses[i]);
			}
		}
		return(new ReflectionObject(realObject));
	}
}