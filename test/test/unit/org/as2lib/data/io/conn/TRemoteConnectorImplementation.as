import org.as2lib.test.unit.Test;
import test.org.as2lib.data.io.conn.TImplementation;
import org.as2lib.data.io.conn.remoting.RemotingConnector;
import org.as2lib.env.out.Out;
import test.org.as2lib.data.io.conn.ExampleListener;
import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.ListenerArray;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;

class test.org.as2lib.data.io.conn.TRemoteConnectorImplementation extends Test{
   private var connector:RemotingConnector;
   private var myEB:EventBroadcaster;
   
   public function TRemoteConnectorImplementation() {
     connector = new RemotingConnector();
   }
	
	private function connectionTest(con:RemotingConnector){
		
		// initialization of output object
		var myOut:Out = new Out();
		
		// getter setter Test
		
		myOut.info("-- Test of setIdentifier --");
		con.setIdentifier("http://192.168.0.1/flashservices/gateway");
		myOut.info("RemotingConnector.identifier: "+con.getIdentifier());
		
		// Listener Test
		
		myOut.info("-- Test of Listener --");
		var l1:ExampleListener = new ExampleListener();
		var l2:ExampleListener = new ExampleListener();
		var l3:ExampleListener = new ExampleListener();
		myOut.info("---- addListener l1,l2,l3 --");
		con.addListener(l1);
		con.addListener(l2);
		con.addListener(l3);
		myOut.info("---- removeListener l1 --");
		//con.removeListener(l1);
		
		// EventBroadcaster for testing of onError onResponse methods
		myOut.info("-- Test of EventBroadcaster --");
		myEB = con.getEventBroadcaster();
		
		//var myListener:ListenerArray = myEB.getAllListener();
		//trace(ExampleListener(myListener.get(0)).counter);
		//trace(typeof(myListener.get(1)));
		
		/*for(var i=0; i<=myListener.length;i++){
			var l = myListener.get(i);
			trace("myListener.get: "+l instanceof ExampleListener);
			myOut.info("EventBroadcaster.ListenerArray:");
		}
		*/
		myEB.dispatch(new ConnectorError("TestConnectionError",this,new FunctionArguments(),true,false));
		myEB.dispatch(new ConnectorResponse());
		// Error Test
		
		
	}
   
   public function testConnection() {
      connectionTest(connector);
   }
}