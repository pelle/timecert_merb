migration(2, :create_sites) do
  up do
    modify_table :sites do
      add_column :title,String
      add_column :referrer_count,Integer
      add_column :digest_count,Integer
    end
    Site.update_stats
  end

  down do
    modify_table :referrers do
      drop_column :title
      drop_column :referrer_count
      drop_column :digest_count
    end
  end
end
