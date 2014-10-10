namespace Nirlah\Neo4j\Commands\Node;

use Nirlah\Neo4j\Commands\Command;
use Nirlah\Neo4j\Graph;

class DeleteNode extends Command {
	
	public function run(const id)
	{
		Graph::command("cypher", ["MATCH (n) WHERE id(n)={id} OPTIONAL MATCH (n)-[r]-() DELETE r, n", ["id":id]]);
		// 
		// TODO use the new TBD Cypher command
		// 
	}

}
