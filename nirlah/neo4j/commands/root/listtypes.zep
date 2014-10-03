namespace Nirlah\Neo4j\Commands\Root;

use Nirlah\Neo4j\Commands\Command;

class ListTypes extends Command {

	public function run()
	{
		var response;
		let response = this->client->get("relationship/types");
		return response->toArray();
	}

}
