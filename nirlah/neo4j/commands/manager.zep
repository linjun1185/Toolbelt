namespace Nirlah\Neo4j\Commands;

use Nirlah\Collection;
use Nirlah\Neo4j\Neo4jException;

class Manager extends Collection {

	public function __construct()
	{
		parent::__construct();
		this->registerCoreCommands();
	}

	public function execute(const string command, const array arguments = [], const connection)
	{
		if !this->has(command) {
			throw new Neo4jException("The command \"".command."\" is not registerd.");
		}

		var reflection, instance;
		let reflection = new \ReflectionClass(this->{command});
		let instance = reflection->newInstance();
		instance->setConnection(connection);
		return instance->run(arguments);
	}

	protected function registerCoreCommands()
	{
		array commands;
		let commands = [
			// Root
				"getVersion": "Nirlah\\Neo4j\\Commands\\Root\\GetVersion",
				"listLabels": "Nirlah\\Neo4j\\Commands\\Root\\ListLabels",
				"listTypes": "Nirlah\\Neo4j\\Commands\\Root\\ListTypes",
				"listProperties": "Nirlah\\Neo4j\\Commands\\Root\\ListProperties"
			// Node

			// Relationship

			// Transaction

			// Schema

		];
		this->merge(commands);
	}

}