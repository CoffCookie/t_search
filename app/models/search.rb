class Search < ApplicationRecord
    validates :url, presence: true, uniqueness: true
end
