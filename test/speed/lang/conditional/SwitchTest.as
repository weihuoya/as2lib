import org.as2lib.test.speed.TestCase;

/**
 * Tests the performance of switch conditional
 *
 * @author Christoph Atteneder
 */
class lang.conditional.SwitchTest implements TestCase {
	private var a:Array;
	
	/**
	 * Constructs a new IfTest instance.
	 */
	public function SwitchTest(Void) {
		a = new Array();
		while(a.length < 2000) {
			a.push(Math.round(Math.random()*2));
		}
	}
	
	/**
	 * Iterates through the array. That means 2000 iterations
	 * are made.
	 */
	public function run(Void):Void {
		var l:Number = a.length;
		var i:Number = 0;
		while (i < l) {
			
			switch(a[i]){
				case 0 :
					break;
				case 1 :
					break;
				case 2 :
					break;
				default :
			}
			
			i++;
		}
	}
}