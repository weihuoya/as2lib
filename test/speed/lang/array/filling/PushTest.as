import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.array.filling.PushTest implements TestCase {
	public var a:Array;
	
	/**
	 * Constructs a new PushTest instance.
	 */
	public function PushTest(Void) {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * Pushes the values of the array to a duplicate.
	 */
	public function run(Void):Void {
		var l:Number = a.length;
		var r:Array = new Array();
		for (var i:Number = 0; i < l; i++) {
			r.push(a[i]);
		}
	}
}