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
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalStateException;

/**
 * Simple Stopwatch for stopping the time.
 * To use the Stopwatch instanciate this class with:
 * 
 * <CODE>
 * import org.as2lib.util.StopWatch;
 * var stopWatch:StopWatch = new StopWatch();
 * </CODE>
 * 
 * This will create a still standing Stopwatch.
 * You can start and stop the Stopwatch to record time.
 * 
 * <CODE>
 * stopWatch.start();
 * // Do something
 * stopWatch.stop();
 * </CODE>
 * 
 * The recored time is available in milliseconds
 * and seconds.
 * 
 * <CODE>
 * trace(stopWatch.getTimeInMilliSeconds()+"ms");
 * trace(stopWatch.getTimeInSeconds()+"ms");
 * </CODE>
 * 
 * @author Martin Heidegger
 */
class org.as2lib.util.StopWatch {
	/** Starttime of the last start */
	private var started:Boolean = false;
	
	/** Holder for all start-time-keys */
	private var startTimeKeys:Array;
	
	/** Holder for all stop-time-keys */
	private var stopTimeKeys:Array;
	
	/** Total recored run time. */
	private var runTime:Number = 0;
	
	/** Constructs a StopWatch */
	public function StopWatch(Void) {
		reset();
	}
	
	/**
	 * Starts the time recording process.
	 * 
	 * @throws IllegalStateException if the Stopwatch is already started.
	 */
	public function start(Void):Void {
		if(isStarted()) {
			throw new IllegalStateException("Stopwatch is already started.", this, arguments);
		}
		started = true;
		startTimeKeys.push(getTimer());
	}
	
	/**
	 * Stops the time recording process If a process is started.
	 * 
	 * @throws IllegalStateException if the Stopwatch isn't already started.
	 */
	public function stop(Void):Void {
		if(!isStarted()) {
			throw new IllegalStateException("Stopwatch isn't started yet.", this, arguments);
		}
		var stopTime:Number = getTimer();
		stopTimeKeys[startTimeKeys.length-1] = stopTime;
		started = false;
	}
	
	/**
	 * Returns true if the Stopwatch was started but
	 * not stopped.
	 * 
	 * @return true if the Stopwatch was started.
	 */
	public function isStarted(Void):Boolean {
		return started;
	}
	
	/**
	 * Resets the stopwatch total running time.
	 */
	public function reset(Void):Void {
		startTimeKeys = new Array();
		stopTimeKeys = new Array();
		started = false;
	}
	
	/**
	 * Calculates and returns the running time in milliseconds.
	 * The StopWatch will not be stopped by calling this method.
	 * If the StopWatch is still running it takes the actualTime
	 * as stoptime for this result.
	 * 
	 * @return Running time in milliseconds.
	 * @see #getTimeInSeconds
	 */
	public function getTimeInMilliSeconds(Void):Number {
		if(isStarted()) {
			stopTimeKeys[startTimeKeys.length-1] = getTimer();
		}
		var result:Number = 0;
		for(var i:Number=0; i<startTimeKeys.length; i++) {
			result += (stopTimeKeys[i]-startTimeKeys[i]);
		}
		return result;		
	}
	
	/**
	 * Calculates and returns the running time in seconds.
	 * The StopWatch will not be stopped by calling this method.
	 * If the StopWatch is still running it takes the actualTime
	 * as stoptime for this result.
	 * 
	 * @return Running time in seconds.
	 * @see #getTimeInMilliSeconds.
	 */
	public function getTimeInSeconds(Void):Number {
		return getTimeInMilliSeconds()/1000;
	}
	
	/**
	 * Generates as String with all Start- and StopTimes in milliseconds.
	 * Overwritten supermethod. This method does not affect any other class
	 * state.
	 * 
	 * @return Detailed info about this Stopwatch.
	 */
	public function toString(Void):String {
		var result:String;
		result = "\n------- [STOPWATCH] -------";
		for(var i:Number=0; i<startTimeKeys.length; i++) {
			result += "\n started["+startTimeKeys[i]+"ms] stopped["+stopTimeKeys[i]+"ms]";
		}
		if(i==0) {
			result += "\n never started.";
		} else {
			result += "\n\n total runnning time: "+getTimeInMilliSeconds()+"ms";
		}
		result += "\n---------------------------\n";
		return result;
	}
}