require_relative '02_searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name}_id".to_sym,
      class_name: name.to_s.camelcase,
      primary_key: :id
    }

    defaults.each do |key, val|
      if options[key]
        self.send(key.to_s + "=", options[key])
      else
        self.send(key.to_s + "=", val)
      end
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name}_id".downcase.to_sym,
      class_name: name.to_s.singularize.camelcase,
      primary_key: :id
    }

    defaults.each do |key, val|
      if options[key]
        self.send(key.to_s + "=", options[key])
      else
        self.send(key.to_s + "=", val)
      end
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      val = self.send(options.foreign_key)

      results = options.model_class.where(options.primary_key => val)
      if results.empty?
        nil
      else
        results
      end
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      val = self.send(options.primary_key)

      options.model_class.where(options.foreign_key => val)
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end

class SQLObject
  extend Associatable
end
