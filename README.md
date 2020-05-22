# Child Publisher

An ArchivesSpace plugin that adds the ability to publish and unpublish all child
records of an archival object.

Developed against ArchivesSpace v2.7.1 by Hudson Molonglo for Yale University.


## Summary

Two new options are available in the `More` menu on the component toolbar for
components that have children - `Publish this and all children` and
`Unpublish all children`. When selected, all child components of the current
component will be published or unpublished respectively.

In the case of publication the current record is also published. When
unpublishing the published state of the current component and its nested records
is unchanged.

The published state of some `Note` records attached to child components is also
unchanged.

Currently, this filtering is not configurable.


## Installation

Follow standard ArchivesSpace plugin installation procedures.

This plugin is not dependent on any additional gems, does not require any
database migrations, and does not override any existing templates.


## Customization

To customize the filtering behavior, call `ChildPublishing.add_filter(filter)`.
For example:

```ruby
    # turn off the default note filtering
    ChildPublishing.add_filter(Note)
```

See [here](https://github.com/hudmol/child_publisher/blob/master/backend/plugin_init.rb)
for the call that sets the Note filter.

