namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;
use Nirlah\Neo4j\Graph;

class NodesFilter extends Command {
	
	public function run(const string label, const string property = null, const value = null) -> array
	{
		if property != null && value != null {
			this->client->setParam(property, value);
		}
		var rawNodes, node, nodes = [];
		let rawNodes = this->client->get("label/".label."/nodes")->toObject();
		for node in rawNodes {
			let nodes[] = Graph::node(node);
		}
		return nodes;
	}

}
