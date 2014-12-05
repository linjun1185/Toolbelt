namespace Nirlah\Neo4j;

use Nirlah\Neo4j\Connections as ConnectionManager;
use Nirlah\Neo4j\Commands\Manager as CommandsManager;
use Nirlah\Http\Request;
use Nirlah\Collection;
use Nirlah\Neo4j\Entities\Node;
use Nirlah\Neo4j\Entities\Relationship;

class Graph {

	protected static _init = false;
	protected static _initEntities = false;
	protected static connections;
	protected static commands;
	protected static nodes;
	protected static relationships;
	// protected static log;

	// 
	// TODO log connections events
	//

	protected static function init()
	{
		if self::_init == false {
			let self::connections = new ConnectionManager;
			let self::commands = new CommandsManager;

			let self::_init = true;
		}
	}

	protected static function initEntities()
	{
		if self::_initEntities == false {
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
		} elseif is_object(node) {
			var id;
			let id = node->metadata->id;
			if isset(self::nodes[id]) {
				return self::nodes[id];
			} else {
				return new Node(node);
			}
		} elseif is_array(node) {
			return new Node(node);
		} else {
			throw new Neo4jException("Node may only be created by ID, object or array.");
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
	// Transactions
	//

	// ::trasaction(const statement = null, const array params = [])
	// if statment == null -> new transaction
	// is statment is int -> new transaction with ID
	// else -> new transaction with statement ans params
	// init()

	// ::cypher(const statement, const array params = null)
	// init()

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
