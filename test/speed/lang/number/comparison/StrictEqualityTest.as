import org.as2lib.test.speed.TestCase;

/**
 * @author Simon Wacker
 */
class lang.number.comparison.StrictEqualityTest implements TestCase {
	
	public function run(Void):Void {
		(0 === -1);
		(0 === 0);
	}
	
}