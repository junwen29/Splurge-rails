
module Trip::Json
  extend ActiveSupport::Concern

  def to_json(json, options ={})
    json.id         self.id
    json.title      self.title
    json.date       self.date.strftime("%Y-%m-%dT%H:%M:%SZ%Z")
    json.city       self.city
    json.country    self.country
    json.state      self.state
    json.street     self.street
    json.zipcode    self.zipcode
    json.latitude   self.latitude
    json.longitude  self.longitude
    json.user do
      self.user.to_json(json)
    end
  end
end