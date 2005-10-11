import org.as2lib.core.BasicInterface;
import org.as2lib.data.type.Byte;

/**
 * {@code Resource} represents any external or internal resource.
 * 
 * <p>Any {@code Resource} has to have a location and a size.
 * 
 * <p>{@link ResourceLoader} contains the functionality to load a certain
 * resource.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.Resource extends BasicInterface {
	
	/**
	 * Returns the location of the resource corresponding to the content.
	 * 
	 * <p>Note: Might be the URI of the resource or null if its not requestable
	 * or the internal location corresponding to the instance path (if its without
	 * any connection to a real file).
	 * 
	 * @return location of the resource related to the content
	 */
	public function getLocation(Void):String;
	
	/**
	 * Returns the size of the resource in bytes.
	 * 
	 * @return size of the resource in bytes
	 */
	public function getSize(Void):Byte;
}