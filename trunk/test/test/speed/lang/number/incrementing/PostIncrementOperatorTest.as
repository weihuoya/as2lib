import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class test.speed.lang.number.incrementing.PostIncrementOperatorTest implements TestCase {
	private var n:Number;
	
	public function PostIncrementOperatorTest(Void) {
		n = 0;
	}

	public function run(Void):Void {
		n++;
	}
}