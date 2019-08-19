require_relative("../db/sql_runner")
require_relative("ticket")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE from customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return Film.map_items(film_data)
  end

  def self.map_items(data)
    result = data.map{|customer| Customer.new(customer)}
    return result
  end

  def films_to_be_charged()
    sql = "SELECT * FROM tickets INNER JOIN films ON tickets.film_id = films.id WHERE customer_id = $1"
    values = [@id]
    film_and_ticket_data = SqlRunner.run(sql, values)
    return film_and_ticket_data.map { |film| Film.new(film)}
  end

  def remaining_funds()
    films = self.films_to_be_charged
    film_payments = films.map{ |film| film.price }
    combined_payments = film_payments.sum
    @funds = @funds - combined_payments
    update
    return @funds
  end

  def how_many_tickets()
    sql = "SELECT * FROM tickets INNER JOIN customers ON customers.id = customer_id WHERE customer_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    tickets.count
  end

  def spend(film)
    if @funds >= film.price
       @funds = @funds - film.price
     end
  end

  def buy_ticket(film)
    self.spend(film)
    new_ticket = Ticket.new({'customer_id' => @id, 'film_id' => film.id})
    new_ticket.update
    new_ticket.save
  end
end
