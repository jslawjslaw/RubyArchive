require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
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

    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
