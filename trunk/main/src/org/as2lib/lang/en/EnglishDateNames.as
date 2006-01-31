import org.as2lib.data.holder.properties.SimpleProperties;

/**
 * @author Martin Heidegger
 */
dynamic class org.as2lib.lang.en.EnglishDateNames extends SimpleProperties {
	private static var instance:EnglishDateNames;
	
	public static function getInstance():EnglishDateNames {
		if (!instance) {
			instance = new EnglishDateNames();
		}
		return instance;
	}
	
	private function EnglishDateNames() {
		
		s("SHORT", "dd.mm.yy hh:nn");
		s("MEDIUM", "MM dd, yyyy, hh:nn");
		s("LONG", "MMMM dd, yyyy, hh:nn");
		s("FULL", "DDDD, MMMM dd, yyyy, hh:nn:ss");
		
		s("long.day.1", "Sunday");
		s("long.day.2", "Monday");
		s("long.day.3", "Tuesday");
		s("long.day.4", "Wednesday");
		s("long.day.5", "Thursday");
		s("long.day.6", "Friday");
		s("long.day.7", "Sathurday");
		s("short.day.1", "Su");
		s("short.day.2", "Mo");
		s("short.day.3", "Tu");
		s("short.day.4", "We");
		s("short.day.5", "Th");
		s("short.day.6", "Fr");
		s("short.day.7", "Sa");
		
		s("long.month.1", "January");
		s("long.month.2", "February");
		s("long.month.3", "March");
		s("long.month.4", "April");
		s("long.month.5", "May");
		s("long.month.6", "June");
		s("long.month.7", "July");
		s("long.month.8", "August");
		s("long.month.9", "September");
		s("long.month.10", "October");
		s("long.month.11", "November");
		s("long.month.12", "December");
		s("short.month.1", "Jan");
		s("short.month.2", "Feb");
		s("short.month.3", "Mar");
		s("short.month.4", "Apr");
		s("short.month.5", "May");
		s("short.month.6", "Jun");
		s("short.month.7", "Jul");
		s("short.month.8", "Aug");
		s("short.month.9", "Sep");
		s("short.month.10", "Oct");
		s("short.month.11", "Nov");
		s("short.month.12", "Dec");
		
		s("long.millisecond", "Millisecond");
		s("long.milliseconds", "Milliseconds");
		s("long.second", "Second");
		s("long.seconds", "Seconds");
		s("long.minute", "Minute");
		s("long.minutes", "Minutes");
		s("long.hour", "Hour");
		s("long.hours", "Hours");
		s("long.day", "Day");
		s("long.days", "Days");
		s("long.month", "Month");
		s("long.months", "Months");
		s("long.year", "Year");
		s("long.years", "Years");
		
		s("short.milliseconds", "ms");
		s("short.second", "s");
		s("short.minute", "m");
		s("short.hour", "h");
		s("short.day", "d");	
		s("short.month", "M");
		s("short.year", "Y");	
	}
	
	private function s(k:String, v:String) {
		setProp(k, v);
	}
}