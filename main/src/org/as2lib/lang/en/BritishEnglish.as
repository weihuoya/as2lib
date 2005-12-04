import org.as2lib.lang.ConcreteLocale;
import org.as2lib.lang.en.EnglishDateNames;
import org.as2lib.lang.DateFormat;
import org.as2lib.lang.NumberFormat;

/**
 * @author Martin Heidegger
 */
class org.as2lib.lang.en.BritishEnglish extends ConcreteLocale {
	public function BritishEnglish() {
		super("en", EnglishDateNames.getInstance());
		mF.setDateFormat(new DateFormat(null, EnglishDateNames.getInstance()));
		mF.setNumberFormat(new NumberFormat("*.*", "round", ".", ","));
	}
	
	public function getCurrencyFormat(Void):String {
		return "$ ##.#";		
	}
	
	
}