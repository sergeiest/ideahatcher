class CreateUnivaffiliations < ActiveRecord::Migration
  def change
    create_table :univaffiliations do |t|
      t.string  :title_name

      t.timestamps
    end
  end
end
