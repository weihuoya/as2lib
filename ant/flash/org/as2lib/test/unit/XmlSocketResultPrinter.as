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

import asunit.errors.AssertionFailedError;
import asunit.framework.ITestListener;
import asunit.framework.Test;
import asunit.framework.TestFailure;
import asunit.framework.TestResult;
import asunit.runner.BaseTestRunner;
import asunit.runner.IResultPrinter;

/**
 * {@code XmlSocketResultPrinter} writes-out received test execution information with
 * the xml socket.
 *
 * <p>This result printer is intended to be used with the Unit Test Task.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.unit.XmlSocketResultPrinter extends MovieClip implements
		IResultPrinter, ITestListener {

	private static var linkageId:String = "__Packages.org.as2lib.test.unit.XmlSocketResultPrinter";
	private static var classRef:Function = XmlSocketResultPrinter;
	private static var serializable:Boolean = Object.registerClass(linkageId, classRef);

	private var socket:XMLSocket;

	/**
	 * Constructs a new {@code XmlSocketResultPrinter} instance.
	 *
	 * <p>If {@code host} is not specified, {@code "localhost"} is used. If
	 * {@code port} is not specified, {@code 3212} is used.
	 *
	 * @param host the host of the connection to open
	 * @param port the port of the connection to open
	 */
	public function XmlSocketResultPrinter(host:String, port:Number) {
		if (host == null) {
			host = "localhost";
		}
		if (port == null) {
			port = 3212;
		}
		socket = new XMLSocket();
		socket.connect(host, port);
	}

	public function trace():Void {
		socket.send("<message>" + arguments.toString() + "</message>");
	}

	public function startTest(test:Test):Void {
	}

	public function addError(test:Test, e:Error):Void {
	}

	public function addFailure(test:Test, e:AssertionFailedError):Void {
	}

	public function endTest(test:Test):Void {
	}

	public function printResult(result:TestResult, runTime:Number):Void {
		printHeader(runTime);
	    printErrors(result);
	    if (result.errorCount() > 0 && result.failureCount() > 0) {
	    	socket.send("<message>-</message>");
	    }
	    printFailures(result);
	    printFooter(result);
	}

	private function printHeader(runTime:Number):Void {
		socket.send("<start>Time: " + elapsedTimeAsString(runTime) + "</start>");
	}

	private function elapsedTimeAsString(runTime:Number):String {
		return (runTime/1000).toString() + " sec";
	}

	private function printErrors(result:TestResult):Void {
		printDefects(result.errors(), result.errorCount(), "error");
	}

	private function printFailures(result:TestResult):Void {
		printDefects(result.failures(), result.failureCount(), "failure");
	}

	private function printDefects(defects:Array, count:Number, type:String):Void {
		if (count == 0) {
			return;
		}
		if (count == 1) {
			socket.send("<message>There was " + count + " " + type + ":</message>");
		}
		else {
			socket.send("<message>There were " + count + " " + type + "s:</message>");
		}
		for (var i:Number = 0; i < defects.length; i++) {
			printDefect(defects[i], i, type);
		}
	}

	private function printDefect(defect:TestFailure, index:Number, type:String):Void {
		var message:String = "<" + type + ">";
		message += "(" + index + ") " + defect.failedTest() + " ";
		message += BaseTestRunner.getFilteredTrace(defect.thrownException().toString());
		message += "</" + type + ">";
		socket.send(message);
	}

	private function printFooter(result:TestResult):Void {
		socket.send("<finish hasErrors='" + result.wasSuccessful() +
				"'>Tests run: " + result.runCount() +
				", Failures: " + result.failureCount() +
				", Errors: " + result.errorCount() +
				"</finish>");
	}

}