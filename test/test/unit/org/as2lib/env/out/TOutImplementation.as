import org.as2lib.test.unit.TestCase ;
import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.except.Exception;
import org.as2lib.env.except.FatalException;
import test.unit.org.as2lib.env.out.handler.TOutHandler;
import test.unit.org.as2lib.env.out.handler.UIAlertHandler;

class test.unit.org.as2lib.env.out.TOutImplementation extends TestCase {
	
	private var aOut:Out;
	private var oH:TOutHandler;
	
	public function TOutImplementation(Void){}
	
	public function setUp(Void):Void {
		aOut = new Out();
		oH = new TOutHandler();
		aOut.addHandler(oH);
	}
	
	private function testSetLevel(Void):Void{
		
		aOut.setLevel(Out.ALL);
		aOut.log(1);
 		assertEquals("log not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 1);		
		aOut.debug(2);
 		assertEquals("debug not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 2);
		aOut.info(3);
 		assertEquals("info not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 3);		
		aOut.warning(4);
 		assertEquals("warning not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 4);
		aOut.error(5);
 		assertEquals("error not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 5);
		aOut.fatal(6);
 		assertEquals("fatal not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 6);
		
		oH.write(new OutInfo("x", Out.FATAL));
		
		aOut.setLevel(Out.DEBUG);
		aOut.log(1);
 		assertNotEquals("log called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 1);		
		aOut.debug(2);
 		assertEquals("debug not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 2);
		aOut.info(3);
 		assertEquals("info not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 3);		
		aOut.warning(4);
 		assertEquals("warning not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 4);
		aOut.error(5);
 		assertEquals("error not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 5);
		aOut.fatal(6);
 		assertEquals("fatal not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 6);
		
		oH.write(new OutInfo("x", Out.FATAL));
		
		aOut.setLevel(Out.INFO);
		aOut.log(1);
 		assertNotEquals("log called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 1);		
		aOut.debug(2);
 		assertNotEquals("debug called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 2);
		aOut.info(3);
 		assertEquals("info not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 3);		
		aOut.warning(4);
 		assertEquals("warning not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 4);
		aOut.error(5);
 		assertEquals("error not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 5);
		aOut.fatal(6);
 		assertEquals("fatal not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 6);
		
		oH.write(new OutInfo("x", Out.FATAL));
		
		aOut.setLevel(Out.WARNING);
		aOut.log(1);
 		assertNotEquals("log called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 1);		
		aOut.debug(2);
 		assertNotEquals("debug called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 2);
		aOut.info(3);
 		assertNotEquals("info called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 3);		
		aOut.warning(4);
 		assertEquals("warning not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 4);
		aOut.error(5);
 		assertEquals("error not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 5);
		aOut.fatal(6);
 		assertEquals("fatal not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 6);
		
		oH.write(new OutInfo("x", Out.FATAL)); 
		
		aOut.setLevel(Out.WARNING);
		aOut.log(1);
 		assertNotEquals("log called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 1);		
		aOut.debug(2);
 		assertNotEquals("debug called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 2);
		aOut.info(3);
 		assertNotEquals("info called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 3);		
		aOut.warning(4);
 		assertEquals("warning not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 4);
		aOut.error(5);
 		assertEquals("error not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 5);
		aOut.fatal(6);
 		assertEquals("fatal not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 6);
		
		oH.write(new OutInfo("x", Out.FATAL));
		
		aOut.setLevel(Out.ERROR);
		aOut.log(1);
 		assertNotEquals("log called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 1);		
		aOut.debug(2);
 		assertNotEquals("debug called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 2);
		aOut.info(3);
 		assertNotEquals("info called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 3);		
		aOut.warning(4);
 		assertNotEquals("warning called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 4);
		aOut.error(5);
 		assertEquals("error not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 5);
		aOut.fatal(6);
 		assertEquals("fatal not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 6);
		
		oH.write(new OutInfo("x", Out.FATAL));
		
		aOut.setLevel(Out.FATAL);
		aOut.log(1);
 		assertNotEquals("log called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 1);		
		aOut.debug(2);
 		assertNotEquals("debug called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 2);
		aOut.info(3);
 		assertNotEquals("info called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 3);		
		aOut.warning(4);
 		assertNotEquals("warning called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 4);
		aOut.error(5);
 		assertNotEquals("error called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 5);
		aOut.fatal(6);
 		assertEquals("fatal not called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 6);
		
		oH.write(new OutInfo("x", Out.FATAL));
		
		aOut.setLevel(Out.NONE);
		aOut.log(1);
 		assertNotEquals("log called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 1);		
		aOut.debug(2);
 		assertNotEquals("debug called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 2);
		aOut.info(3);
 		assertNotEquals("info called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 3);		
		aOut.warning(4);
 		assertNotEquals("warning called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 4);
		aOut.error(5);
 		assertNotEquals("error called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 5);
		aOut.fatal(6);
 		assertNotEquals("fatal called. "+ReflectUtil.getClassInfo(aOut.getLevel()).getName()+" activated.",oH.getLastMessage(), 6);
		
	}
	
	public function testStaticHandler(Void):Void {
		Out.addStaticHandler(oH);
		var out:Out = new Out();
		
		out.log("Test single instance.");
		assertEquals("Test for a single instance failed.", oH.getLastMessage(), "Test single instance.");
		
		var out2:Out = new Out();
		
		out.log("Test second instance.");
		assertEquals("Test for a second instance failed.", oH.getLastMessage(), "Test second instance.");
		
		out2.setLevel(Out.NONE);
		out2.log("Test blocked log message.");
		assertNotEquals("Test blocking log message failed.", oH.getLastMessage(), "Test blocked log message.");
		
		out2.info("Test blocked info message.");
		assertNotEquals("Test blocking info message failed.", oH.getLastMessage(), "Test blocked info message.");
		
		out2.warning("Test blocked warning message.");
		assertNotEquals("Test blocking warning message failed.", oH.getLastMessage(), "Test blocked warning message.");
		
		out2.error("Test blocked error message.");
		assertNotEquals("Test blocking error message failed.", oH.getLastMessage(), "Test blocked error message.");
		
		out2.fatal("Test blocked fatal message.");
		assertNotEquals("Test blocking fatal message failed.", oH.getLastMessage(), "Test blocked fatal message.");
		
		out.log("Test not blocked message.");
		assertEquals("Test not blocking message failed.", oH.getLastMessage(), "Test not blocked message.");
	}
	
	public function testOutInfo(Void):Void {
		aOut.log("x");
		assertEquals("Log not correct.", oH.getLastInfo().getLevel(), Out.ALL); 
		aOut.info("x");
		assertEquals("Info not correct.", oH.getLastInfo().getLevel(), Out.INFO); 
		aOut.warning("x");
		assertEquals("Warning not correct.", oH.getLastInfo().getLevel(), Out.WARNING); 
		aOut.error("x");
		assertEquals("Error not correct.", oH.getLastInfo().getLevel(), Out.ERROR); 
		aOut.fatal("x");
		assertEquals("Fatal not correct.", oH.getLastInfo().getLevel(), Out.FATAL); 
	}
	
	private function testMessage(Void):Void {
		aOut.info(" Using Special Chars äöü ");
		assertEquals("Special Chars don't work", oH.getLastMessage(), " Using Special Chars äöü ");
		
		aOut.log(" Log Test ");
		assertEquals("Log Test fails", oH.getLastMessage(), " Log Test ");
		
		aOut.info(" Info Test ");
		assertEquals("Info Test fails", oH.getLastMessage(), " Info Test ");
		
		aOut.warning(" Warning Test ");
		assertEquals("Warning Test fails", oH.getLastMessage(), " Warning Test ");
		
		aOut.error(" Error Test ");
		assertEquals("Error Test fails", oH.getLastMessage(), " Error Test ");
		
		aOut.fatal(" Fatal Test ");
		assertEquals("Fatal Test fails", oH.getLastMessage(), " Fatal Test ");
	}
	
	public function testIsEnabled(Void):Void {
		aOut.setLevel(Out.ALL);
		assertTrue("ALL Level won't work", aOut.isEnabled(Out.ALL));
		
		aOut.setLevel(Out.NONE);
		assertTrue("NONE Level won't work", aOut.isEnabled(Out.NONE));
	}
}