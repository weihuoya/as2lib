import org.as2lib.test.speed.TestCase;
/**
 * Test for a simple for-in loop
 * 
 * @autor Martin Heidegger
 * @version 1.0
 */
class looping.ForInLoopTest implements TestCase {
	
	/** Array Holder */
	private var a:Array;
	
	/** 
	 * Constructs an ForInLoopTest.
	 */
	public function ForInLoopTest () {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * runs 2000 loops.
	 */
	public function run(Void):Void {
		var b:Array = a;
		for(var i:String in b) {b[i]=1}
	}
}