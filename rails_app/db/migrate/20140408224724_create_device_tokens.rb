class CreateDeviceTokens < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|
      t.string :ip
      t.date :expires
      t.string :token

      t.timestamps
    end
  end
end
