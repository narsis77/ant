#pragma once

#include <databinding/DataTypes.h>
#include <databinding/DataVariable.h>
#include <memory>
#include <string>
#include <unordered_map>
#include <unordered_set>

namespace Rml {

class Element;
class Node;

class DataView;
using DataViewPtr = std::unique_ptr<DataView>;

class DataModel {
public:
	DataModel();
	~DataModel();

	DataModel(const DataModel&) = delete;
	DataModel& operator=(const DataModel&) = delete;

	void AddView(DataViewPtr view);

	bool BindVariable(const std::string& name, DataVariable variable);

	bool InsertAlias(Node* element, const std::string& alias_name, DataAddress replace_with_address);
	bool EraseAliases(Node* element);

	DataAddress ResolveAddress(const std::string& address_str, Node* element) const;

	DataVariable GetVariable(const DataAddress& address) const;
	bool GetVariableInto(const DataAddress& address, DataVariant& out_value) const;

	void DirtyVariable(const std::string& variable_name);
	bool IsVariableDirty() const;
	void MarkDirty();
	bool IsDirty() const;
	void OnElementRemove(Element* element);
	void Update();

private:
	using DataViewList = std::vector<DataViewPtr>;
	using NameViewMap = std::unordered_multimap<std::string, DataView*>;
	using ScopedAliases = std::unordered_map<Node*, std::unordered_map<std::string, DataAddress>>;

	DataViewList views;
	DataViewList views_to_add;
	NameViewMap name_view_map;
	std::unordered_map<std::string, DataVariable> variables;
	DirtyVariables dirty_variables;
	ScopedAliases aliases;
	bool dirty = false;
};

}
