import org.as2lib.basic.ReflectionObject

class org.as2lib.basic.ReflectionReference {
	private var name:String;
	private var path:String;
	private var parentObject:ReflectionObject;
	
	function ReflectionReference (name:String, path:String, parentObject:ReflectionObject){
		this.name = name;
		this.path = path;
		this.parentObject = parentObject;
	}
	
	public function get _name ():String {
		return(this.name);
	}
	
	public function get _path ():String {
		return(this.path);
	}
	
	public function get _parentObject ():ReflectionObject {
		return(this.parentObject);
	}
}