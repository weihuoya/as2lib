import org.as2lib.core.BasicClass;
import org.as2lib.data.type.Byte;
import org.as2lib.data.type.MultiLineString;
import org.as2lib.io.file.File;
import org.as2lib.io.file.FileFactory;
import org.as2lib.io.file.SimpleFileFactory;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;

/**
 * @author HeideggerMartin
 */
class org.as2lib.io.file.CompositeFileFactory extends BasicClass implements FileFactory {

    private var defaultFileFactory:FileFactory;
    
    private var extensionFactories:Map;
    
    public function CompositeFileFactory(Void) {
    	defaultFileFactory = new SimpleFileFactory();
    	extensionFactories = new HashMap();
    }

	public function createFile(source:MultiLineString, size:Byte, uri:String):File {
		var factory:FileFactory = extensionFactories.get(uri.substr(uri.lastIndexOf(".")));
		if (!factory) {
			factory = defaultFileFactory;
		}
		return factory.createFile(source, size, uri);
	}
	
	public function setDefaultFileFactory(fileFactory:FileFactory):Void {
		defaultFileFactory = fileFactory;
	}
	
	public function setFileFactory(extension:String, fileFactory:FileFactory):Void {
		extensionFactories.put(extension, fileFactory);
	}
}