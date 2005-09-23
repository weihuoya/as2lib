import org.as2lib.data.type.Byte;
import org.as2lib.data.type.MultiLineString;
import org.as2lib.io.file.SimpleFile;

/**
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.XmlFile extends SimpleFile {
	
	private var xml:XML;
	
	public function XmlFile(source:MultiLineString, size : Byte, uri : String) {
		super(source, size, uri);
		xml = new XML();
		xml.parseXML(source);
	}
	
	public function getLoadedXml(Void):XML {
		return xml;
	}
}