import org.as2lib.test.speed.TestCase;
/**
 * Test for a simple backward loop
 * 
 * @autor Martin Heidegger
 * @version 1.0
 */
class looping.BackwardLoopTest implements TestCase {
	
	/** Array Holder */
	private var a:Array;
	
	/** 
	 * Constructs an BackwardLoopTest.
	 */
	public function BackwardLoopTest () {
		a = new Array();
		while(a.length < 2000) {
			a.push(1);
		}
	}
	
	/**
	 * runs 2000 loops.
	 */
	public function run(Void):Void {
		var len:Number = a.length;
		for(var i:Number = len; i>=0; i--) {a[i]=1}
	}
}