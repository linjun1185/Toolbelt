namespace Nirlah\Neo4j\Entities;

use Nirlah\Collection;
use Nirlah\Neo4j\Neo4jException;
use Nirlah\Neo4j\Graph;

abstract class Entity implements \IteratorAggregate, \ArrayAccess {
	
	protected id;
	protected exists = false;
	protected properties;
	protected originalProperties;

	// 
	// TODO add behaviors: timestamps, softdelete.
	// TODO events.
	// TODO date properties,
	// 

	public function __construct(const config = null)
	{
		// Config:
		if config != null {
			if typeof config == "array" {
				this->parseArray(config);
			} elseif is_object(config) {
				let this->exists = true;
				this->parseObject(config);
			} else {
				throw new Neo4jException("Graph's Entity may be configed only with array or object.");
			}
		}
	}

	abstract protected function parseArray(const array config) -> void;
	abstract protected function parseObject(const config) -> void;

	public function setId(const int id) -> void
	{
		let this->id = id;
		Graph::registerNode(this);
	}

	public function getId() -> int
	{
		return this->id;
	}

	public function isExists() -> boolean
	{
		return this->exists;
	}

	public function isDirty() -> boolean
	{
		return this->isDirtyProperties();
	}

	// 
	// Properties
	// 

	public function setProperties(const array properties) -> void
	{
		this->loadProperties();
		this->archiveOriginalProperties();
		var property, value;
		for property, value in properties { // We don't merge because we need to mutate.
			this->callSetMutator(property, value);
		}
	}

	public function properties() -> array
	{
		this->loadProperties();
		return this->properties->all();
	}

	protected function getProperty(const property) -> var
	{
		this->loadProperties();
		return this->callGetMutator(property);
	}
	
	protected function setProperty(const property, const value) -> void
	{
		this->loadProperties();
		this->archiveOriginalProperties();
		this->callSetMutator(property, value);
	}

	protected function issetProperty(const property) -> boolean
	{
		this->loadProperties();
		return this->properties->has(property);
	}
	
	protected function unsetProperty(const property) -> void
	{
		this->loadProperties();
		this->archiveOriginalProperties();
		this->properties->forget(property);
	}

	// Lazy load & archive

	protected function loadProperties() -> void
	{
		if this->properties == null {
			if this->exists {
				var properties, command, property, value;
				let command = explode("\\", get_class(this));
				let command = end(command);
				let command = lcfirst(command)."Properties";
				let properties = Graph::command(command, [this->id]);
				let this->properties = new Collection();
				for property, value in properties {
					this->callSetMutator(property, value);
				}
			} else {
				let this->properties = new Collection;
			}
		}
	}

	protected function archiveOriginalProperties() -> void
	{
		if this->exists && this->originalProperties == null {
			let this->originalProperties = clone this->properties;
		}
	}

	// Mutators [& Sanitizers ???]

	protected function callGetMutator(const string property) -> var
	{
		var value, name;
		let value = this->properties->get(property);
		let name = this->hasGetMutator(property);
		if name != false {
			let value = this->{name}(value);
		}
		return value;
	}

	protected function callSetMutator(const string property, value) -> void
	{
		var name;
		let name = this->hasSetMutator(property);
		if name != false {
			let value = this->{name}(value);
		}
		this->properties->set(property, value);
	}

	protected function hasGetMutator(const string property) -> boolean
	{
		return this->methodExists("get", property, "Property");
	}

	protected function hasSetMutator(const string property) -> boolean
	{
		return this->methodExists("set", property, "Property");
	}

	protected function methodExists(const string prefix = null, const string name, const string sufix = null) -> boolean|string
	{
		var method = "";
		if prefix != null {
			let method = prefix.name->upperfirst();
		} else {
			let method = name;
		}
		if sufix != null {
			let method .= sufix;
		}
		if method_exists(this, method) {
			return method;
		} else {
			return false;
		}
	}

	// Dirt handling

	protected function isDirtyProperties() -> boolean
	{
		return !empty(this->getDirtyProperties());
	}

	protected function getDirtyProperties() -> array
	{
		this->loadProperties();
		this->archiveOriginalProperties();
		var dirty = [], key, value;
		for key, value in this->properties->all() {
			if !this->originalProperties->has(key) {
				let dirty[key] = value;
			} else {
				var numeric;
				let numeric = this->isPropertyNumericallyEquivalent(key);
				if value !== this->originalProperties->get(key) && !numeric {
					let dirty[key] = value;
				}
			}
		}
		return dirty;
	}

	protected function isPropertyNumericallyEquivalent(const string key) -> boolean
	{
		var current, original;
		let current = this->properties->get(key);
		let original = this->originalProperties->get(key);
		return is_numeric(current) && is_numeric(original) && strcmp((string) current, (string) original) === 0;
	}

	// Array access

	public function getIterator() -> <\ArrayIterator>
	{
		return new \ArrayIterator(this->properties->all());
	}

	public function offsetGet(const property) -> var
	{
		return this->getProperty(property);
	}

	public function offsetSet(const property, const value) -> void
	{
		this->setProperty(property, value);
	}

	public function offsetExists(const property) -> boolean
	{
		return this->issetProperty(property);
	}

	public function offsetUnset(const property) -> void
	{
		this->unsetProperty(property);
	}

}
