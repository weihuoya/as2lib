import org.as2lib.env.event.EventInfo;
import org.as2lib.core.BasicClass;

class org.as2lib.data.io.conn.ConnectorResponse extends BasicClass implements EventInfo{
	
	/** Name of the event */
	private var name:String;
	private var data:Object;
	
	public function ConnectorResponse() {
		name = "onResponse";
	
	}
	
	public function getData(Void):Object {
		return data;
	}
	
	/**
	 * @return The specified name.
	 */
	public function getName(Void):String {
		return this.name;
	}
}