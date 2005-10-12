import org.as2lib.test.unit.TestCase;
import org.as2lib.data.type.Time;
/**
 * @author Martin Heidegger
 */
class org.as2lib.data.type.TTime extends TestCase {
	
	public function testAsRepresentations() {
		var time:Time;
		
		// case 0
		time = new Time(0);
		assertAlmostEquals("t(0) should be 0 days", time.inDays(), 0);
		assertAlmostEquals("t(0) should be 0 hours", time.inHours(), 0);
		assertAlmostEquals("t(0) should be 0 minutes", time.inMinutes(), 0);
		assertAlmostEquals("t(0) should be 0 seconds", time.inSeconds(), 0);
		assertAlmostEquals("t(0) should be 0 milliseconds", time.inMilliSeconds(), 0);
		
		// case 1
		time = new Time(1);
		assertAlmostEquals("t(1) should be 0 days", time.inDays(), 1.15740740740741e-8);
		assertAlmostEquals("t(1) should be 2.77777777777778e-7 hours", time.inHours(), 2.77777777777778e-7);
		assertAlmostEquals("t(1) should be 0.0000166666666666667 minutes", time.inMinutes(), 0.0000166666666666667);
		assertAlmostEquals("t(1) should be 0.001 seconds", time.inSeconds(), 0.001);
		assertAlmostEquals("t(1) should be 1 milliseconds", time.inMilliSeconds(), 1);
		
		// case 3333
		time = new Time(3333);
		assertAlmostEquals("t(3333) should be 0.0000385763888888889 days", time.inDays(), 0.0000385763888888889);
		assertAlmostEquals("t(3333) should be 0.000925833333333333 hours", time.inHours(), 0.000925833333333333);
		assertAlmostEquals("t(3333) should be 0.05555 minutes", time.inMinutes(), 0.05555);
		assertAlmostEquals("t(3333) should be 3.333 seconds", time.inSeconds(), 3.333);
		assertAlmostEquals("t(3333) should be 3333 milliseconds", time.inMilliSeconds(), 3333);
		
		// case 199999
		time = new Time(199999);
		assertAlmostEquals("t(199999) should be 0.00231480324074074 days", time.inDays(), 0.00231480324074074);
		assertAlmostEquals("t(199999) should be 0.05555527777777783 hours", time.inHours(), 0.05555527777777783);
		assertAlmostEquals("t(199999) should be 3.33331666666667 minutes", time.inMinutes(), 3.33331666666667);
		assertAlmostEquals("t(199999) should be 199.999 seconds", time.inSeconds(), 199.999);
		assertAlmostEquals("t(199999) should be 199999 milliseconds", time.inMilliSeconds(), 199999);
		
		// case 11999999
		time = new Time(11999999);
		assertAlmostEquals("t(11999999) should be 0.138888877314815 days", time.inDays(), 0.138888877314815);
		assertAlmostEquals("t(11999999) should be 3.33333305555556 hours", time.inHours(), 3.33333305555556);
		assertAlmostEquals("t(11999999) should be 199.999983333333 minutes", time.inMinutes(), 199.999983333333);
		assertAlmostEquals("t(11999999) should be 11999.999 seconds", time.inSeconds(), 11999.999);
		assertAlmostEquals("t(11999999) should be 11999999 milliseconds", time.inMilliSeconds(), 11999999);
		
		// case 431997840
		time = new Time(431997840);
		assertAlmostEquals("t(431997840) should be 4.999975 days", time.inDays(), 4.999975);
		assertAlmostEquals("t(431997840) should be 119.9994 hours", time.inHours(), 119.9994);
		assertAlmostEquals("t(431997840) should be 7199.964 minutes", time.inMinutes(), 7199.964);
		assertAlmostEquals("t(431997840) should be 431997.840 seconds", time.inSeconds(), 431997.840);
		assertAlmostEquals("t(431997840) should be 431997840 milliseconds", time.inMilliSeconds(), 431997840);
	}
	
	public function testSetFormat() {
		var time:Time;
		
		time = new Time(1, "ms");
		assertAlmostEquals("1ms should be t(1)", time.valueOf(), 1);
		
		time = new Time(3.333, "s");
		assertAlmostEquals("3.333s should be t(3333)", time.valueOf(), 3333);
		
		time = new Time(1.5, "m");
		assertAlmostEquals("1.5m should be t(90000)", time.valueOf(), 90000);
		
		time = new Time(1.5, "h");
		assertAlmostEquals("1.5h should be t(5400000)", time.valueOf(), 5400000);
		
		time = new Time(1.5, "d");
		assertAlmostEquals("1.5d should be t(129600000)", time.valueOf(), 129600000);
		
		time = new Time(3, "fuck");
		assertAlmostEquals("3fuck should be t(3)", time.valueOf(), 3);
	}
	
