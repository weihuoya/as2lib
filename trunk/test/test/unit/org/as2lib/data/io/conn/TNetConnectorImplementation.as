import test.org.as2lib.data.io.conn.TImplementation;
import org.as2lib.data.io.conn.NetConnector;

class test.org.as2lib.data.io.conn.TNetConnectorImplementation extends TImplementation {
   private var connection:NetConnector;
   public function TNetConnectorImplementation() {
     connection = new NetConnector();
   }
   public function testConnection() {
      connectionTest(connection);
   }
}