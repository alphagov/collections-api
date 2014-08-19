require 'ostruct'

class User < OpenStruct
  include GDS::SSO::User

  def self.create!(args)
    new(args)
  end

  def self.where(*args)
    []
  end

  def clear_remotely_signed_out!; end

  def save!; end

  # :mock_gds_sso
  def update_attribute(key, value)
    send("#{key}=", value)
  end

  # :mock_gds_sso
  def self.first
    new
  end
end
