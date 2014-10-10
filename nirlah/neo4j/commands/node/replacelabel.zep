namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class ReplaceLabel extends Command {
	
	public function run(const node, labels)
	{
		if typeof labels == "string" {
			var label;
			let label = labels;
			let labels = [label];
		}
		this->client->setParams(labels);
		this->client->put("node/".node."/labels");
	}

}
