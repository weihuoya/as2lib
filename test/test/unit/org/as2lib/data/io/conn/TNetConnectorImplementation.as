import org.as2lib.test.unit.Test;
import test.org.as2lib.data.io.conn.TImplementation;
import org.as2lib.data.io.conn.remoting.RemotingConnector;
import org.as2lib.data.io.conn.Connector;
import org.as2lib.env.out.Out;
import test.org.as2lib.data.io.conn.ExampleListener;

class test.org.as2lib.data.io.conn.TNetConnectorImplementation extends Test{
   private var connector:RemotingConnector;
   public function TNetConnectorImplementation() {
     connector = new RemotingConnector();
   }
	
	private function connectionTest(con:Connector){
		
		// getter setter Test
		con.setIdentifier("http://192.168.0.1/flashservices/gateway");
		var myOut:Out = new Out();
		myOut.info("GatewayUrl: "+con.getIdentifier());
		
		// Listener Test
		
		var l1:ExampleListener = new ExampleListener();
		var l2:ExampleListener = new ExampleListener();
		var l3:ExampleListener = new ExampleListener();
		
		con.addListener(l1);
		con.addListener(l2);
		con.addListener(l3);
		
		con.removeListener(l1));
		
		dispatch(event:EventInfo):Void {
		
		// Error Test
		
		
	}
   
   public function testConnection() {
      connectionTest(connector);
   }
}