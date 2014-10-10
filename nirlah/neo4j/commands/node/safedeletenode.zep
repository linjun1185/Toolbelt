namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class SafeDeleteNode extends Command {
	
	public function run(const node)
	{
		this->client->delete("node/".node);
	}

}
