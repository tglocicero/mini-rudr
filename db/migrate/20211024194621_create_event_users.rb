class CreateEventUsers < ActiveRecord::Migration[6.1]
    def change
        create_table :event_users do |t|
            t.integer :user_id
            t.integer :event_id
            t.integer :response, default: 0
            t.boolean :present, default: true, null: false

            t.timestamps
        end
    end
end
