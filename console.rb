require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry')

Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Johnny', 'funds' => 30})
customer1.save

customer2 = Customer.new({'name' => 'Scotty', 'funds' => 15})
customer2.save

customer3 = Customer.new({'name' => 'Craig', 'funds' => 50})
customer3.save

film1 = Film.new({'title' => 'Trainspotting', 'price' => 10})
film1.save

film2 = Film.new({'title' => 'Pulp Fiction', 'price' => 15})
film2.save

film3 = Film.new({'title' => 'Goodfellas', 'price' => 5})
film3.save

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film3.id})
ticket1.save


binding.pry
nil
