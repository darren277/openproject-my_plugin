class CreateGamificationTables < ActiveRecord::Migration[7.0]
  def change
    create_table :gamification_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :points, default: 0, null: false
      t.integer :level, default: 1, null: false
      t.timestamps
    end
    
    create_table :gamification_activities do |t|
      t.references :gamification_profile, null: false, foreign_key: true
      t.string :activity_type, null: false
      t.string :description, null: false
      t.integer :points, default: 0, null: false
      t.references :related_object, polymorphic: true
      t.text :metadata
      t.timestamps
    end
    
    create_table :achievements do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :icon, null: false
      t.integer :points, default: 10, null: false
      t.text :criteria
      t.timestamps
    end
    
    create_table :user_achievements do |t|
      t.references :gamification_profile, null: false, foreign_key: true
      t.references :achievement, null: false, foreign_key: true
      t.timestamps
      
      t.index [:gamification_profile_id, :achievement_id], unique: true, name: 'unique_user_achievements'
    end
  end
end
