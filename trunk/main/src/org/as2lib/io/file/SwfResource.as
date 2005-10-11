import org.as2lib.core.BasicClass;
import org.as2lib.data.type.Byte;
import org.as2lib.io.file.Resource;

/**
 * @author HeideggerMartin
 */
class org.as2lib.io.file.SwfResource extends BasicClass implements Resource {

	private var size:Byte;

	private var uri:String;

	private var container:MovieClip;
	
	public function SwfResource(container:MovieClip, uri:String, size:Byte) {
		this.size = size;
		this.uri = uri;
		this.container = container;
	}
	
	public function getContainer(Void):MovieClip {
		return container;
	}
	
	public function getLocation(Void):String {
		return uri;
	}

	public function getSize(Void):Byte {
		return size;
	}
}