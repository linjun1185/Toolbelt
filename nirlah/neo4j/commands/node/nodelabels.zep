namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class NodeLabels extends Command {

	public function run(const id) -> array
	{
		var labels;
		let labels = this->client->get("node/".id."/labels");
		return labels->toArray();
	}

}
