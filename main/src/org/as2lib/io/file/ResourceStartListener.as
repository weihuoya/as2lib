import org.as2lib.io.file.ResourceLoader;

/**
 * TODO: Documentation !!!
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.ResourceStartListener {
	
	/**
	 * Event to be published if the {@code ResourceLoader} started a request.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that was started
	 */
	public function onResourceStart(resourceLoader:ResourceLoader):Void;
	
}