import org.as2lib.io.file.ResourceLoader;

/**
 * TODO: Documentation !!!
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.ResourceErrorListener {
	
	/**
	 * TODO: Documentation !!!
	 */
	public function onLoadError(resourceLoader:ResourceLoader, errorCode:String, error):Boolean;
}