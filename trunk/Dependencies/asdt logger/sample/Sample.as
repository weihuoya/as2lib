import Log;
class Sample
{
	public static function main ()
	{
		var sample:Sample;
		sample = new Sample();	
	}
	private function Sample ()
	{
		Mouse.addListener(this);
	}
	public function onMouseDown ()
	{
		// Log.addMessage("SampleMessage (Log.addMessage)", Log.INFO);
		// TRACE("SampleMessage (Log.addMessage)");
		// Beware of MMC (Flash IDE) which does not suppert two parameters for TRACE		
		TRACE("SampleMessage (Log.addMessage)", Log.WARNING);
	}
}