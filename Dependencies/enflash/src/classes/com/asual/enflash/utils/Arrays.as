/**
 * Arrays class provides additional functionality for array handling.
 */
class com.asual.enflash.utils.Arrays {

	/**
	 * Removes a given member from an array.
	 * 
	 * @param array The array from which a member will be removed
	 * @param obj The array's member that will be removed
	 * @return The removed member
	 */	
	public static function remove(array:Array, obj:Object) {
		var i:Number = array.length;
		while(i--) {
			if (array[i] == obj) {
				return array.splice(i,1)[0];	
			}
		}
	}

	/**
	 * Removes a member at a specified index from an array.
	 * 
	 * @param array The array from which a member will be removed
	 * @param index The index of the member that will be removed
	 * @return The removed member
	 */	
	public static function removeAt(array:Array, index:Number) {
		if (index == 0){
			return array.shift();
		} else if (index == (array.length - 1)){
			return array.pop();
		} else if(index > 0 && index < (array.length - 1)){
			return array.splice(index, 1)[0];
		} 
	}

	/**
	 * Adds an element to an array at a specified index.
	 * 
	 * @param array The array to which the element will be added
	 * @param index The index where the new element will be placed
	 * @param obj The element that will be added
	 */
	public static function pushAt(array:Array, index:Number, obj:Object):Void {
		if (index > array.length) {
			array.push(obj)
		} else if (index > -1) {
			array.splice(index, 0, obj);
		}
	}

	/**
	 * Replaces a member of an array with a new element.
	 * 
	 * @param array The array in which a member will be replaced
	 * @param obj The member that will be replaced in the array
	 * @param newobj The new element that will replace the provided member
	 */
	public static function replace(array:Array, obj:Object, newobj:Object):Void {
		var i:Number = array.length;
		while(i--) {
			if (array[i] == obj) {
				array[i] = newobj;
				break;
			}
		}
	}

	/**
	 * Swaps two members of an array.
	 * 
	 * @param array The array in which a member will be replaced
	 * @param obj1 
	 * @param obj2 
	 */
	public static function swap(array:Array, obj1:Object, obj2:Object):Void {

		var i1:Number = Arrays.getIndex(array, obj1);
		var i2:Number = Arrays.getIndex(array, obj2);
		if (i1 != undefined && i2 != undefined) {
			array[i1] = obj2;
			array[i2] = obj1;
		}		
	}

	/**
	 * Checks for an existence of a given object inside an array.
	 * 
	 * @param array The array that will be examined
	 * @param obj The object that may has exist in the array
	 * @return True if the array contains the object or false if it doesn't 
	 */
	public static function contains(array:Array, obj:Object):Boolean {
		var i:Number = array.length;
		while(i--) {
			if (array[i] == obj) return true;
		}
		return false;
	}

	public static function duplicate(array:Array) {
		var newArray:Array = new Array();
		var i:Number = array.length;
		while(i--) {
			newArray[i] = array[i];
		}
		return newArray;
	}

	/**
	 * Provides the index number of a member in an array.
	 * 
	 * @param array The array that contains the member
	 * @param obj A member of the array
	 * @return The place index of the provided member 
	 */
	public static function getIndex(array:Array, obj:Object):Number {
		var i:Number = array.length;
		while(i--) {
			if (array[i] == obj) return i;
		}
		return -1;
	}

	/**
	 * Sets a new index number for an array member.
	 * 
	 * @param array The array that contains the member
	 * @param index The new index of the member
	 * @param obj The array member that is going to be re-indexed
	 */
	public static function setIndex(array:Array, index:Number, obj:Object):Void {
		Arrays.pushAt(array, index, Arrays.remove(array, obj));
	}

	/**
	 * Provides access to an array's member based on a property value.
	 * 
	 * @param array The array that contains the member
	 * @param property The property that the member has
	 * @param value The value of the property
	 * @return The member with such property value 
	 */
	public static function getByProperty(array:Array, property:String, value:Object) {
		var i:Number = array.length;
		while(i--) {
			if (array[i][property] != undefined &&  array[i][property] == value) {
				return array[i];
			}
		}
	}	

}