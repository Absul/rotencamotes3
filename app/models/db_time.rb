class DB_time
  def time_diff(date_from, date_to)
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      "DATE_PART('day', #{date_to} - #{date_from})"
    else
      "DATEDIFF(#{date_from},#{date_to})"
    end
  end
end