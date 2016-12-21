# RubyArchive

RubyArchive connects classes to relational database tables to establish a persistence layer for applications. It allows for models to be connected to other models by defining associations.

RubyArchive relies heavily on naming in that it uses class and association names to establish mappings between respective database tables and foreign key columns. Although these mappings can be defined explicitly, it's recommended to follow naming conventions, especially when getting started with the library.

## API

### my_attr_accessor

Defines specific setter and getter methods on a class for a given instance variable name.

### table_name

A table name can be automatically set using the inflector library, or it can be manually set with the setter method. A table name can also be retrieved from a model by calling the getter method.

### all

Returns all the rows and columns for a given model.

### find

Returns a row in the model's table corresponding to the given id.

### attributes

The attributes hash stores all the columns of an instance of a particular model.

### insert, update, save

These are the basic SQL functions to insert rows into a table, update a specific row, or save a new row. Save will either call update or insert based on whether the record already exists in the table.

### where

This method accepts either a string or a hash. For a string, it will use the input value as the where clause. For a hash, it will construct a valid SQL where clause with keys pointing to their values.

### belongs_to

The belongs_to association takes a name and an options hash. The options hash sets the primary_key, foreign_key, and class_name to be used for the association. The name is called on the model to retrieve information via the SQL query that this method creates.

### has_many

Similar to belongs_to. It returns the potentially many instances of another class that belong to the instance of the class the named method is called on.

### has_one_through

This association can be used if one model can belong to another model via a belongs_to association in the intermediate model.
