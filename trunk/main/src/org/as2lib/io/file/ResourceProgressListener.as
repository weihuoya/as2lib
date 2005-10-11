import org.as2lib.io.file.ResourceLoader;

/**
 * TODO: Documentation !!!
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.ResourceProgressListener {
	
	/**
	 * Event to be published if the percentage of the loaded process changes.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that executes the request
	 */
	public function onLoadProgress(resourceLoader:ResourceLoader):Void;
}