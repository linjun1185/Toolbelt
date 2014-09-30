namespace Nirlah\Neo4j\Connection;

use Nirlah\Collection;

class Manager extends Collection {

	protected defaultName;

	public function __construct(const string defaultName = "default")
	{
		parent::__construct();
		var defaultConnection;
		let defaultConnection = new Connection("localhost", 4747);
		let this->defaultName = defaultName;
		let this->{defaultName} = defaultConnection;
	}

}
