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
		_global.ASSetPropFlag(this.__blockReflection__, null, 7, false);
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
			_global.ASSetPropFlags(this.realObject, null, 6, true);
			trace("------------> level ++ ["+(count++)+"] , "+this._name);
			for(var i:String in this.realObject) {
				if(!realObject[i].__blockReflection__) {
					var usedObject:org.as2lib.basic.ReflectionObject = Reflections.allReadyFound(realObject[i]);
					if(!usedObject) {
						var usedObject = new org.as2lib.basic.ReflectionObject(realObject[i]);
					}		
					usedObject.addReference(i, this.references[0].path+"."+i, this);
					//var usedObject:org.as2lib.basic.ReflectionObject = Reflections.addReflectionObject(realObject[i], i, this.references[0].path+"."+i, this);

					if(typeof realObject[i] == "function") {
						this.methods.push(usedObject);
					} else {
						this.properties.push(usedObject);
					}
				}
			}
			trace("------------> level --");
			count--;
		}
	}
}