import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.number.decrementing.PostDecrementOperatorTest implements TestCase {
	private var n:Number;
	
	public function PostDecrementOperatorTest(Void) {
		n = 0;
	}

	public function run(Void):Void {
		n--;
	}
}