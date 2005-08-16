import org.as2lib.test.unit.TestCase;
import org.as2lib.env.event.distributor.TCompositeEventDistributor;
import org.as2lib.env.event.distributor.SimpleCompositeDistributorControl;

class org.as2lib.env.event.distributor.TSimpleCompositeDistributorControl extends TestCase {
	
	public function testDistribution() {
		var helper:TCompositeEventDistributor = new TCompositeEventDistributor(this);
		var instance:SimpleCompositeDistributorControl = new SimpleCompositeDistributorControl();
		helper.executeProperBroadcasting(instance);
		instance = new SimpleCompositeDistributorControl();
		helper.executeWithException(instance);
	}
}