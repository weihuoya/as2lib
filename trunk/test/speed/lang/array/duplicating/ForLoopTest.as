import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.array.duplicating.ForLoopTest implements TestCase {
	public var a:Array;
	
	/**
	 * Constructs a new ForLoopTest instance.
	 */
	public function ForLoopTest(Void) {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * Uses a for loop to make a duplicate.
	 */
	public function run(Void):Void {
		var l:Number = a.length;
		var r:Array = new Array();
		for (var i:Number = 0; i < l; i++) {
			r.push(a[i]);
		}
	}
}