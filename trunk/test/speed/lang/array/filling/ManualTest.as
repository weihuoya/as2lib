import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.array.filling.ManualTest implements TestCase {
	public var a:Array;
	
	/**
	 * Constructs a new ManualTest instance.
	 */
	public function ManualTest(Void) {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * Iterates through the array and sets the value in a duplicate
	 * via duplicate[index] = value.
	 */
	public function run(Void):Void {
		var l:Number = a.length;
		var r:Array = new Array();
		for (var i:Number = 0; i < l; i++) {
			r[i] = a[i];;
		}
	}
}