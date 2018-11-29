# == Schema Information
#
# Table name: sponsors
#
#  id      :integer          not null, primary key
#  name    :string
#  picture :string
#  url     :string
#

class Sponsor < ActiveRecord::Base
  mount_uploader :picture, ImageUploader

  has_and_belongs_to_many :arenas

  validates :name, :url, :picture, presence: true
  validates :name, uniqueness: true
end
