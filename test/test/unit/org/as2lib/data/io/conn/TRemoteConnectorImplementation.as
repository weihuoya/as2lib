import org.as2lib.test.unit.Test;
import test.org.as2lib.data.io.conn.TImplementation;
import org.as2lib.data.io.conn.remoting.RemotingConnector;
import org.as2lib.data.io.conn.Connector;
import org.as2lib.env.out.Out;
import test.org.as2lib.data.io.conn.ExampleListener;
import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.ListenerArray;

class test.org.as2lib.data.io.conn.TRemoteConnectorImplementation extends Test{
   private var connector:RemotingConnector;
   private var myEB:EventBroadcaster;
   
   public function TNetConnectorImplementation() {
     connector = new RemotingConnector();
   }
	
	private function connectionTest(con:RemotingConnector){
		
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
		
		con.removeListener(l1);
		
		myEB = con.getEventBroadcaster();
		
		trace("toString"+myEB.toString());
		
		var myListener:ListenerArray = myEB.getAllListener();
		myOut.info("added Listeners:"+ myListener.length);
		
		for(var i=0; i<myListener.length;i++){
			myOut.info("EventBroadcaster.ListenerArray:"+myListener.get(i));
		}
		
		//myOut.info("getAllListener()"+myEB.getAllListener());
		
		/*con.dispatch(new SimpleEventInfo("onError"));
		con.dispatch(new SimpleEventInfo("onResponse"));*/
		// Error Test
		
		
	}
   
   public function testConnection() {
      connectionTest(connector);
   }
}