	public function testNormalGetParts() {
		var time:Time;
		
		time = new Time(1.5, "d");
		assertAlmostEquals("t(1.5d) contains 1.5d", time.getDays(), 1.5);
		assertAlmostEquals("t(1.5d) contains 12h", time.getHours(), 12);
		assertAlmostEquals("t(1.5d) contains 0m", time.getMinutes(), 0);
		assertAlmostEquals("t(1.5d) contains 0s", time.getSeconds(), 0);
		assertAlmostEquals("t(1.5d) contains 0ms", time.getMilliSeconds(), 0);
		
		time = new Time(25.5, "h");
		assertAlmostEquals("t(25.5h) contains 1.0625d", time.getDays(), 1.0625);
		assertAlmostEquals("t(25.5h) contains 1.5h", time.getHours(), 1.5);
		assertAlmostEquals("t(25.5h) contains 30m", time.getMinutes(), 30);
		assertAlmostEquals("t(25.5h) contains 0s", time.getSeconds(), 0);
		assertAlmostEquals("t(25.5h) contains 0ms", time.getMilliSeconds(), 0);
		
		time = new Time(90.5, "m");
		assertAlmostEquals("t(90.5m) contains 0.062...d", time.getDays(), 0.0628472222222222);
		assertAlmostEquals("t(90.5m) contains 1.5...h", time.getHours(), 1.50833333333333);
		assertAlmostEquals("t(90.5m) contains 30.5m", time.getMinutes(), 30.5);
		assertAlmostEquals("t(90.5m) contains 30s", time.getSeconds(), 30);
		assertAlmostEquals("t(90.5m) contains 0ms", time.getMilliSeconds(), 0);
		
		time = new Time(4000, "s");
		assertAlmostEquals("t(4000s) contains 0.04...d", time.getDays(), 0.0462962962962963);
		assertAlmostEquals("t(4000s) contains 1.1°h", time.getHours(), 1.11111111111111);
		assertAlmostEquals("t(4000s) contains 6.6°m", time.getMinutes(), 6.66666666666667);
		assertAlmostEquals("t(4000s) contains 40s", time.getSeconds(), 40);
		assertAlmostEquals("t(4000s) contains 0ms", time.getMilliSeconds(), 0);
	}
	
	public function testGetFloored() {
		var time:Time;
		
		time = new Time(1.5, "d");
		assertAlmostEquals("t(1.5d) contains 1.5d", time.getDays(0), 1);
		assertAlmostEquals("t(1.5d) contains 12h", time.getHours(0), 12);
		assertAlmostEquals("t(1.5d) contains 0m", time.getMinutes(0), 0);
		assertAlmostEquals("t(1.5d) contains 0s", time.getSeconds(0), 0);
		assertAlmostEquals("t(1.5d) contains 0ms", time.getMilliSeconds(0), 0);
		
		time = new Time(25.5, "h");
		assertAlmostEquals("t(25.5h) contains 1d", time.getDays(0), 1);
		assertAlmostEquals("t(25.5h) contains 1h", time.getHours(0), 1);
		assertAlmostEquals("t(25.5h) contains 30m", time.getMinutes(0), 30);
		assertAlmostEquals("t(25.5h) contains 0s", time.getSeconds(0), 0);
		assertAlmostEquals("t(25.5h) contains 0ms", time.getMilliSeconds(0), 0);
		
		time = new Time(90.5, "m");
		assertAlmostEquals("t(90.5m) contains 0d", time.getDays(0), 0);
		assertAlmostEquals("t(90.5m) contains 1h", time.getHours(0), 1);
		assertAlmostEquals("t(90.5m) contains 30m", time.getMinutes(0), 30);
		assertAlmostEquals("t(90.5m) contains 30s", time.getSeconds(0), 30);
		assertAlmostEquals("t(90.5m) contains 0ms", time.getMilliSeconds(0), 0);
		
		time = new Time(4000, "s");
		assertAlmostEquals("t(4000s) contains 0d", time.getDays(0), 0);
		assertAlmostEquals("t(4000s) contains 1h", time.getHours(0), 1);
		assertAlmostEquals("t(4000s) contains 6m", time.getMinutes(0), 6);
		assertAlmostEquals("t(4000s) contains 40s", time.getSeconds(0), 40);
		assertAlmostEquals("t(4000s) contains 0ms", time.getMilliSeconds(0), 0);
	}
	
	public function testSetValue(Void):Void {
		var time:Time = new Time(200);
		assertAlmostEquals("t(100) contains 100", time.setValue(100).valueOf(), 100);
		assertAlmostEquals("t(200) contains 200", time.setValue(200).valueOf(), 200);
	}
}