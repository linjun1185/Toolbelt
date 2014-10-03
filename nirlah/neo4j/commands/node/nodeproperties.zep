namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class NodeProperties extends Command {

	public function run(const id) -> array
	{
		var properties;
		let properties = this->client->get("node/".id."/properties");
		return properties->toArray();
	}

}
