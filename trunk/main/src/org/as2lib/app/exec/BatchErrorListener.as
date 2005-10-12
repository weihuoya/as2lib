import org.as2lib.app.exec.Batch;
/**
 * @author HeideggerMartin
 */
interface org.as2lib.app.exec.BatchErrorListener {
	public function onBatchError(batch:Batch, error):Void;
}