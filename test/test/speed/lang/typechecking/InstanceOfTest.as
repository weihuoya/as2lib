import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class test.speed.lang.typechecking.InstanceOfTest implements TestCase {
	private var o:Object;
	
	/**
	 * Constructs a new InstanceOfTest instance.
	 */
	public function InstanceOfTest(Void) {
		o = new Object();
	}
	
	/**
	 * Uses instanceOf to determine the type of an array.
	 */
	public function run(Void):Void {
		(o instanceof Object);
	}
}