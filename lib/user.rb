require_relative './database_connection'
require 'bcrypt'

class User

  attr_reader :id, :email

  def initialize(id:, email:)
    @id = id
    @email = email
  end

  def self.create(email:, password:)
    return :invalid_email unless valid_email?(email)
    return :non_unique_email unless unique_email?(email)

    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query(
      "INSERT INTO users (email, password) 
       VALUES('#{email}', '#{encrypted_password}') 
       RETURNING id, email;")
    User.new(
      id: result[0]['id'], 
      email: result[0]['email'])
  end

  def self.find(id:)
    return nil unless id

    result = DatabaseConnection.query(
      "SELECT * 
       FROM users 
       WHERE id = '#{id}'")
    User.new(
      id: result[0]['id'], 
      email: result[0]['email'])
  end

  def self.authenticate(email:, password:)
    result = DatabaseConnection.query(
      "SELECT * 
       FROM users 
       WHERE email = '#{email}'")
    return unless result.any? 
    return unless BCrypt::Password.new(result[0]['password']) == password

    User.new(
      id: result[0]['id'], 
      email: result[0]['email'])
  end

  def self.unique_email?(email)
    result = DatabaseConnection.query(
      "SELECT * 
       FROM users 
       WHERE email = '#{email}'")
    return true unless result.any?
  end

  def self.valid_email?(email)
    email =~ URI::MailTo::EMAIL_REGEXP
  end
end
