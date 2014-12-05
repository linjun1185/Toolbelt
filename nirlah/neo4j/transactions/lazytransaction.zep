namespace Nirlah\Neo4j\Transactions;

use Nirlah\Neo4j\Neo4jException;
use Nirlah\Http\Request;
use Nirlah\Neo4j\Graph;

class LazyTransaction {
	
	protected commited = false;
	protected statements = [];
	protected columns = [];
	protected data = [];

	public function add(const phrase, const array params = []) -> void
	{
		if this->commited {
			throw new Neo4jException("Cannot add statement to a transaction that was already commited.");
		}
		if is_object(phrase) && (phrase instanceof Statement) {
			let this->statements[] = phrase;
		} elseif typeof phrase == "string" {
			let this->statements[] = new Statement(phrase, params);
		} else {
			throw new Neo4jException("A statement must be a string or a Statement instance.");
		}
	}

	public function allStatements() -> array
	{
		return this->statements;
	}

	public function commit() -> <Transaction>
	{
		var connection, response;
		let connection = this->getConnection();
		let connection->statements = this->build();
		let response = connection->post("transaction/commit");
		let this->commited = true;
		this->parse(response);
		return this;
	}

	protected function getConnection() -> <Request>
	{
		var connection;
		let connection = Graph::getDefaultConnection();
		connection->useJson();
		return connection;
	}

	protected function build() -> string
	{
		var statements = [], statement;
		for statement in this->statements {
			let statements[] = statement->build();
		}
		return statements;
	}

	protected function parse(const response) -> void
	{
		var decoded = [], errors, results, result;
		let decoded = json_decode(response->body, true);

		// Has errors?
		let errors = decoded["errors"];
		if count(errors) > 0 {
			var error;
			let error = errors[0];
			throw new Neo4jException(error["code"]."\n".error["message"]);
		}

		let results = decoded["results"];
		for result in results {
			let this->columns[] = result["columns"];
			let this->data[] = result["data"];
		}
	}

	//
	// Response
	//

	public function getColumns() -> array
	{
		return this->columns;
	}

	public function getData() -> array
	{
		return this->data;
	}

	// protected function resultIterator(const func) -> array|object
	// {
	// 	var result = [], count, i = 0, columns, data;
	// 	let count = count(this->columns);
	// 	while i < count {
	// 		let columns = this->columns[i];
	// 		let data = this->data[i];
	// 		let result[] = call_user_func(func, columns, data);
	// 		let i++;
	// 	}
	// 	if count == 1 {
	// 		return result[0];
	// 	}
	// 	return result;
	// }

	// public function getRow() -> array
	// {
	// 	var key, column, columns, data, result, transactionsCount, resultsCount, resultPrepare, results = [];
	// 	// Loop transactions:
	// 	let transactionsCount = count(this->columns);
	// 	for t in range(0, transactionsCount) {
	// 		let columns = this->columns[t];
	// 		let data = this->data[t];

	// 		// Loop data results:
	// 		let resultPrepare = [];
	// 		let resultsCount = count(data[t]);
	// 		for r in range(0, resultsCount) {
	// 			let result = data[r];
	// 			for key, column in columns {
	// 				// [column: result[key]]
	// 			}
	// 		}
	// 		let results[t] = resultPrepare;
	// 	}

	// 	var temp = [];
	// 	return temp;
	// }

	// public function getGraph() -> array|object // <subGraph>
	// {
		
	// }

	// public function getRest() -> array
	// {

	// }

}
