namespace Nirlah\Neo4j\Commands\Transaction;

use Nirlah\Neo4j\Commands\Command;

class Cypher extends Command {
	
	public function run(const string query, const array parameters = null)
	{
		var statement = [];
		let statement["statement"] = query;
		if parameters != null {
			let statement["parameters"] = parameters;
		}
		this->client->setParam("statements", [statement]);
		return this->client->post("transaction/commit")->toObject();
		// 
		// TODO Parse result & look for errors?
		// 
	}
	
}
