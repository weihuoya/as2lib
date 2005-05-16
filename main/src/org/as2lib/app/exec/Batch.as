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

import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.BatchListener;

/**
 * {@code Batch} is the definition for a list of processes that will be executed
 * after each other.
 * 
 * <p>{@code Batch} allows with {@link #addProcess} to define a list of processes
 * that will be started after each other. The execution will follow in the order
 * of the arrival.
 * 
 * <p>{@code Batch} is a composite (it implements {@link Process}), so you can
 * even add one {@code Batch} with {@link #addProcess} to another {@code Batch}.
 * 
 * <p>Additionally to {@link #addProcessListener} method of {@link Proces} you
 * can add a {@link BatchListener} with {@link #addBatchListener} that allows to
 * get a more detailed information about the batch execution.
 * 
 * Example:
 * <code>
 *   import org.as2lib.app.exec.Batch;
 *   import org.as2lib.app.exec.BatchProcess;
 *   
 *   var b:Batch = new BatchProcess();
 *   b.addBatchListener(new MyStartUpController());
 *   b.addProcess(new MyStartUpProcess());
 *   b.addProcess(new MyXMLParsingProcess());
 *   b.start();
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 * @see Process
 */
interface org.as2lib.app.exec.Batch extends Process {
	
	/**
	 * Adds a {@link Process} to the list of processes to execute.
	 * Its possible to at the same process more than one times.
	 * 
	 * @param process {@link Process} to be added.
	 * @return Internal identifier of the process.
	 */
	public function addProcess(process:Process):Number;
	
	/**
	 * Removes all instances of a process that were added to the batch.
	 * 
	 * @param process {@link Process} to be removed.
	 */
    public function removeProcess(process:Process):Void;
    
    /**
     * Removes a process with a certain id from the batch.
     * 
     * @param id Identifier for the certain process.
     */
    public function removeProcessById(id:Number):Void ;
    
    /**
     * Getter for the currently execution Process.
     * 
     * @return Currently executing process.
     */
    public function getCurrentProcess(Void):Process;
    
    /**
     * Getter for all added processes.
     * 
     * @return List of all added processes.
     */
    public function getAllAddedProcesses(Void):Array;
    
    /**
     * Adds a {@link BatchListener} as Observer to the {@code Batch}.
     * 
     * @param listener {@link BatchListener} to be added.
     */
    public function addBatchListener(listener:BatchListener):Void;
    
    /**
     * Adds a {@link BatchListener} as Observer to the {@code Batch}.
     * 
     * @param listener {@link BatchListener} to be added.
     */
	public function addAllBatchListeners(list:Array):Void;
	
	/**
	 * Removes a certain {@link BatchListener} as Observer from the {@code Batch}.
	 * 
	 * @param listener {@link BatchListener} to be removed.
	 */
	public function removeBatchListener(listener:BatchListener):Void;
	
	/**
	 * Removes all added batchlisteners that were added with
	 * {@link #addBatchListener} or {@link #addAllBatchListeners}.
	 */
	public function removeAllBatchListeners(Void):Void;
	
	/**
	 * Getter for all added listeners in form of a {@code Array}.
	 * 
	 * @return Added listeners in form of a array.
	 */
	public function getAllBatchListeners(Void):Array;
	
}