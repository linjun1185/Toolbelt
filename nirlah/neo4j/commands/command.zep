namespace Nirlah\Neo4j\Commands;

use Nirlah\Http\Request;

abstract class Command {

	protected client;
	// method
	// route
	// properties
	// body
	// abstract prepare
	// abstract handle

	public function setClient(const <Request> client) -> void
	{
		let this->client = client;
	}
	
	abstract public function run();

}
