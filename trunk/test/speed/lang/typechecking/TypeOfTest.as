import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.typechecking.TypeOfTest implements TestCase {
	private var o:Object;
	
	
	/**
	 * Constructs a new TypeOfTest instance.
	 */
	public function TypeOfTest(Void) {
		o = new Object();
	}
	
	/**
	 * Uses typeof to determine the type of the object.
	 */
	public function run(Void):Void {
		(typeof(o) == "object");
	}
}