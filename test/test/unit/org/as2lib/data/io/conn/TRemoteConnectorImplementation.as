import org.as2lib.test.unit.Test;
import test.org.as2lib.data.io.conn.TImplementation;
import test.org.as2lib.data.io.conn.ExampleListener;
import org.as2lib.data.io.conn.remoting.RemotingConnector;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.data.io.conn.remoting.RemotingRequest;
import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.out.Out;

class test.org.as2lib.data.io.conn.TRemoteConnectorImplementation extends Test{
	
   private var connector:RemotingConnector;
   private var myEB:EventBroadcaster;
   private var myOut:Out;
   
   public function TRemoteConnectorImplementation() {
     connector = new RemotingConnector();
	 myOut = new Out();
   }
	
	private function connectionTest(con:RemotingConnector){
		myOut.info("----------------------------------------");
		myOut.info("---- Test of Identifier ----");
		var gatewayUrl:String = "http://192.168.0.2/flashservices/gateway";//"http://127.0.0.1:8500/flashservices/gateway"
		con.setIdentifier(gatewayUrl);
		
		Test.assertEqualsWithoutMessage(gatewayUrl,gatewayUrl);
		Test.assertEqualsWithoutMessage(gatewayUrl,"blabla");
		Test.assertEqualsWithoutMessage(gatewayUrl,con.getIdentifier());
		
		myOut.info("----------------------------------------");
		myOut.info("---- Test of Listener ----");
		var remListener:ExampleListener = new ExampleListener();
		con.addListener(new ExampleListener());
		con.addListener(remListener);
		con.addListener(new ExampleListener());
		
		con.removeListener(remListener);
		
		myOut.info("----------------------------------------");
		myOut.info("---- Test of onError ----");
		con.onStatus({description:"unconvertable Object passed"});
		
		myOut.info("----------------------------------------");
		myOut.info("---- Test of onResponse ----");
		con.onResult("Yeah you´ve got a Result of your Connector!");
		
		myOut.info("----------------------------------------");
		myOut.info("---- Test of real connection ----");
		con.initConnection();
		con.handleRequest(new RemotingRequest("com.oreilly.frdg.HelloWorld.sayHello"));
		
	}
   
   public function testConnection() {
      connectionTest(connector);
   }
}