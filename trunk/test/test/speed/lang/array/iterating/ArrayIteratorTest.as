import org.as2lib.test.speed.TestCase;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.array.ArrayIterator;

/**
 * Tests the performance of the ArrayIterator.
 *
 * @author Simon Wacker
 */
class test.speed.lang.array.iterating.ArrayIteratorTest implements TestCase {
	private var a:Array;
	
	/**
	 * Constructs a new ArrayIteratorTest instance.
	 */
	public function ArrayIteratorTest(Void) {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * Iterates through the array. That means 2000 iterations
	 * are made.
	 */
	public function run(Void):Void {
		var i:Iterator = new ArrayIterator(a);
		while (i.hasNext()) {
			i.next();
		}
	}
}