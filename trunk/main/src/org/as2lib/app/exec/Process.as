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
 * with {@link #addListener} or {@link #addAllListeners}.
 * 
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.app.exec.Process extends BasicInterface {
	
	/**
	 * Starts the execution of the process.
	 * 
	 * <p>
	 * 
	 * @return Result for the start (implementation specific);
	 */
    public function start();
    
	/**
	 * Adds a {@link ProcessListener} as Observer to the process.
	 * 
	 * @param listener Listener to be added. 
	 */
    public function addProcessListener(listener:ProcessListener):Void;
	
	
	public function addAllProcessListeners(list:Array):Void;
    
    /**
     * Removes a {@link ProcessListener} as Observer from the process.
     */
	public function removeProcessListener(listener:ProcessListener):Void;
	
	/**
	 * Removes all added Observers.
	 */
	public function removeAllProcessListeners(Void):Void;
	
	/**
	 * Getter for all added Observers.
	 * 
	 * @return 
	 */
	public function getAllProcessListeners(Void):Array;
	
    public function hasStarted(Void):Boolean;
    
    public function hasFinished(Void):Boolean;
    
    public function isPaused(Void):Boolean;
    
    /**
     * 
     */
    public function isRunning(Void):Boolean;
    
    /**
     * Getter for the currently executed percentage of the process.
     * 
     * @return Percentage of execution. Null if percentage was not evaluateable.
     */
    public function getPercentage(Void):Number;
}