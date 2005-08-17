import org.as2lib.test.unit.TestCase;
import org.as2lib.env.event.distributor.TCompositeEventDistributor;
import org.as2lib.env.event.distributor.SimpleCompositeEventDistributorControl;

class org.as2lib.env.event.distributor.TSimpleCompositeDistributorControl extends TestCase {
	
	public function testDistribution() {
		var helper:TCompositeEventDistributor = new TCompositeEventDistributor(this);
		var instance:SimpleCompositeEventDistributorControl = new SimpleCompositeEventDistributorControl();
		helper.executeProperBroadcasting(instance);
		instance = new SimpleCompositeEventDistributorControl();
		helper.executeWithException(instance);
	}
}