import org.as2lib.test.speed.TestCase;

/**
 * Tests the performance of a forward iterating while loop.
 *
 * @author Simon Wacker
 */
class lang.array.iterating.WhileLoopTest implements TestCase {
	private var a:Array;
	
	/**
	 * Constructs a new WhileLoopTest instance.
	 */
	public function WhileLoopTest(Void) {
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
		var i:Number = 0;
		while (i < l) {
			i++;
		}
	}
}