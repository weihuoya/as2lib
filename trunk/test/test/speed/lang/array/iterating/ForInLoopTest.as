import org.as2lib.test.speed.TestCase;

/**
 * Tests the performance of the for..in loop.
 *
 * @author Simon Wacker
 */
class test.speed.lang.array.iterating.ForInLoopTest implements TestCase {
	private var a:Array;
	
	/**
	 * Constructs a new ForInLoopTest instance.
	 */
	public function ForInLoopTest(Void) {
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
		var i:String;
		for (i in a) {
		}
	}
}