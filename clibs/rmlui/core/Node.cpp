#include <core/Node.h>
#include <core/Element.h>

namespace Rml {

Node::Node(Layout::UseElement use)
	: layout(use)
{}

Node::Node(Layout::UseText use, void* context)
	: layout(use, context)
{}

Node::~Node()
{}

Layout& Node::GetLayout() {
	return layout;
}

const Layout& Node::GetLayout() const {
	return layout;
}

bool Node::IsVisible() const {
	return visible;
}

void Node::SetVisible(bool visible) {
	layout.SetVisible(visible);
}

void Node::SetParentNode(Element* parent_) {
	parent = parent_;
}

Element* Node::GetParentNode() const {
	return parent;
}

void Node::DirtyLayout() {
	layout.MarkDirty();
}

DataModel* Node::GetDataModel() const {
	return data_model;
}

Layout::Type Node::GetType() const {
	return layout.GetType();
}

void Node::UpdateLayout() {
	if (layout.HasNewLayout()) {
		visible = layout.IsVisible();
		if (visible) {
			bounds = layout.GetBounds();
			CalculateLayout();
		}
	}
}

const Rect& Node::GetBounds() const {
	return bounds;
}

}
