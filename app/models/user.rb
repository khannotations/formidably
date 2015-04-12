class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, 
         :recoverable, :trackable, :validatable, :confirmable

  belongs_to :organization

  validates_presence_of :email
  validates_uniqueness_of :email

  def serializable_hash(options={})
    options = {
      :include => :organization,
      :except => [
        :created_at, :updated_at, :uid, :provider
      ],
      :methods => []
    }.update(options)
    super(options)
  end
end
