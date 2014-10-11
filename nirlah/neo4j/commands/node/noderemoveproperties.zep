namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;

class NodeRemoveProperties extends Command {

	public function run(const node, var properties = null)
	{
		if properties == null {
			this->client->delete("node/".node."/properties");
		} else {
			var property;
			if typeof properties == "string" {
				let property = properties;
				let properties = [property];
			}
			for property in properties {
				this->client->delete("node/".node."/properties/".property);
			}
		}
	}

}
