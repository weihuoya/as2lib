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

import org.as2lib.core.BasicInterface;
import org.as2lib.app.exec.ProcessListener;

/**
 * {@code Process} is a definition for all lacy processes like for loading files
 * having serverside responses or algorithms that take a little longer.
 * 
 * <p>Any {@code Process} implementation can be started with {@link #start}. Due
 * to flash ist not possible to allow system processes it is build as Observable
 * that responses if the process was
 * started ({@link ProcessListener#onStartProcess}),
 * finished ({@link ProcessListener#onFinishProcess}),
 * paused ({@link ProcessListener#onPauseProcess}),
 * resumed ({@link ProcessListener#onResumeProcess}) or if the properties
 * changed ({@link ProcessListener#onUpdateProcess}).
 * 
 * <p>To observe {@code Process} you can add one or more listener to the process
 * with {@link #addProcessListener} or {@link #addAllProcessListeners}.
 * 
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.app.exec.Process extends BasicInterface {
	
	/**
	 * Starts the execution of this process.
	 * 
	 * @return result for the start (implementation specific).
	 */
    public function start();
    
	/**
	 * Adds a {@link ProcessListener} as Observer to the process.
	 * 
	 * @param listener {@link ProcessListener} to be added. 
	 */
    public function addProcessListener(listener:ProcessListener):Void;
	
	/**
	 * Adds a {@code list} of {@link ProcessListener}s as Observer to the process.
	 * 
	 * @param list List of listeners to be added.
	 */
	public function addAllProcessListeners(list:Array):Void;
    
    /**
     * Removes a {@link ProcessListener} as Observer from the process.
     * 
     * @param listener {@link ProcessListener} to be added.
     */
	public function removeProcessListener(listener:ProcessListener):Void;
	
	/**
	 * Removes all added Observers.
	 */
	public function removeAllProcessListeners(Void):Void;
	
	/**
	 * Getter for all added Observers.
	 * 
	 * @return List that contains all registered listeners
	 */
	public function getAllProcessListeners(Void):Array;
	
	/**
	 * Flag if the process has been started.
	 * 
	 * @return true if the process has been started and isn't finish yet else false.
	 */
    public function hasStarted(Void):Boolean;
    
    /**
     * Flag if the process has been finished.
     * 
     * @return true if the process has been finished else false
     */
    public function hasFinished(Void):Boolean;
    
    /**
     * Flag if the process has been paused.
     * 
     * @return true if the process has been started and has been paused
     */
    public function isPaused(Void):Boolean;
    
    /**
     * Flag if the process has been paused.
     * 
     * @return true if the process has been started and is not paused
     */
    public function isRunning(Void):Boolean;
    
    /**
     * Getter for the currently executed percentage of the process.
     * 
     * @return Percentage of execution. Null if percentage was not evaluateable.
     */
    public function getPercentage(Void):Number;
    
    /**
     * Possibility to tell the process what parent process started its execution.
     * 
     * @param process {@code Process} that started the current process.
     * @throws org.as2lib.env.except.IllegalArgumentException if the passed-in
     * 		   process has the current process within the parent process list or
     * 		   if the passed-in process is the same process as the current
     * 		   process.
     */
    public function setParentProcess(process:Process):Void;
    
    /**
     * Getter for the parent process that executed the process.
     * 
     * @return Parent process if available, else null.
     */
    public function getParentProcess(Void):Process;
}