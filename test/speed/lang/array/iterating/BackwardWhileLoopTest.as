import org.as2lib.test.speed.TestCase;

/**
 * Tests the performance of a backwards iterating while loop.
 *
 * @author Simon Wacker
 */
class lang.array.iterating.BackwardWhileLoopTest implements TestCase {
	private var a:Array;
	
	/**
	 * Constructs a new BackwardWhileLoopTest instance.
	 */
	public function BackwardWhileLoopTest(Void) {
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
		var i:Number = a.length;
		while (--i-(-1)) {
		}
	}
}