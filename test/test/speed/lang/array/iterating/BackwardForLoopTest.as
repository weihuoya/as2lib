import org.as2lib.test.speed.TestCase;

/**
 * Tests the performance of a backward iterating for loop.
 *
 * @author Simon Wacker
 */
class test.speed.lang.array.iterating.BackwardForLoopTest implements TestCase {
	private var a:Array;
	
	/**
	 * Constructs a new BackwardForLoopTest instance.
	 */
	public function BackwardForLoopTest(Void) {
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
		for (var i:Number = a.length; i > 0; --i) {
		}
	}
}