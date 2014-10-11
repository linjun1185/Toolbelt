namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class NodeSetProperties extends Command {

	public function run(const node, const array properties)
	{
		if count(properties) == 1 {
			var key, value;
			// 
			// TODO set postfields as string (value)
			let key = "";
			// 
			// 
			this->client->put("node/".node."/properties/".key);
		} else {
			// 
			// TODO use the new TBD Cypher command.
			// 
		}
	}

}
