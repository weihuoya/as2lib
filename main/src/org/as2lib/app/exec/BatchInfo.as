import org.as2lib.app.exec.ProcessInfo;
import org.as2lib.app.exec.Batch;

class org.as2lib.app.exec.BatchInfo extends ProcessInfo {
	
	private var batch:Batch;
	
	public function BatchInfo(name:String, batch:Batch) {
		super(name, batch);
		this.batch = batch;
	}
	
	public function getBatch(Void):Batch {
		return batch;
	}
}