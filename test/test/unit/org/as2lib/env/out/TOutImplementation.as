import org.as2lib.test.unit.TestCase ;
import org.as2lib.env.out.Out;
import org.as2lib.env.except.Exception;
import org.as2lib.env.except.FatalException;
import test.unit.org.as2lib.env.out.handler.UIAlertHandler;

class test.unit.org.as2lib.env.out.TOutImplementation extends TestCase {
	
	private var aOut:Out;
	
	public function TOutImplementation(Void){}
	
	public function setUp(Void):Void {
		aOut = new Out();
	}
	
	private function testLevel(Void):Void{
		
		trace("----------------------------------------");
		trace("---- Out.ALL ----");
		
		aOut.log("log me Please!");
		aOut.debug("debug me Please!");
		aOut.info("inform me Please!");
		aOut.warning("warn me Please!");
		aOut.error(new Exception("Output Error", this));
		aOut.fatal(new FatalException("Fatal Output Error", this));
		
		trace("----------------------------------------");
		trace("---- Out.DEBUG ----");
		
		aOut.setLevel(Out.DEBUG);
		
		aOut.log("log me Please!");
		aOut.debug("debug me Please!");
		aOut.info("inform me Please!");
		aOut.warning("warn me Please!");
		aOut.error(new Exception("Output Error", this));
		aOut.fatal(new FatalException("Fatal Output Error", this));
		
		trace("----------------------------------------");
		trace("---- Out.INFO ----");
		
		aOut.setLevel(Out.INFO);
		
		aOut.log("log me Please!");
		aOut.debug("debug me Please!");
		aOut.info("inform me Please!");
		aOut.warning("warn me Please!");
		aOut.error(new Exception("Output Error", this));
		aOut.fatal(new FatalException("Fatal Output Error", this));
		
		trace("----------------------------------------");
		trace("---- Out.WARNING ----");
		
		aOut.setLevel(Out.WARNING);
		
		aOut.log("log me Please!");
		aOut.debug("debug me Please!");
		aOut.info("inform me Please!");
		aOut.warning("warn me Please!");
		aOut.error(new Exception("Output Error", this));
		aOut.fatal(new FatalException("Fatal Output Error", this));
		
		trace("----------------------------------------");
		trace("---- Out.ERROR ----");
		
		aOut.setLevel(Out.ERROR);
		
		aOut.log("log me Please!");
		aOut.debug("debug me Please!");
		aOut.info("inform me Please!");
		aOut.warning("warn me Please!");
		aOut.error(new Exception("Output Error", this));
		aOut.fatal(new FatalException("Fatal Output Error", this));
		
		trace("----------------------------------------");
		trace("---- Out.FATAL ----");
		
		aOut.setLevel(Out.FATAL);
		
		aOut.log("log me Please!");
		aOut.debug("debug me Please!");
		aOut.info("inform me Please!");
		aOut.warning("warn me Please!");
		aOut.error(new Exception("Output Error", this));
		aOut.fatal(new FatalException("Fatal Output Error", this));
		
		trace("----------------------------------------");
		trace("---- Out.NONE ----");
		
		aOut.setLevel(Out.NONE);
		
		aOut.log("log me Please!");
		aOut.debug("debug me Please!");
		aOut.info("inform me Please!");
		aOut.warning("warn me Please!");
		aOut.error(new Exception("Output Error", this));
		aOut.fatal(new FatalException("Fatal Output Error", this));
		
		aOut.setLevel(Out.ALL);
	}
	
	private function testOutHandler(Void):Void {
		trace("----------------------------------------");
		trace("---- UIAlertHandler ----");
		
		aOut.addHandler(new UIAlertHandler());
		aOut.log("log me Please!");
		aOut.error(new Exception("Output Error", this));
	}
}