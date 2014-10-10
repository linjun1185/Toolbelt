namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class RemoveLabel extends Command {
	
	public function run(const node, labels)
	{
		var label;
		if typeof labels == "string" {
			let label = labels;
			let labels = [label];
		}
		for label in labels {
			this->client->delete("node/".node."/labels/".label);
		}
	}

}
