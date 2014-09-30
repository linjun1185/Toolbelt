namespace Nirlah\Neo4j;

use Nirlah\Neo4j\Connection\Manager as ConnectionManager;
// use Nirlah\Neo4j\Commands\Manager as CommandsManager;
use Nirlah\Neo4j\Connection\Connection;

class Client {

	protected connections;
	protected commands;

	public function construct()
	{
		let this->connections = new ConnectionManager;
		// let this->commands = new CommandsManager;
	}

	//
	// Commands
	//

	public function __call(const string command, const array arguments = [])
	{
		return this->commands->execute(command, arguments, this->getDefaultConnection());
	}

	//
	// Connections
	//

	public function addConnection(const string name, const config) -> void
	{
		this->connections->addConnection(name, config);
	}

	public function listConnections() -> array
	{
		return this->connections->keys();
	}

	public function setDefaultConnection(const connection) -> void
	{
		this->connections->setDefault(connection);
	}

	public function getDefaultConnection() -> <Connection>
	{
		return this->connections->getDefault();
	}

}
