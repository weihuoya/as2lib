import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class test.speed.lang.number.incrementing.MinusEqualsMinusTest implements TestCase {
	private var n:Number;
	
	public function MinusEqualsMinusTest(Void) {
		n = 0;
	}

	public function run(Void):Void {
		n -= -1;
	}
}