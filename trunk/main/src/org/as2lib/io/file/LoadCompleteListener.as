import org.as2lib.io.file.ResourceLoader;

/**
 * TODO: Documentation !!!
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.LoadCompleteListener {
	
	/**
	 * Event to be published if the resource finished loading.
	 * 
	 * <p>This event will only occur after the {@code ResourceLoader} was started.
	 * 
	 * <p>This event will not occur if the resource was not available.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that contains the requested resource
	 */
	public function onLoadComplete(resourceLoader:ResourceLoader):Void;
}