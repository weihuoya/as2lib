import org.as2lib.test.speed.TestCase;

/**
 * Tests the performance of if conditional
 *
 * @author Christoph Atteneder
 */
class test.speed.lang.conditional.IfTest implements TestCase {
	private var a:Array;
	
	/**
	 * Constructs a new IfTest instance.
	 */
	public function IfTest(Void) {
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
			if(a[i]==0){
			}
			else if(a[i]==1){
			}
			else if(a[i]==2){
			}
			i++;
		}
	}
}