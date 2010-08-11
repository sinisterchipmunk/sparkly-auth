class RemembranceToken < ActiveRecord::Base
  unloadable
  belongs_to :authenticatable, :polymorphic => true
  validates_presence_of :series_token
  validates_presence_of :remembrance_token
  validates_presence_of :authenticatable
  
  def value
    "#{authenticatable_type}|#{authenticatable_id}|#{series_token}|#{remembrance_token}"
  end
  
  before_validation :regenerate_remembrance_token
  
  def regenerate_remembrance_token
    regenerate if new_record?
  end
  
  def should_equal(remembrance_token)
    @theft = self.remembrance_token != remembrance_token
  end
  
  def theft?
    @theft
  end
  
  def regenerate
    if attributes.keys.include?('series_token')
      # We need to only ever generate the series token once per record.
      self.series_token ||= Auth::Token.new.to_s
    end
    
    if attributes.keys.include?('remembrance_token')
      # We need to regenerate the auth token every time the record is saved.
      self.remembrance_token = Auth::Token.new.to_s
    end
  end
  
  class << self
    def find_by_value(value)
      authenticatable_type, authenticatable_id, series_token, remembrance_token = *value.split(/\|/)
      return nil if authenticatable_type.blank? || authenticatable_id.blank? || series_token.blank?
      
      token = RemembranceToken.find(:first, :conditions => {
                :authenticatable_type => authenticatable_type,
                :authenticatable_id => authenticatable_id,
                :series_token => series_token
              })
      token.should_equal(remembrance_token)
      token
    end
  end
end
