import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.array.filling.UnshiftTest implements TestCase {
	public var a:Array;
	
	/**
	 * Constructs a new UnshiftTest instance.
	 */
	public function UnshiftTest(Void) {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * Uses Array.unshift() to fill the duplicate.
	 */
	public function run(Void):Void {
		var l:Number = a.length;
		var r:Array = new Array();
		for (var i:Number = 0; i < l; i++) {
			r.unshift(a[i]);
		}
	}
}