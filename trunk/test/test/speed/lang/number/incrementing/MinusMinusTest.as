import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class test.speed.lang.number.incrementing.MinusMinusTest implements TestCase {
	private var n:Number;
	
	public function MinusMinusTest(Void) {
		n = 0;
	}

	public function run(Void):Void {
		n = n-(-1);
	}
}