namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class NodeReplaceProperties extends Command {

	public function run(const node, const array properties)
	{
		this->client->setParams(properties);
		this->client->put("node/".node."/properties");
	}

}
