import org.as2lib.app.exec.TBatch;
import org.as2lib.app.exec.TProcess;
import org.as2lib.app.exec.Call;
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ExecutableProcess;
import org.as2lib.app.exec.BatchProcess;

class org.as2lib.app.exec.TBatchProcess extends TBatch {
	
	public function createBatch(Void):Batch {
		var batchEntry:Process = new ExecutableProcess(new Call(this, callTest), ["a", "b", "c"]);
		var batch:Batch = new BatchProcess();
		batch.addProcess(batchEntry);
		batch.addProcess(batchEntry);
		return batch;
	}
	
	public function callTest(paramA:String, paramB:String, paramC:String):Void {
		assertEquals("There has to get exactly 3 parameters", arguments.length, 3);
		assertEquals("Param A should be 'a'", paramA, "a");
		assertEquals("Param B should be 'b'", paramB, "b");
		assertEquals("Param C should be 'c'", paramC, "c");
	}
}