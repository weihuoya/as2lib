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

/**
 * Interface for an possible Testcase as performance check.
 * Use this Interface if you want to create a SpeedTestCase.
 * It contains the simples form of creating an Testcase.
 *
 * @autor Martin Heidegger
 * @version 1.0
 */ 
interface org.as2lib.test.speed.TestCase {
	/**
	 * Method that is called to check. Notice each Test-
	 * case should do the same things, else you won't have
	 * correct testresults.
	 */
	public function run(Void):Void;
}