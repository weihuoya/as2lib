import org.as2lib.core.BasicClass;

class org.as2lib.data.io.conn.remoting.RemotingHeader extends BasicClass {
	
	private var name:String;
	private var mustUnderstand:Boolean;
	private var object:Object;
	
	public function RemotingHeader(name:String, mustUnderstand:Boolean, object:Object){
		this.name = name;
		this.mustUnderstand = mustUnderstand;
		this.object = object;
	}
	
	public function getName():String {
		return name;
	}
	
	public function getMustUnderstand():Boolean {
		return mustUnderstand;
	}
	
	public function getObject():Object {
		return object;
	}
}