import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;

class org.as2lib.util.ArrayUtil extends BasicClass {
	private function ArrayUtil(Void) {
	}
	
	public static function copy(array:Array):Array {
		return array.concat();
	}
	
	public static function removeElement(array:Array, element):Void {
		var l:Number = array.length;
		for (var i:Number = 0; i <= l; i++) {
			if (array[i] === element) {
				array.splice(i, 1);
				return;
			}
		}
		throw new IllegalArgumentException("The specified element [" + element + "] is not available in the array [" + array + "] and could therefore not be removed.", 
											eval("th" + "is"),
											arguments);
	}
}