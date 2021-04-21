class AddOmniauthToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :token, :string
    add_column :users, :refresh_token, :string
    add_column :users, :expires, :string
    add_column :users, :expires_at, :string
    add_column :users, :google_auth, :jsonb
  end
end
