# == Schema Information
#
# Table name: arena_content_greenlights_counts
#
#  arena_id :integer
#  sum      :integer
#

class ArenaContentGreenlightsCount < ActiveRecord::Base
  include ViewResult
  include Refreshable
end
