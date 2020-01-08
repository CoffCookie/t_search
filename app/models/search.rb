class Search < ApplicationRecord
    validates :url, presence: true, uniqueness: true, on: :create
end
