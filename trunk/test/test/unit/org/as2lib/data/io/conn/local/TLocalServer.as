import org.as2lib.test.unit.TestCase;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.io.conn.ConnectorRequest;
import test.org.as2lib.data.io.conn.ExampleListener;

class test.org.as2lib.data.io.conn.local.TLocalServer extends TestCase {
	
	private var server:LocalServer;
	
	public function TLocalServer(Void) {
	}
   
	public function serverTest(Void):Void{
	   	server = new LocalServer();
		
		//restrict domain access
		server.setHost("localhost");
		server.setPath("www.as2lib.org");

		server.setMethod("draw");
		server.setParams(10,25);
		
		assertEquals(server.getHost(),"localhost");
		assertEquals(server.getPath(),"www.as2lib.org");
		assertEquals(server.getMethod(),"draw");
		
		var aParams:Array = server.getParams();
		assertEquals(aParams[0],10);
		assertEquals(aParams[1],25);
		
		server.handleRequest(new ConnectorRequest("www.as2lib.net","localhost","walk",40,33));
		
		assertEquals(server.getHost(),"www.as2lib.net");
		assertEquals(server.getPath(),"localhost");
		assertEquals(server.getMethod(),"walk");
		
		var aParams:Array = server.getParams();
		assertEquals(aParams[0],40);
		assertEquals(aParams[1],33);
	}
	
	public function listenerTest(Void):Void {
		
		var remListener:ExampleListener = new ExampleListener();
		server.addListener(new ExampleListener());
		server.addListener(remListener);
		server.addListener(new ExampleListener());
		
		server.removeListener(remListener);
		server.handleRequest(new ConnectorRequest("www.as2lib.net","localhost","walk",40,33));
	}
	
	public function testLocalServer(Void):Void {
		serverTest();
		listenerTest();
	}
}