import org.as2lib.test.unit.Test;
import org.as2lib.data.io.conn.NetConnector;
import org.as2lib.data.io.conn.Connector;
import org.as2lib.env.out.Out;

class test.org.as2lib.data.io.conn.TNetConnectorImplementation extends Test{
   private var connector:NetConnector;
   public function TNetConnectorImplementation() {
     connector = new NetConnector();
   }
	
	private function connectionTest(con:Connector){
		
		// getter setter Test
		con.setUrl("http://192.168.0.1/flashservices/gateway");
		var myOut:Out = new Out();
		myOut.info(con.getUrl());
		
		// Listener Test
	}
   
   public function testConnection() {
      connectionTest(connector);
   }
}