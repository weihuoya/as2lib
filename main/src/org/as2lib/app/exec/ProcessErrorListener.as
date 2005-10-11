import org.as2lib.app.exec.Process;
/**
 * @author HeideggerMartin
 */
interface org.as2lib.app.exec.ProcessErrorListener {
    /**
     * Method to be executed if a error occured during the execution of the {@code Process}
     * 
     * @param process {@link Process} where a error occured
     * @param error error that occured during execution
     * @return {@code true} if the process error should not be looped through all listeners
     */
    public function onProcessError(process:Process, error):Boolean;
}