import org.as2lib.basic.Reflections
import org.as2lib.basic.ReflectionReference

class org.as2lib.basic.ReflectionObject {
	public var type:String;
	public var name:String;
	public var path:String;
	public var methods:Array;
	public var properties:Array;
	public var realObject;
	public var instanceOf:org.as2lib.basic.ReflectionObject;
	public var setted:Boolean;
	public var extendedClass:org.as2lib.basic.ReflectionObject;
	public var parentObject:org.as2lib.basic.ReflectionObject;
	public var references:Array;
	public var instances:Array;
	public var __blockReflection__:Boolean;
	private static var count:Number = 0;
	
	function ReflectionObject (realObject) {
		this.realObject = realObject;
		this.references = new Array();
		this.instances = new Array();
		this.__blockReflection__ = true;
		if(typeof realObject == "function") {
			Reflections.foundClasses.push(this);
		} else {
			Reflections.foundObjects.push(this);
		}
	}
	
	public function addReference (name:String, path:String, parentObject:org.as2lib.basic.ReflectionObject):Void {
		this.references.push(new ReflectionReference(name, path, parentObject));
		if(!this.setted) {
			this.setted = true;
			this.fetchAllInfos();
			trace("--> found: "+path+", "+this.type);
		}
	}
	
	public function addInstance (instance:org.as2lib.basic.ReflectionObject):Void {
		this.instances.push(instance);
	}
	
	public function get _name ():String {
		return(this.references[0].name);
	}
	
	public function get _path ():String {
		return(this.references[0].path);
	}
	
	public function get _parentObject ():org.as2lib.basic.ReflectionObject {
		return(this.references[0].parentObject);
	}
	
	public function fetchAllInfos ( Void ):Void {
		evaluateType();
		evaluatePropertiesAndMethods();
	}
	
	public function evaluateType ( Void ):Void {
		this.type = Reflections.getType(this);
	}
	
	public function getAllExtendedClasses(Void):Array {
		if(typeof realObject == "object") {
			var returnValue:Array = new Array();
			returnValue.push(this.instanceOf);
			// Recursive Point
			returnValue.concat(this.instanceOf.getAllExtendedClasses());
			return(returnValue);
		}
	}
	
	public function evaluatePropertiesAndMethods ( Void ):Void {
		this.methods = new Array();
		this.properties = new Array();
		
		if(typeof this.realObject == "object" || typeof this.realObject == "movieclip") {
			this.getPropertiesAndMethods(this.realObject);
		} else if(typeof this.realObject == "function") {
			// Class Defined Functions.
			this.getPropertiesAndMethods(this.realObject.prototype);
			// InstanceFunctions.
			if(/*this._name != "undefined" && !this._name &&*/ this.parentObject._name != "__constructor__" && !this.realObject.__blockReflection__){
				trace('-----> Calling: '+this_._name);
				var instance = new this.realObject();
				if(!instance.__blockReflection__) {
					this.getPropertiesAndMethods(instance);
				}
			}
		}
	}
	
	private function getPropertiesAndMethods (fromObject):Void {
		for(var i:String in fromObject) {
			addPropertyOrMethod(fromObject[i], i);
		}
		for(var j:Number = 0; j < fromObject.length; j++) {
			addPropertyOrMethod(fromObject[j], j);
		}
		count--;
	}
	
	private function addPropertyOrMethod (content, name):Void {
		var usedObject:org.as2lib.basic.ReflectionObject = Reflections.allReadyFound(content);
		if(!usedObject) {
			var usedObject = new org.as2lib.basic.ReflectionObject(content);
		}		
		usedObject.addReference(name, this.references[0].path+"."+name, this);
		if(typeof content == "function") {
			this.methods.push(usedObject);
		} else {
			this.properties.push(usedObject);
		}
	}
	
	public function toString (Void):String {
		return("[object org.as2lib.basic.ReflectionObject:"+this._path+"]");
	}
}