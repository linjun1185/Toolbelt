namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;
use Nirlah\Neo4j\Entities\Node;

class GetNode extends Command {

	public function run(const id) -> <Node>
	{
		var properties;
		let properties = this->client->get("node/".id)->toObject();
		return new Node(properties);
	}

}
