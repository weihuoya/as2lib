import org.as2lib.test.unit.Test;
import org.as2lib.data.io.conn.local.LocalConnector;
import org.as2lib.env.out.Out;
import org.as2lib.data.io.conn.local.LocalRequest;

class test.org.as2lib.data.io.conn.local.TLocalConnectorImplementation extends Test{
   private var connector:LocalConnector;
   
   public function TLocalConnectorImplementation() {
     connector = new LocalConnector();
   }
	
	private function connectionTest(con:LocalConnector):Void{
		
		// initialization of output object
		var myOut:Out = new Out();
		//myOut.setLevel(Out.INFO);
		
		// getter setter Test
		myOut.info("-- Test of setIdentifier --");
		//con.setIdentifier("http://192.168.0.2/flashservices/gateway");
		con.setIdentifier("mycon");
		myOut.info("LocalConnector.identifier: "+con.getIdentifier());
		
		// Listener Test
		
		/*myOut.info("-- Test of Listener --");
		var l1:ExampleListener = new ExampleListener();
		var l2:ExampleListener = new ExampleListener();
		var l3:ExampleListener = new ExampleListener();
		myOut.info("---- addListener l1,l2,l3 --");
		con.addListener(l1);
		con.addListener(l2);
		con.addListener(l3);
		myOut.info("---- removeListener l1 --");*/
		//con.removeListener(l1);
		
		// EventBroadcaster for testing of onError onResponse methods
		//myOut.info("-- Test of EventBroadcaster --");
		
		//myEB = con.getEventBroadcaster();
		
		//var myListener:ListenerArray = myEB.getAllListener();
		//trace(ExampleListener(myListener.get(0)).counter);
		//trace(typeof(myListener.get(1)));
		
		/*for(var i=0; i<=myListener.length;i++){
			var l = myListener.get(i);
			trace("myListener.get: "+l instanceof ExampleListener);
			myOut.info("EventBroadcaster.ListenerArray:");
		}
		*/
		//myEB.dispatch(new ConnectorError("TestConnectionError",this,new FunctionArguments(),true,false));
		//myEB.dispatch(new ConnectorResponse());
		
		//Establish Connection
		//con.initConnection();
		//con.handleRequest(new RemotingRequest("com.oreilly.frdg.HelloWorld.sayHello"));
		
	}
   
   public function testConnection():Void{
      connectionTest(connector);
   }
}