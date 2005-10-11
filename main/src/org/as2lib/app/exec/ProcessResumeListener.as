import org.as2lib.app.exec.Process;
/**
 * @author HeideggerMartin
 */
interface org.as2lib.app.exec.ProcessResumeListener {
	/**
	 * Method to be executed if a process awakes from pause.
	 * 
	 * @param process {@link Process} that resumes from pause
	 */
	public function onResumeProcess(process:Process):Void;
}