import org.as2lib.app.exec.Process;
/**
 * @author HeideggerMartin
 */
interface org.as2lib.app.exec.ProcessFinishListener {
	/**
	 * Method to be executed if a process finishes its execution.
	 * 
	 * @param process {@link Process} that finished with execution
	 */
    public function onFinishProcess(process:Process):Void;
}