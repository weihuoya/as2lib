import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class test.speed.lang.array.duplicating.ArrayConcatTest implements TestCase {
	public var a:Array;
	
	/**
	 * Constructs a new ArrayConcatTest instance.
	 */
	public function ArrayConcatTest(Void) {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * Uses Array.concat() to make a duplicate.
	 */
	public function run(Void):Void {
		a.concat();
	}
}