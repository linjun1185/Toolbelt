namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;
use Nirlah\Neo4j\Graph;

class GetNode extends Command {

	public function run(const id) -> <Node>
	{
		var node;
		let node = this->client->get("node/".id)->toObject();
		return Graph::node(node);
	}

}
