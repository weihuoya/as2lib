import org.as2lib.util.ObjectUtil;

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
	
	/**
	 * Constructs a new TypedArray instance.
	 * @param type
	 */
	public function TypedArray(type:Function, array:Array) {
		// Problem: The types the array passed as a parameter don't get checked.
		if (array != null) this.array = array;
		else this.array = new Array();
		this.type = type;
	}
	
	/**
	 * @see Array
	 */
	public function concat():TypedArray {
		var l:Number = arguments.length;
		for (var i:Number = 0; i < l; i++) {
			validate(arguments[i]);
		}
		var result:TypedArray;
		if (l == 0) {
			// TODO: Replace with .clone when ready
			result = new TypedArray(this.type, this.array.concat());
		} else {
			result = new TypedArray(this.type, this.array.concat(arguments));
		}
		return result;
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
		validate(value);
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
		return this.array.sort.apply(this.array, arguments);
	}
	
	/**
	 * @see Array
	 */
	public function sortOn():Object {
		return this.array.sortOn.apply(this.array, arguments);
	}
	
	/**
	 * @see Array
	 */
	public function splice(index:Number, count:Number):Void {
		this.array.splice.apply(this.array, arguments);
	}
	
	/**
	 * @see Array
	 */
	public function unshift(value:Object):Number {
		validate(value);
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
	 * Checks if the instance variable type does not match the type of the object.
	 * @param object
	 * @return true if the types do not match otherwise false
	 */

	public function validate(object:Object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new Error();
		}
	}
}