require_relative('../db/sql_runner')

class Screening

  attr_accessor :film, :time_of_screening, :tickets_available

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id']
    @time = options['time']
    @tickets_available = tickets_available
  end

  def save()
    sql = "INSERT INTO screenings (film_id, time_of_screening, tickets_available) VALUES ($1, $2, $3) RETURNING id"
    values = [@film_id, @time, @tickets_available]
    screening = SqlRunner.run(sql, values)[0];
    @id = screening['id']
  end
  #
  # def update()
  #   sql = "UPDATE screenings SET (film_id, time, tickets_available) = ($1, $2, $3) WHERE id = $4"
  #   values = [@film_id, @time, @tickets_available, @id]
  #   SqlRunner.run(sql, values)
  # end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end
