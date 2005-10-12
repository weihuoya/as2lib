import org.as2lib.app.exec.Timeout;
import org.as2lib.test.unit.TestCase;
import org.as2lib.app.exec.Call;

class org.as2lib.app.exec.TTimeout extends TestCase {
	
	public function testTimeoutExecution() {
		var t:Timeout = new Timeout(this, call, 20);
		startProcess(t, [1], new Call(this, cB));
	}
	
	public function cB(a) {
	}
	
	public function call(a) {
		assertEquals(a, 1);
		//resume();
	}
}