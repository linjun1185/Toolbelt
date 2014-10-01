namespace Nirlah\Neo4j\Commands\Root;

use Nirlah\Neo4j\Commands\Command;

class ListLabels extends Command {

	public function run()
	{
		var response;
		let response = this->connection->get("/labels");
		return response->toArray();
	}

}
