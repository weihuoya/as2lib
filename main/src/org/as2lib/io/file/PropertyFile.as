import org.as2lib.data.type.Byte;
import org.as2lib.io.file.SimpleTextFile;
import org.as2lib.data.type.MultilineString;
import org.as2lib.util.StringUtil;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.Logger;
import org.as2lib.data.holder.Properties;
import org.as2lib.data.holder.properties.PropertiesFactory;

/**
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.PropertyFile extends SimpleTextFile {
	
	private var index:Array;
	private var properties:Properties;
	
	/**
	 * 
	 */
	public function PropertyFile(source:String, size:Byte, uri:String) {
		super(source, size, uri);
	}
	
	public function getProperties(Void):Properties {
		if (!properties) {
			properties = PropertiesFactory.getInstance().createProperties(source);
		}
		return properties;
	}
}