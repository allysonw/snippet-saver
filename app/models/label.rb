class Label < ActiveRecord::Base
  has_many :snippet_labels
  has_many :snippets, through: :snippet_labels
  belongs_to :user

  validates_presence_of :name, :color
end
