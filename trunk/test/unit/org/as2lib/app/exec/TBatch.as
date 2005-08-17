import org.as2lib.test.unit.TestCase;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.TProcess;
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.app.exec.BatchListener;
import org.as2lib.app.exec.TProcessListener;
import org.as2lib.test.mock.MockControl;

class org.as2lib.app.exec.TBatch extends TProcess implements ProcessListener {
	
	public function createProcess(Void):Process {
		return createBatch();
	}
	
	public function createBatch(Void):Batch {
		return null;
	}
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	public function testAddProcess(Void):Void {
		var batch:Batch = createBatch();
		var process:DummyProcess = new DummyProcess();
		var batchListener:DummyBatchListener = new DummyBatchListener(batch, this);
		batch.addProcess(process);
		batch.addProcess(process);
		batch.addBatchListener(batchListener);
		batch.start();
		pause();
	}
}