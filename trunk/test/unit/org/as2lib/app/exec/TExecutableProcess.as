import org.as2lib.app.exec.TProcess;
import org.as2lib.app.exec.Call;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ExecutableProcess;

class org.as2lib.app.exec.TExecutableProcess extends TProcess {
	
	public function createProcess(Void):Process {
		return new ExecutableProcess(new Call(this, callTest), ["a", "b", "c"]);
	}
	
	public function callTest(paramA:String, paramB:String, paramC:String):Void {
		assertEquals("There has to get exactly 3 parameters", arguments.length, 3);
		assertEquals("Param A should be 'a'", paramA, "a");
		assertEquals("Param B should be 'b'", paramB, "b");
		assertEquals("Param C should be 'c'", paramC, "c");
	}
}