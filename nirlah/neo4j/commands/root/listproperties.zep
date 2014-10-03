namespace Nirlah\Neo4j\Commands\Root;

use Nirlah\Neo4j\Commands\Command;

class ListProperties extends Command {

	public function run()
	{
		var response;
		let response = this->client->get("propertykeys");
		return response->toArray();
	}

}
