/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.env.event.EventListener;
import org.as2lib.app.exec.Process;

/**
 * {@code ProcessListener} is a defintion for the Observable fields available
 * within a process {@link Process}.
 * 
 * <p>To observe a process you can implement this interface and add your
 * implementation with {@link Process#addListener} to a observe a certain
 * process.
 * 
 * @author Martin Heidegger
 * @version 1.0
 * @see Process
 */
interface org.as2lib.app.exec.ProcessListener extends EventListener {
	
	/**
	 * Method to be executed if a process starts execution.
	 * 
	 * @param process {@link Process} that started execution
	 */
	public function onStartProcess(process:Process):Void;
	
	/**
	 * Method to be executed if a process pauses.
	 * 
	 * @param process {@link Process} that paused execution
	 */
	public function onPauseProcess(process:Process):Void;
	
	/**
	 * Method to be executed if a process awakes from pause.
	 * 
	 * @param process {@link Process} that resumes from pause
	 */
	public function onResumeProcess(process:Process):Void;
	
	/**
	 * Method to be executed if a process property changes.
	 * 
	 * @param process {@link Process} that changed some properties
	 */
	public function onUpdateProcess(process:Process):Void;
	
	/**
	 * Method to be executed if a process finishes its execution.
	 * 
	 * @param process {@link Process} that finished with execution
	 */
    public function onFinishProcess(process:Process):Void;
    
    /**
     * Method to be executed if a error occured during the execution of the {@code Process}
     * 
     * @param process {@link Process} where a error occured
     * @param error error that occured during execution
     * @return {@code true} if the process error should not be looped through all listeners
     */
    public function onProcessError(process:Process, error):Boolean;
}