class AddUsernameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :username, :string, default: "no_username", null: false
  end
end
