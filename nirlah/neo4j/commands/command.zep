namespace Nirlah\Neo4j\Commands;

use Nirlah\Neo4j\Connections\Connection;

abstract class Command {

	protected connection;

	public function setConnection(const <Connection> connection) -> void
	{
		let this->connection = connection;
	}
	
	abstract public function run();

}
