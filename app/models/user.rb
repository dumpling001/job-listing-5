class User < ApplicationRecord
  has_many :resumes
  has_many :jobs

  has_many :job_to_user
  has_many :participated_jobs, :through => :job_to_user, :source => :job

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

def admin?
  is_admin
end
end
