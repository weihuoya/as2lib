import org.as2lib.util.ObjectUtil;

/**
 * Acts like a normal Array but assures that only objects from one and the same type are added to the Array.
 */
class org.as2lib.data.TypedArray extends Array {
	private var t:Function;
	
	/**
	 * Constructs a new TypedArray instance.
	 * @param type
	 */
	public function TypedArray(t:Function) {
		this.t = t;
	}
	
	/**
	 * @see Array
	 */
	/*public function concat():TypedArray {
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
	}*/
	
	/**
	 * Checks if the array already contains the object.
	 * @param object
	 * @return True if the array contains the object else false
	 */
	public function contains(/*o:Object*/):Boolean {
		var l:Number = length;
		for (var i:Number = 0; i < l; i++) {
			if (this[i] === arguments[0]) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @see Array
	 */
	public function push(/*v:Object*/):Number {
		validate(arguments[0]);
		return super.push(arguments[0]);
	}
	
	/**
	 * @see Array
	 */
	public function unshift(/*v:Object*/):Number {
		validate(arguments[0]);
		return super.unshift(arguments[0]);
	}
	
	/**
	 * @return the type of the array
	 */
	public function getType(Void):Function {
		return t;
	}
	
	/**
	 * Checks if the instance variable type does not match the type of the object.
	 * @param object
	 * @return true if the types do not match otherwise false
	 */
	private function validate(o:Object):Void {
		if (!ObjectUtil.typesMatch(o, t)) {
			throw new Error("Type Missmatch between " + o + " & " + t);
		}
	}
}