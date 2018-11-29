# == Schema Information
#
# Table name: redirection_hits
#
#  id         :integer          not null, primary key
#  origin     :string
#  path       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RedirectionHit < ActiveRecord::Base
end
