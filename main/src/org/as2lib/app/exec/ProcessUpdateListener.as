import org.as2lib.app.exec.Process;
/**
 * @author HeideggerMartin
 */
interface org.as2lib.app.exec.ProcessUpdateListener {
	/**
	 * Method to be executed if a process property changes.
	 * 
	 * @param process {@link Process} that changed some properties
	 */
	public function onUpdateProcess(process:Process):Void;
}