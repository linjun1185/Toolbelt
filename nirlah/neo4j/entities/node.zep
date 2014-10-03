namespace Nirlah\Neo4j\Entities;

use Nirlah\Neo4j\Graph;
use Nirlah\Collection;

class Node extends Entity {

	protected labels;
	protected originalLabels;

	public function __construct(const config)
	{
		parent::__construct(config);
	}

	protected function parseObject(const config) -> void
	{
		// Properties:
		var property, value;
		let this->properties = new Collection();
		for property, value in get_object_vars(config->data) {
			this->callSetMutator(property, value);
		}

		// Labels:
		let this->labels = config->metadata->labels;

		// ID:
		this->setId((int) config->metadata->id);
	}

	protected function parseArray(const array config) -> void
	{
		// 
		// TODO
		// 
	}

	// 
	// Labels
	// 

	public function labels() -> array
	{
		this->loadLabels();
		return this->labels;
	}

	public function hasLabel(const string label) -> boolean
	{
		this->loadLabels();
		return in_array(label, this->labels);
	}
	
	public function addLabel(const string label) -> void
	{
		this->loadLabels();
		this->archiveOriginalLabels();
		if !this->hasLabel(label) {
			let this->labels[] = ucfirst(label);
		}
	}
	
	public function removeLabel(const string label) -> void
	{
		this->loadLabels();
		this->archiveOriginalLabels();
		var key;
		let key = array_search(label, this->labels);
		if typeof key == "int" {
			var labels;
			let labels = this->labels;
			unset(labels[key]);
			let this->labels = labels;
		}
	}

	protected function loadLabels() -> void
	{
		if this->labels == null {
			if this->exists {
				let this->labels = Graph::command("nodeLabels", [this->id]);;
			} else {
				let this->labels = [];
			}
		}
	}

	protected function archiveOriginalLabels() -> void
	{
		if this->exists && this->originalLabels == null {
			let this->originalLabels = this->labels;
		}
	}

}
