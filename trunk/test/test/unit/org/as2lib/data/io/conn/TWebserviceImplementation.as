import test.org.as2lib.data.io.conn.TImplementation
import org.as2lib.data.io.conn.WebserviceConnector;

class test.org.as2lib.data.io.conn.TWebserviceImplementation extends TImplementation {
   private var connection:WebserviceConnector;
   public function TWebserviceImplementation() {
     connection = new WebserviceConnector();
   }
   public function testConnection() {
      connectionTest(connection);
   }
}