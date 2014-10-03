namespace Nirlah\Neo4j;

use Nirlah\Collection;
use Nirlah\Http\Request;
use Nirlah\Http\Uri;

class Connections extends Collection {

	const DEFAULT_HOST = "localhost";
	const DEFAULT_PORT = 7474;
	const DEFAULT_SECURE = false;
	const DEFAULR_USER = null;
	const DEFAULT_PASS = null;
	const BASE_PATH = "db/data";

	const DEFAULT_NAME = "default";
	protected defaultName;

	public function __construct(var connection = null)
	{
		var name;
		parent::__construct();
		if connection == null {
			let connection = ["host": self::DEFAULT_HOST, "port": self::DEFAULT_PORT];
		} elseif !is_array(connection) {
			throw new Neo4jException("Connections may be constructed only by a connection array.");
		}
		let name = self::DEFAULT_NAME;
		let this->defaultName = name;
		let this->{name} = connection;
	}

	public function getDefault() -> <\Nirlah\Http\Request>
	{
		var name;
		let name = this->defaultName;
		return this->{name};
	}

	public function setDefault(const connection) -> void
	{
		if typeof connection == "array" {
			var name;
			let name = this->defaultName;
			let this->{name} = connection;
		} elseif typeof connection == "string" {
			let this->defaultName = connection;
		} else {
			throw new Neo4jException("Can only set default by name or config array.");
		}
	}

	// Overide collection:

	public function get(const connection) -> <Request>
	{
		var config, request, uri;
		let request = new Request;
		let config = parent::get(connection);

		// Build Uri:
		let uri = new Uri;
		let uri->baseUri = isset(config["host"]) ? config["host"] : self::DEFAULT_HOST;
		let uri->port = isset(config["port"]) ? config["port"] : self::DEFAULT_PORT;
		let uri->path = self::BASE_PATH;
		let uri->secure = isset(config["secure"]) ? config["secure"] : self::DEFAULT_SECURE;
		let uri->user = isset(config["user"]) ? config["user"] : null;
		let uri->pass = isset(config["pass"]) ? config["pass"] : null;
		request->setBaseUri(uri);

		return request;
	}
	
	public function set(const connection, const array config) -> <Collection>
	{
		return parent::set(connection, config);
	}

}
