import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.number.decrementing.MinusTest implements TestCase {
	private var n:Number;
	
	public function MinusTest(Void) {
		n = 0;
	}

	public function run(Void):Void {
		n = n-1;
	}
}