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

import org.as2lib.test.unit.TestCase;
import org.as2lib.util.StopWatch;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Validates the most common use cases for the StringUtil.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.util.TStopWatch extends TestCase {
	
	// Internal holder for the stopwatch
	private var stopWatch:StopWatch;
	
	/**
	 * Creates a new Stopwatch with a amount of content.
	 */
	public function setUp(Void):Void {
		stopWatch = new StopWatch();
		stopWatch.start();
		var a:Number;
		var b:Number;
		for(var i=0; i<20000; i++){
			a=1+1;
			b=3+2;
		}
		stopWatch.stop();
	}
	
	/**
	 * Validates that the time in seconds matches the time in milliseconds.
	 */
	public function testTimeCombinition(Void):Void {
		assertEquals("The time in milliseconds has to match the time in seconds/1000", stopWatch.getTimeInMilliSeconds(), stopWatch.getTimeInSeconds()*1000);
	}
	
	/**
	 * Validates getting the time by unproper states.
	 */
	public function testRestart(Void):Void {
		var formerTimeInMilliSeconds:Number = stopWatch.getTimeInMilliSeconds();
		stopWatch.start();
		for(var i=0; i<10000; i++);
		assertTrue("The new time has to be bigger or equals than the former time", formerTimeInMilliSeconds <= stopWatch.getTimeInMilliSeconds());
		assertTrue("The stopwatch has to be still running even if you called for the milliseconds", stopWatch.isStarted());
	}
	
	/**
	 * Validates the isStarted States in different conditions.
	 */
	public function testIsStarted(Void):Void {
		assertFalse("The stopwatch has been stopped but it is defined as started", stopWatch.isStarted());
		stopWatch.start();
		assertTrue("The stopwatch has been started but it is not defined as started", stopWatch.isStarted());
		stopWatch.stop();
		assertFalse("The stopwatch has been stopped again but is still defined as started", stopWatch.isStarted());
	}
}