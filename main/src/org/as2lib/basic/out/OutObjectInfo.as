import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.out.OutLevel;
import org.as2lib.basic.Throwable;
import org.as2lib.basic.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.OutObjectInfo extends BasicClass implements EventInfo {
	/** The name of the event. */
	private var name:String;
	
	/** The message. */
	private var object:Object;
	
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 */
	public function OutObjectInfo(aName:String, anObject:Object, aLevel:OutLevel) {
		name = aName;
		object = anObject;
		level = aLevel;
	}
	
	public function getLevel(Void):OutLevel {
		return level;
	}
	
	public function getObject(Void):Object {
		return object;
	}
	
	/**
	 * @see org.as2lib.basic.event.EventInfo
	 */
	public function getName(Void):String {
		return name;
	}
}