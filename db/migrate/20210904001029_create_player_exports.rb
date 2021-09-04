class CreatePlayerExports < ActiveRecord::Migration[6.1]
  def change
    create_table :player_exports do |t|

      t.string :export_url
      
      t.timestamps
    end
  end
end
