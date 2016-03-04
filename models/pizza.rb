require( 'pg' )

class Pizza

  attr_reader(:id, :first_name, :last_name, :topping, :quantity )

  def initialize( options )
    @id = nil || options['id']  #bcos when u create it won't have an id yet
    @first_name = options['first_name']
    @last_name = options['last_name']
    @topping = options['topping']
    @quantity = options['quantity'].to_i
  end

  def pretty_name()
    return @first_name.concat(" #{@last_name}")
  end

  def total() 
    return @quantity * 10
  end

  def save()
    sql = "INSERT INTO pizzas ( 
      first_name, 
      last_name, 
      topping, 
      quantity ) VALUES (
      '#{ @first_name }',
      '#{ @last_name }',
      '#{ @topping }',
      '#{ @quantity }'
      )"

      Pizza.run_sql(sql)
  end

  def self.all()
    pizzas = Pizza.run_sql("SELECT * FROM pizzas")  # nb sql don't need ; here
    result = pizzas.map { |pizza| Pizza.new( pizza ) }
    
    return result
  end

  def self.find(id)
    pizza = Pizza.run_sql( "SELECT * FROM pizzas WHERE id = #{id}")  
    result = Pizza.new(pizza.first) # or could be pizza[0]
    return result
  end

  def self.update(options)
      sql = "UPDATE pizzas SET
            first_name = '#{options['first_name']}' ,    
            last_name = '#{options['last_name']}' ,    
            topping = '#{options['topping']}' ,    
            quantity = '#{options['quantity']}'       
            WHERE id = '#{options['id']} '" 
    Pizza.run_sql(sql)  
    #  no need to return anything
  end

  def self.destroy(id)
    Pizza.run_sql("DELETE FROM pizzas where id = #{id}")
  end



private

  def self.run_sql(sql)
    begin
      db = PG.connect( { dbname: 'pizza_shop', host: 'localhost' } )
      result = db.exec( sql )
      return result
    ensure
      db.close
    end
  end



end