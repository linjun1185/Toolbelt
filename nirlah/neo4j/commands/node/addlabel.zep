namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class AddLabel extends Command {
	
	public function run(const int node, labels)
	{
		if typeof labels == "string" {
			var label;
			let label = labels;
			let labels = [label];
		}
		this->client->setParams(labels);
		this->client->post("node/".node."/labels");
	}

}
