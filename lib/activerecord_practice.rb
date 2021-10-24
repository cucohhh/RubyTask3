require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  
  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where("first == 'Candice'")
  end
  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where("email like '%@%'")
    #Customer.find_by_sql("SELECT ")
  end

  def self.with_dot_org_email
    Customer.where("email like '%org'")
    #Customer.find_by_sql("SELECT * FROM customers WHERE email like '%org'")
  end

  def self.with_invalid_email
    #Customer.where("email not '@'")  
    #select cardno,name from cardtable where cardno not in (select cardno from cardtable where name='C'
    #Customer.find_by_sql("SELECT * FROM customers WHERE email not in (SELECT email FROM customers WHERE email like '%@%')  ")
    #Customer.select(*)
    Customer.where.not("email like '%@%'")
  end 

  def self.with_blank_email
    #Customer.find_by_sql("SELECT * FROM customers WHERE email==BLANK")
    # etc. - see README.md for more details
    # User.where.not('nickname = ?','nil').limit(2).unscope(:limit)
    # => 找到nickname不是空的user数据，unscope(:limit) 把limit限制给删除了
    # User.select{ |user| user.realname == nil }
    # => 输出 所有 realname 没有值的数据
    Customer.where(email:nil)
  end

  def self.born_before_1980
    Customer.where("birthdate < '1980-01-01'")
  end 


  def self.twenty_youngest
    Customer.order("birthdate DESC").limit 20

  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("email like '%@%' and birthdate <'1980-01-01'")
  end

  def self.last_names_starting_with_b
    #User.create(name: "A Nother", email: "another@example.org")
    Customer.where("last like 'B%'").order("birthdate")
  end

  def self.update_gussie_murray_birthdate
    Customer.where(first:'Gussie').update_all(birthdate:'2004.02.08')
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where.not("email like '%@%'").update_all(email:nil)
  end

  def self.delete_meggie_herman
    Customer.delete_all(first:'Meggie')
  end

  def self.delete_everyone_born_before_1978
    Customer.where("birthdate < '1978-01-01'").delete_all
  end
end
