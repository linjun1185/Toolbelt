namespace Nirlah\Neo4j\Commands\Root;

use Nirlah\Neo4j\Commands\Command;

class GetVersion extends Command {

	public function run()
	{
		var response;
		let response = this->connection->get("/");
		return response->toObject()->neo4j_version;
	}

}
