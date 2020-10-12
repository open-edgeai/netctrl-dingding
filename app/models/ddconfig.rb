class Ddconfig < ApplicationRecord
    validates :CorpId, presence: true, :on => :create 
    validates :AppKey, presence: true, :on => :create 
    validates :AppSecret, presence: true, :on => :create 
    validates :AgentId, presence: true, :on => :create 
end
