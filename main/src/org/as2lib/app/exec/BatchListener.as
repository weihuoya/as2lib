import org.as2lib.app.exec.Batch;

interface org.as2lib.app.exec.BatchListener {
	public function onStartBatch(batch:Batch):Void;
	public function onUpdateBatch(batch:Batch):Void;
    public function onStopBatch(batch:Batch):Void;
    public function onBatchError(batch:Batch, error):Boolean;
}