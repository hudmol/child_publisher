# Child Publisher

An ArchivesSpace plugin that adds the ability to publish and unpublish all child records of an archival object.

Developed against ArchivesSpace v2.4.0 by Hudson Molonglo for Yale University.


## Summary

Two new options are available in the `More` menu on the component toolbar for components that have children - `Publish All Children` and `Unpublish All Children`. When selected, all child components of the current component will be published or unpublished respectively.

The published state of the current component and its nested records is unchanged.

The published state of some `Note` records attached to child components is also unchanged.

Currently, this filtering is not configurable.


## Installation

Follow standard ArchivesSpace plugin installation procedures.

This plugin is not dependent on any additional gems, does not require any database migrations, and does not override any existing templates.

It does override some backend methods, see below.


## Customization

To enable the filtering mentioned above this plugin overrides two backend methods, namely:

  - `ObjectGraph.calculate_object_graph(object_graph, opts = {})`
  - `Notes.calculate_object_graph(object_graph, opts = {})`

These methods have been changed to accept `opts` keyed on a model with a value that is a Sequel dataset on that model. They allow for filtering of nested records and notes respectively.

There are other implementations of `calculate_object_graph(object_graph, opts = {})` that have not yet been overridden to support filtering with opts like this - the goal was to override as little as possible.

To customize the filtering behavior, call `ChildPublishing.add_filter(filter)`. For example:

```ruby
    # turn off the default note filtering
    ChildPublishing.add_filter(Note)
```

See [here](https://github.com/hudmol/child_publisher/blob/master/backend/plugin_init.rb) for the call that sets the Note filter.

