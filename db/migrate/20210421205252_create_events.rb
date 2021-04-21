class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.jsonb :google_data
      t.string :category
      t.references :user
      t.timestamps
    end
  end
end
