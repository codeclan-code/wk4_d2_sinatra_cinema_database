require_relative("../db/sql_runner")

class Film

  attr_reader :id
  attr_accessor :title, :price


  def initialize(options)
    @id = options['id'] if ['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def self.all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    # films.each { |film| p film["title"]}
    films.map { |film| Film.new(film) }
    # films.each { |film| p film.title }
    end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE from films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT * FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE film_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    return Customer.map_items(customer_data)
  end

  def self.map_items(data)
    result = data.map{|film| Film.new(film)}
    return result
  end

  def size_of_audience
    sql = "SELECT customer_id FROM tickets INNER JOIN customers ON tickets.customer_id = customers.id WHERE film_id = $1"
    values = [@id]
    audience = SqlRunner.run(sql, values)
    audience.count
  end

  end
