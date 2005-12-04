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
 * <p>It supports beneath all listeners of {@link Process} seperate events for
 * {@code Batch} processing:
 *   {@link BatchStartListener}, {@link BatchFinishListener},
 *   {@link BatchUpdateListener} and {@link BatchErrorListener}
 * 
 * <p>Example:
 * <code>
 *   import org.as2lib.app.exec.Batch;
 *   import org.as2lib.app.exec.BatchProcess;
 *   
 *   var b:Batch = new BatchProcess();
 *   b.addListener(new MyStartUpController());
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
     * Returns the currently execution {@code Process}
     * 
     * @return currently executing {@code Process}
     */
    public function getCurrentProcess(Void):Process;	
}