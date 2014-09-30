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

	public function getDefault() -> <Connection>
	{
		var name;
		let name = this->defaultName;
		return this->{name};
	}

	public function setDefault(const connection) -> void
	{
		var name;
		if connection instanceof Connection {
			let name = this->defaultName;
			let this->{name} = connection;
		} elseif typeof connection == "array" {
			var newConnection;
			let newConnection = new Collection(connection);
			let name = this->defaultName;
			let this->{name} = newConnection;
		} else {
			let this->defaultName = connection;
		}
	}

	public function addConnection(const string name, const config) -> void
	{
		if config instanceof Connection {
			let this->{name} = config;
		} else {
			let this->{name} = new Connection(config);
		}
	}

}
