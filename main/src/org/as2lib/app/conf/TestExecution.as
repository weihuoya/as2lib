

import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.LoggerTestListener;
import org.as2lib.test.unit.TestSuiteFactory;

/**
 * Prepared configuration to execute Testcases.
 * <p>Use this class to simplify your configuration for the execution of Testcases.
 * <p>As common for as2lib configuration you can use this configuration within your application
 * execution.
 *
 * @author Martin Heidegger
 */
class org.as2lib.app.conf.TestExecution extends AbstractProcess implements Process {
	
	/**
	 * Start of the TestCase.
	 */
	public function run(Void):Void {
		runTestCases();
	}
	
	/**
	 * Runs all available Testcases.
	 */
	public function runTestCases(Void):Void {
		// Testrunner to work with
		var testRunner:TestRunner = new TestRunner();
			  
		// Redirects the finished testoutput to the default logger
		testRunner.addProcessListener(new LoggerTestListener());
		
		// Execute all Testcases that are available at runtime
		var factory:TestSuiteFactory = new TestSuiteFactory();
		
		startSubProcess(testRunner, [factory.collectAllTestCases()]);
	}
}