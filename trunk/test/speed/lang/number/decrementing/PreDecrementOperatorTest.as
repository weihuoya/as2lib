import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.number.decrementing.PreDecrementOperatorTest implements TestCase {
	private var n:Number;
	
	public function PreDecrementOperatorTest(Void) {
		n = 0;
	}
	
	public function run(Void):Void {
		--n;
	}
}