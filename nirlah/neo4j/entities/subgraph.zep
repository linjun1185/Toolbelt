namespace Nirlah\Neo4j\Entities;

use Nirlah\Collection;
use Nirlah\Neo4j\Graph;
use Nirlah\Neo4j\Entities\Node;
use Nirlah\Neo4j\Entities\Relationship;

class SubGraph {

	protected nodes;
	protected relationships;

	public function __construct()
	{
		let this->nodes = new Collection;
		let this->relationships = new Collection;
	}

	public function node(const inputNode = null) -> <Node>
	{
		var node;
		let node = Graph::node(inputNode);
		if ! this->nodes->has(node) {
			this->nodes->add(node);
		}
		return node;
	}

	public function relationship(const inputRelationship = null) -> <Relationship>
	{
		var relationship;
		let relationship = Graph::relationship(inputRelationship);
		if ! this->relationships->has(relationship) {
			this->relationships->add(relationship);
		}
		return relationship;
	}

}
