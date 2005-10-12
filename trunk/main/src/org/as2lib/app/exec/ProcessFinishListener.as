import org.as2lib.app.exec.Process;

/**
 * {@code ProcessFinishListener} is a defintion for a Observer of the completion
 * of a {@link Process}.
 * 
 * <p>To observe the completion of a {@code Process} you can implement this
 * interface and add your implementation with {@link Process#addListener} to
 * observe a certain {@code Process}.
 * 
 * @author Martin Heidegger
 * @version 2.0
 * @see Process
 */
interface org.as2lib.app.exec.ProcessFinishListener {
	
	/**
	 * Method to be executed if a process finishes its execution.
	 * 
	 * @param process {@link Process} that finished with execution
	 */
    public function onProcessFinish(process:Process):Void;
}