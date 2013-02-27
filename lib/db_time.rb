module DB_time
  def time_diff(date_from, date_to)
    if connection.adapter_name == 'PostgreSQL'

    else
      "DATEDIFF(#{date_from},#{date_to})"
    end
  end
end