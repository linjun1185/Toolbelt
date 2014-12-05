namespace Nirlah\Neo4j\Transactions;

use Nirlah\Neo4j\Neo4jException;
use Nirlah\Collection;
use Nirlah\Http\Request;
use Nirlah\Neo4j\Graph;

class Statement {

	protected phrase;
	protected params;
	protected dataFormats;
	protected includeStats = false;
	protected commited = false;
	protected columns = [];
	protected data = [];

	public function __construct(const string phrase, const array params = [])
	{
		let this->phrase = phrase;
		let this->params = new Collection(params);
		this->formatAsRowAndGraph();
	}

	public function set(const string phrase)
	{
		let this->phrase = phrase;
	}

	public function build() -> array
	{
		var statement;
		let statement = [
			"statement": this->phrase,
			"resultDataContents": this->dataFormats
		];
		if count(this->params) > 0 {
			let statement["parameters"] = this->params->all();
		}
		if this->includeStats {
			let statement["includeStats"] = this->includeStats;
		}
		return statement;
	}

	//
	// Params
	//

	public function __get(const string param) -> var
	{
		return this->params->get(param);
	}

	public function __set(const string param, const value) -> void
	{
		this->params->set(param, value);
	}

	public function __isset(const string param) -> boolean
	{
		return this->params->has(param);
	}

	public function __unset(const string param) -> void
	{
		this->params->forget(param);
	}

	//
	// Format
	//

	public function formatAsRowAndGraph() -> void
	{
		let this->dataFormats = ["row", "graph"];
	}

	public function formatAsGraphAndRow() -> void
	{
		this->formatAsRowAndGraph();
	}

	public function formatAsRow() -> void
	{
		let this->dataFormats = ["row"];
	}

	public function formatAsGraph() -> void
	{
		let this->dataFormats = ["graph"];
	}

	public function formatAsRest() -> void
	{
		let this->dataFormats = ["REST"];
	}

	//
	// Commit
	//

	public function commit() -> <Transaction>
	{
		var connection, response;
		let connection = this->getConnection();
		let connection->statements = [ this->build() ];
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

	public function parse(const response) -> void
	{
		var decoded = [], errors, result;
		let decoded = json_decode(response->body, true);

		// Has errors?
		let errors = decoded["errors"];
		if count(errors) > 0 {
			var error;
			let error = errors[0];
			throw new Neo4jException(error["code"]."\n".error["message"]);
		}

		let result = decoded["results"][0];
		let this->columns = result["columns"];
		let this->data = result["data"];
	}

	public function getColumns() -> array
	{
		return this->columns;
	}

	public function getData() -> array
	{
		return this->data;
	}

	public function getTable() -> array
	{
		var table = [], row, result, columnsCount, column = 0, key;

		let columnsCount = count(this->columns);

		for result in this->data {
			let row = [];
			while column < columnsCount {
				let key = this->columns[column];
				let row[key] = result["row"][column];
				let column++;
			}
			let table[] = row;
		}

		return table;
	}

	public function getGraphs()// -> void
	{
		var result;
		
		for result in this->data {
			return this->data;
		}
	}

}
