import org.as2lib.test.speed.TestCase;
/**
 * Test for a simple forward loop
 * 
 * @autor Martin Heidegger
 * @version 1.0
 */
class looping.ForwardLoopTest implements TestCase {
	
	/** Array Holder */
	private var a:Array;
	
	/** 
	 * Constructs an ForwardLoopTest.
	 */
	public function ForwardLoopTest () {
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
		for(var i:Number = 0; i<len; i-=-1) {a[i]=1}
	}
}