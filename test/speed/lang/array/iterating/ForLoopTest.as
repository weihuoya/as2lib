import org.as2lib.test.speed.TestCase;

/**
 * Tests the performance of a forward iterating for loop.
 *
 * @author Simon Wacker
 */
class lang.array.iterating.ForLoopTest implements TestCase {
	private var a:Array;
	
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
	 * Iterates through the array. That means 2000 iterations
	 * are made.
	 */
	public function run(Void):Void {
		var l:Number = a.length;
		for (var i:Number = 0; i < l; i++) {
		}
	}
}