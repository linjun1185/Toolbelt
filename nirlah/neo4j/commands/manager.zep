namespace Nirlah\Neo4j\Commands;

use Nirlah\Collection;
use Nirlah\Neo4j\Neo4jException;
use Nirlah\Http\Request;

class Manager extends Collection {

	public function __construct()
	{
		parent::__construct();
		this->registerCoreCommands();
	}

	public function execute(const string command, const array arguments = [], const <Request> client)
	{
		if !this->has(command) {
			throw new Neo4jException("The command \"".command."\" is not registerd.");
		}

		var reflection, instance;
		let reflection = new \ReflectionClass(this->{command});
		let instance = reflection->newInstance();
		instance->setClient(client);
		return call_user_func_array([instance, "run"], arguments);
	}

	protected function registerCoreCommands()
	{
		array commands;
		let commands = [
			// Root
				"getVersion": "Nirlah\\Neo4j\\Commands\\Root\\GetVersion",
				"listLabels": "Nirlah\\Neo4j\\Commands\\Root\\ListLabels",
				"listTypes": "Nirlah\\Neo4j\\Commands\\Root\\ListTypes",
				"listProperties": "Nirlah\\Neo4j\\Commands\\Root\\ListProperties",
			// Node
				// 
				// TODO node properties set/add/remove
				// 
				"getNode": "Nirlah\\Neo4j\\Commands\\Node\\GetNode",
				"nodeProperties": "Nirlah\\Neo4j\\Commands\\Node\\NodeProperties",
				"nodeLabels": "Nirlah\\Neo4j\\Commands\\Node\\NodeLabels",
				"createNode": "Nirlah\\Neo4j\\Commands\\Node\\CreateNode",
				"addLabel": "Nirlah\\Neo4j\\Commands\\Node\\AddLabel",
				"replaceLabel": "Nirlah\\Neo4j\\Commands\\Node\\ReplaceLabel",
				"removeLabel": "Nirlah\\Neo4j\\Commands\\Node\\RemoveLabel",
				"safeDeleteNode": "Nirlah\\Neo4j\\Commands\\Node\\SafeDeleteNode",
				"deleteNode": "Nirlah\\Neo4j\\Commands\\Node\\DeleteNode",
				"nodesFilter": "Nirlah\\Neo4j\\Commands\\Node\\NodesFilter",
				"nodeSetProperties": "",
				"nodeRemoveProperties": "Nirlah\\Neo4j\\Commands\\Node\\NodeRemoveProperties",
				"nodeReplaceProperties": "Nirlah\\Neo4j\\Commands\\Node\\NodeReplaceProperties"
			// Relationship

			// Schema

		];
		this->merge(commands);
	}

}
