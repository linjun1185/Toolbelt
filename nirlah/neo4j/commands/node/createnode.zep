namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;
use Nirlah\Neo4j\Graph;

class CreateNode extends Command {
	
	public function run(const array properties = null, labels = null)
	{
		var node;
		if properties != null {
			this->client->setParams(properties);
		}
		let node = this->client->post("node")->toObject();

		if labels != null {
			if typeof labels == "string" {
				var label;
				let label = labels;
				let labels = [label];
			}
			this->client->clearParams();
			this->client->setParams(labels);
			this->client->post("node/".node->metadata->id."/labels");
			var metadata;
			let metadata = node->metadata;
			let metadata->labels = labels;
			let node->metadata = metadata;
		}

		return Graph::node(node);
	}

}
