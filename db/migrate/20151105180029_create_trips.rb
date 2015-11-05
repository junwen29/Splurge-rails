class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string      :title
      t.datetime    :date

      t.decimal     :latitude,  :precision => 13, :scale => 10
      t.decimal     :longitude, :precision => 13, :scale => 10

      t.string      :city
      t.string      :state
      t.string      :country
      t.string      :street
      t.string      :zipcode
      t.references  :user
      t.timestamps  null: false
    end
  end
end
