import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.array.duplicating.ArraySliceTest implements TestCase {
	public var a:Array;
	
	/**
	 * Constructs a new ArraySliceTest instance.
	 */
	public function ArraySliceTest(Void) {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * Uses Array.slice() to make a duplicate.
	 */
	public function run(Void):Void {
		a.slice();
	}
}