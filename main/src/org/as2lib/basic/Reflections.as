
import org.as2lib.basic.ReflectionObject

class org.as2lib.basic.Reflections {
	public static var foundTypes:Array;
	public static var foundObjects:Array;
	public static var foundClasses:Array;
	
	public static function findObject (realObject):ReflectionObject {
		// Search in all Paths
		startIndex();
		// Return if Found
		return(allReadyFound(realObject));
	}
	
	public static function startIndex (Void):Void {
		foundTypes = new Array();
		foundObjects = new Array();
		foundClasses = new Array();
		
		var root = new ReflectionObject(_root);
		root.addReference("_root", "_root", null);
		var global = new ReflectionObject(_global);
		global.addReference("_global", "_global", null);
	}
	
	public static function getClass (realObject):ReflectionObject {
		var reflClass = allReadyFoundReflectionClass(realObject);
		trace('--> nu class'+typeof realObject);
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
	
	/*
	private static var checkedInstances:Array;
	private static var foundNodes:Array;
	private static var paths:Array;
	
	public static function getPathsForObject(baseObj:Object, obj:Object):Array {
		checkedInstances = new Array();
		foundNodes = new Array();
		paths = new Array();
		runPathForObject(baseObj, obj);
		return(foundNodes);
	}
	
	public static function getObjectInObject(baseObj:Object, obj:Object):ReflectionObject {
		var foundNodes:Array = getPathsForObject(baseObj, obj);
		var returnValue = new ReflectionObject();
	}
	
	public static function getClassName(instance:Object):String {
	}
	
	public static function getClassPath(myClass:Function):String {
	}
	
	
	public static function getMethodName(myMethod:Function):String {
	}
	
	public static function getStack () {
	}
	
	public static function fetchAllInfos () {
	}
	public static function getMethodsForObject (obj:Object):Array {
		var returnValue:Array = new Array();
		for(var i in obj) {
			if(typeof obj[i] == "function") {
				returnValue.push(i);
			}
		}
	}
	
	public static function runPathForObject (baseObj:Object, obj:Object):Void {
		if(typeof obj == "object") {
			if(baseObj === obj) {
				foundNodes.push(paths.join('.'));
			}
			if(!objectIsChecked(baseObj)) {
				_global.ASSetPropFlags(baseObj,null,6,true);
				checkedInstances.push(baseObj);
				for(var i in baseObj) {
					paths.push(i);
					runPathForObject(baseObj[i], obj);
					paths.pop();
				}
			}
		}
	}

	private static function objectIsChecked(obj):Boolean {
		for(var i in checkedInstances) {
			if(checkedInstances[i] === obj) {
				return(true);
			}
		}
		return(false);
	}
	*/
}