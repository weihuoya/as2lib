import org.as2lib.basic.BasicInterface;

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