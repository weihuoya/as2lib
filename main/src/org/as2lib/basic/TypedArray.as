/**
 * Acts like a normal Array but assures that only objects from one and the same type are added to the Array.
 */
class org.as2lib.basic.TypedArray {
	public static var CASEINSENSITIVE = Array.CASEINSENSITIVE;
	public static var DESCENDING = Array.DESCENDING;
	public static var NUMERIC = Array.NUMERIC;
	public static var RETURNINDEXDARRAY = Array.RETURNINDEXEDARRAY;
	public static var UNIQUESORT = Array.UNIQUESORT;
	
	private var array:Array;
	private var type:Function;
	
	public function TypedArray(type:Function, array:Array) {
		this.array = new Array();
		this.array.concat(array);
		this.type = type;
	}
	
	/**
	 * @see Array
	 */
	public function concat():TypedArray {
		var l:Number = arguments.length;
		for (var i:Number = 0; i < l; i++) {
			if (typeDoesNotMatch(arguments[i])) {
				// throw ...
			}
		}
		if (l == 0) {
			// TODO: Replace with .clone when ready
			return new TypedArray(this.type, new Array(this.array));
		} else {
			this.array.concat.apply(null, arguments);
		}
	}
	
	/**
	 * Gets the value associated with the given number.
	 * @param number
	 * @return the value
	 */
	public function getValue(number:Number):Object {
		return this.array[number];
	}
	
	/**
	 * Associates the given value with the name in the array.
	 * @param value
	 * @param name
	 * @return the length of the array
	 */
	public function setValueByName(value:Object, name:String):Number {
		this.array[name] = value;
		return length;
	}
	
	/**
	 * Gets the value associated with the given name.
	 * @param name
	 * @return the value
	 */
	public function getValueByName(name:String):Object {
		return this.array[name];
	}
	
	/**
	 * @see Array
	 */
	public function join(seperator:String):String {
		return this.array.join(seperator);
	}
	
	/**
	 * @see Array
	 */
	public function pop( Void ):Object {
		return this.array.pop();
	}
	
	/**
	 * @see Array
	 */
	public function push(value:Object):Number {
		if (typeDoesNotMatch(value)) {
			// throw ...
		}
		return this.array.push(value);
	}
	
	/**
	 * @see Array
	 */
	public function reverse(Void):Void {
		this.array.reverse();
	}
	
	/**
	 * @see Array
	 */
	public function shift(Void):Object {
		return this.array.shift();
	}
	
	/**
	 * @see Array
	 */
	public function sort():Object {
		return this.array.sort.apply(null, arguments);
	}
	
	/**
	 * @see Array
	 */
	public function sortOn():Object {
		return this.array.sortOn.apply(null, arguments);
	}
	
	/**
	 * @see Array
	 */
	public function splice(index:Number, count:Number):Void {
		this.array.splice.apply(null, arguments);
	}
	
	/**
	 * @see Array
	 */
	public function unshift(value:Object):Number {
		if (typeDoesNotMatch(value)) {
			// throw ...
		}
		return this.array.unshift(value);
	}
	
	/**
	 * @return the type of the array
	 */
	public function getType(Void):Function {
		return this.type;
	}
	
	/**
	 * @see Array
	 */
	public function get length():Number {
		return (this.array.length);
	}
	
	/**
	 * Checks if the type does not match the type of the object.
	 * @param object
	 * @return true if the types do not match otherwise false
	 */
	public function typeDoesNotMatch(object:Object):Boolean {
		if (isPrimitiveType(object)) {
			if (typesDoNotMatch(type(object), object)) {
				return false;
			}
		} else {
			if (isNotInstanceOf(object, type)) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Checks if the object is a primitive type.
	 * @param anObject
	 * @return true if the object is a primitive type else false
	 */
	private function isPrimitiveType(anObject:Object):Boolean {
		return (typeof(anObject) == "string"
				|| typeof(anObject) == "number"
				|| typeof(anObject) == "boolean");
	}
	
	/**
	 * Checks if types fo the first object do not match the types of the second object.
	 * @param firstObject
	 * @param secondObject
	 * @return true if the types don't match else false
	 */
	private function typesDoNotMatch(firstObject:Object, secondObject:Object):Boolean {
		return (typeof(firstObject) != typeof(secondObject));
	}
	
	/**
	 * Checks if an object isn't an instance of a class.
	 * @param anObject
	 * @param aClass
	 * @return true if the object isn't an instance of the class otherwise false
	 */
	private function isNotInstanceOf(anObject:Object, aClass:Function):Boolean {
		return (!(anObject instanceof aClass));
	}
}