class AddSignupReasonToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :signup_reason, :string, limit: 3000
    add_column :users, :allowed_in, :boolean, default: true, null: false
  end
end
