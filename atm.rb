require 'yaml'
require 'io/console'
require_relative './helpers.rb'

config = YAML.load_file(ARGV.first || './config.yml')

puts 'Please Enter Your Account Number:'
account_number = gets.chomp
puts 'Enter Your Password:'
account_password = STDIN.noecho(&:gets).chomp

if ACCOUNTS[account_number.to_i].nil?
  puts 'ERROR: WRONG ACCOUNT NUMBER'
  return
else
  if account_password == ACCOUNTS[account_number.to_i]['password']
    puts '-' * 50
    puts "Hello, #{ACCOUNTS[account_number.to_i]['name']}\n"
  else
    puts 'ERROR: ACCOUNT NUMBER AND PASSWORD DON\'T MATCH'
    return
  end
end

loop do
  puts "\nPlease Choose From the Following Options:
      1. Display Balance
      2. Withdraw
      3. Log Out\n"
  option = gets.chomp.to_i

  case option
    when 1
      puts "\nYour Current Balance is ₴#{ACCOUNTS[account_number.to_i]['balance']}" 
    when 2
      loop do
        puts "\nEnter Amount You Wish to Withdraw:\n"
        amount = gets.chomp.to_i

        if amount > money_in_atm
          puts "\nTHE MAXIMUM AMOUNT AVALIBLE IN THIS ATM IS ₴#{money_in_atm}. PLEASE ENTER A DIFFERENT AMOUNT\n" 
        elsif amount > ACCOUNTS[account_number.to_i]['balance'].to_i
          puts "\nERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT\n"
        elsif !can_be_composed?(amount)
          puts "\nTHE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT\n"
        else
          new_balance = ACCOUNTS[account_number.to_i]['balance'].to_i - amount
          config['accounts'][account_number.to_i]['balance'] = new_balance
          File.open("./config.yml", 'w') { |f| YAML.dump(config, f) } 
          puts "\nYour New Balance is ₴#{new_balance}\n"
          break
        end
      end
    when 3
      puts "\n#{ACCOUNTS[account_number.to_i]['name']}, Thank You For Using Our ATM. Good-Bye!"
      return
    else 
      puts "\nERROR: WRONG INPUT\n"
  end
end


