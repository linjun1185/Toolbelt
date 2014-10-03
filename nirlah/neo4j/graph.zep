namespace Nirlah\Neo4j;

use Nirlah\Neo4j\Connections as ConnectionManager;
use Nirlah\Neo4j\Commands\Manager as CommandsManager;
use Nirlah\Neo4j\Entities\Node;
use Nirlah\Neo4j\Entities\Relationship;
use Nirlah\Collection;
use Nirlah\Http\Request;

class Graph {

	protected static _init = false;
	protected static _initEntities = false;
	protected static connections;
	protected static commands;
	protected static nodes;
	protected static relationships;
	// protected static log;

	public static function test()
	{
		var_dump(self::command("getNode", [12515]));
		var_dump(self::command("nodeLabels", [12515]));
	}

	protected static function init()
	{
		if self::_init == false {
			if !extension_loaded("phalcon") {
				throw new Neo4jException("Neo4j requires Phalcon framework.");
			}

			let self::connections = new ConnectionManager;
			let self::commands = new CommandsManager;

			let self::_init = true;
		}
	}

	protected static function initEntities()
	{
		if self::_initEntities == false {
			self::init();
			let self::nodes = new Collection;
			let self::relationships = new Collection;

			let self::_initEntities = true;
		}
	}

	//
	// Entities
	//

	public static function node(const node = null) -> <Node>
	{
		self::initEntities();
		if typeof node == "int" {
			if isset(self::nodes[node]) {
				return self::nodes[node];
			} else {
				return self::command("getNode", [node]);
			}
		} else {
			return new Node(node);
		}
	}

	public static function relationship(const relationship = null) -> <Relationship>
	{
		self::initEntities();
		if typeof relationship == "int" && isset(self::relationships[relationship]) {
			return self::relationships[relationship];
		} else {
			return new Relationship(relationship);
		}
	}

	public static function registerNode(const <Node> node) -> void
	{
		self::initEntities();
		let self::nodes[node->getId()] = node;
	}

	public static function registerRelationship(const <Relationship> relationship) -> void
	{
		self::initEntities();
		let self::relationships[relationship->getId()] = relationship;
	}

	//
	// Commands
	//

	public static function command(const string command, const array arguments = []) -> var
	{
		return self::executeCommand(command, arguments);
	}

	public static function __callStatic(const string command, const array arguments = []) -> var
	{
		return self::executeCommand(command, arguments);
	}

	protected static function executeCommand(const string command, const array arguments = []) -> var
	{
		self::init();
		return self::commands->execute(command, arguments, self::getDefaultConnection());
	}

	//
	// Connections
	//

	public static function addConnection(const string name, const config) -> void
	{
		self::init();
		self::connections->addConnection(name, config);
	}

	public static function listConnections() -> array
	{
		self::init();
		return self::connections->keys();
	}

	public static function setDefaultConnection(const connection) -> void
	{
		self::init();
		self::connections->setDefault(connection);
	}

	public static function getDefaultConnection() -> <Request>
	{
		self::init();
		return self::connections->getDefault();
	}

}
