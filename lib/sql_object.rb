require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    if @cols
      @cols
    else
      cols = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
        LIMIT
          0
      SQL
      @cols = cols[0].map(&:to_sym)
    end
  end

  def self.finalize!
    columns.each do |col_name|
      define_method(col_name) { self.attributes[col_name] }
      define_method(col_name.to_s + "=") { |val| self.attributes[col_name] = val}
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL
    if !result.empty?
      self.new(result[0])
    else
      nil
    end
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      if self.class.columns.include?(attr_name.to_sym)
        self.send(attr_name.to_s+"=", val)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |col| self.send(col) }
  end

  def insert
    col_names = self.class.columns.drop(1).join(", ")
    question_marks = self.class.columns.map { "?" }.drop(1).join(", ")
    col_values = attribute_values.drop(1)

    DBConnection.execute(<<-SQL, *col_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns.drop(1)
    col_values = attribute_values.drop(1)
    set_block = col_names.map do |name|
      name.to_s + " = ?"
    end.join(", ")

    DBConnection.execute(<<-SQL, *col_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_block}
      WHERE
        id = #{self.id}
    SQL

  end

  def save
    if self.id
      update
    else
      insert
    end
  end
end
