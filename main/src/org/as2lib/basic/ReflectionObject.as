import org.as2lib.basic.Reflections
import org.as2lib.basic.ReflectionReference

// TODO: already != all ready

class org.as2lib.basic.ReflectionObject implements org.as2lib.basic.interfaces.Cloneable {
	public var type:String;
	// @deprecated
	public var name:String;
	// @deprecated
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
	public var instanceInfos:org.as2lib.basic.ReflectionObject;
	public var __blockReflection__:Boolean;
	private static var count:Number = 0;
	
	function ReflectionObject (realObject) {
		this.realObject = realObject;
		//this.realObject.__reflectionInfo__ = this;
		this.references = new Array();
		this.instances = new Array();
		this.__blockReflection__ = true;
		
		
		// Registration & Evaluation from/to related Classes.
		if(typeof realObject == "function") {
			if(realObject.prototype) {
				this.extendedClass = Reflections.allReadyFound(realObject.prototype);
			}
			Reflections.foundClasses.push(this);
		} else {
			if(realObject.__constructor__) {
				this.instanceOf = Reflections.allReadyFound(realObject.__constructor__);
				this.instanceOf.addInstance(this);
			}
			Reflections.foundObjects.push(this);
		}
	}
	
	public function addReference (name:String, path:String, parentObject:org.as2lib.basic.ReflectionObject):Void {
		this.references.push(new ReflectionReference(name, path, parentObject));
		if(!this.setted) {
			this.setted = true;
			this.fetchAllInfos();
			/*
			if(typeof this.realObject == "function") {
				trace("--> found Class  : "+path+", "+this.type);
			} else {
				trace("--> found Object : "+path+", "+this.type);
			}
			*/
		}
	}
	
	public function addInstance (instance:org.as2lib.basic.ReflectionObject):Void {
		this.instances.push(instance);
	}
	
	public function get _name ():String {
		return(this.references[0].name);
	}
	
	public function get _classPath ():String {
		var returnValue:String = this._path;
		if(returnValue.indexOf("_global.") == 0) {
			returnValue = returnValue.substring(8, returnValue.length);
		}
		return(returnValue);
	}
	
	public function get _path ():String {
		trace('start');
		var lowestCountInstanceOf:Number;
		var lowestCountExtendedClass:Number;
		var countInstanceOf:Number;
		var countExtendedClass:Number;
		var usedPath:String = "[not found]";
		
		for(var i:Number = 0; i < this.references.length; i++) {
			var tempArray = this.references[i].path.split(".instanceOf");
			var tempArray2 = this.references[i].path.split(".extendedClass");
			countInstanceOf = tempArray.length;
			countExtendedClass = tempArray2.length;
			
			trace(countInstanceOf+":"+countExtendedClass+"-->"+this.references[i].path);
			
			if(!lowestCountInstanceOf || (countInstanceOf+countExtendedClass) < (lowestCountInstanceOf+lowestCountExtendedClass) ) {
				lowestCountInstanceOf = countInstanceOf;
				lowestCountExtendedClass = countExtendedClass;
				usedPath = this.references[i].path;
			}
		}
		trace('end');
		return(usedPath);
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
			if(
			    !this.realObject.__blockReflection__ && // Blocks information research
				this.realObject.__constructor__ // Simple Functions have no constructor ?! 
				) {
				
				//trace('-----> Calling: '+this._name);
				var instance = new this.realObject();
				this.instanceInfos = new org.as2lib.basic.ReflectionObject(instance);
				instance.addReference(this._name, this._path, this._parentObject);
			}
			if(!this.realObject.__blockReflection__) {
				this.getPropertiesAndMethods(this.realObject);
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
		if(name != "__constructor__" && !(content instanceof org.as2lib.basic.ReflectionObject)) {
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
	}
	
	public function toString (Void):String {
		return("[object org.as2lib.basic.ReflectionObject:"+this._path+"]");
	}
	
	public function clone (Void) {
		var returnValue:org.as2lib.basic.ReflectionObject = new org.as2lib.basic.ReflectionObject(this.realObject);
		for(var i:Number = 0; i< this.references.length; i++ ) {
			returnValue.addReference(this.references[i]._name, this.references[i]._path, this.references[i]._parentObject);
		}
		for(var i:Number = 0; i<this.instances.length; i++) {
			returnValue.addInstance(this.instances[i]);
		}
		return(returnValue);
	}
}