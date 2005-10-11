import org.as2lib.app.exec.Process;
/**
 * @author HeideggerMartin
 */
interface org.as2lib.app.exec.ProcessPauseListener {
	
	/**
	 * Method to be executed if a process pauses.
	 * 
	 * @param process {@link Process} that paused execution
	 */
	public function onProcessPause(process:Process):Void;
}