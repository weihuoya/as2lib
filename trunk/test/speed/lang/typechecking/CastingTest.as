import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.typechecking.CastingTest implements TestCase {
	private var o:Object;
	
	/**
	 * Constructs a new CastingTest instance.
	 */
	public function CastingTest(Void) {
		o = new Object();
	}
	
	/**
	 * Uses a for loop to make a duplicate.
	 */
	public function run(Void):Void {
		(Object(o) != null);
	}
}