require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    if params.is_a?(String)
      results = DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
        WHERE
          #{params}
      SQL
    else
      values = params.values
      where_clause = params.keys.map do |key|
        key.to_s + " = ?"
      end.join(" AND ")

      results = DBConnection.execute(<<-SQL, *values)
        SELECT
          *
        FROM
          #{table_name}
        WHERE
          #{where_clause}
      SQL
    end

    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
