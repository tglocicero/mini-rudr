class CreateEvents < ActiveRecord::Migration[6.1]
    def change
        create_table :events do |t|
            t.string :name
            t.integer :time, default: 1

            t.timestamps
        end
    end
end
