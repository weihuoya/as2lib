import org.as2lib.core.BasicClass;
import org.as2lib.data.type.Byte;
import org.as2lib.data.type.MultiLineString;
import org.as2lib.io.file.File;
import org.as2lib.io.file.FileFactory;
import org.as2lib.io.file.XmlFile;

/**
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.XmlFileFactory extends BasicClass implements FileFactory {
	
	public function createFile(source:MultiLineString, size:Byte, uri:String):File {
		return (new XmlFile(source, size, uri));
	}

}