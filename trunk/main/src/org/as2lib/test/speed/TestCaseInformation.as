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

import org.as2lib.test.speed.TestCase;
import org.as2lib.env.reflect.ClassInfo;

/**
 * Wrapper arround a Testcase that evaluates all informations.
 * This class wrapps additional Informations around a TestCase.
 * It saves the time of the executing and provides various methods
 * to get informations.
 * 
 * @autor Martin Heidegger
 * @version 1.0
 * @see org.as2lib.test.speed.Test
 * @see org.as2lib.test.speed.TestCase
 */
class org.as2lib.test.speed.TestCaseInformation {
	
	/** Internal testcaseholder */
	private var testCase:TestCase;
	/** Total time executed */
	private var totalTime:Number;
	/** Times that run was executed */
	private var runs:Number;
	
	/**
	 * Constructs a TestCaseInformation.
	 *
	 * @param Testcase that should get wrapped
	 */
	function TestCaseInformation(testCase:TestCase) {
		this.testCase = testCase;
		this.totalTime = 0;
		this.runs = 0;
	}
	
	/**
	 * Runs the testcase and saves the executing time.
	 */
	public function run(Void):Void {
		var beforeRun:Number = getTimer();
		this.testCase.run();
		var afterRun:Number = getTimer();
		this.runs++;
		this.totalTime += afterRun-beforeRun;
	}
	
	/**
	 * @return Total execution time of all runs in ms.
	 */
	public function getTotalTime(Void):Number {
		return this.totalTime;
	}
	
	/** 
	 * @return Times that this Testcase was run.
	 */
	public function getRuns(Void):Number {
		return this.runs;
	}
	
	/**
	 * @return Average executing time in ms.
	 */
	public function getAverageTime(Void):Number {
		return this.getTotalTime()/this.getRuns();
	}
	
	/**
	 * @return Maximum calls that are possible within a second.
	 */
	public function getMaxCallsPerSecond(Void):Number {
		return(Math.floor(1000/this.getAverageTime()));
	}
	
	/**
	 * @return Name of the wrapped object.
	 */
	public function getName(Void):String {
		return ClassInfo.forInstance(this.testCase).getName();
	}
	
}