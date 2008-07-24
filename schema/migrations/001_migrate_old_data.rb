migration(1, :migrate_old_data) do
  up do
    modify_table :referrers do
      drop_column :site_url
      add_column :site_url, String, :length => 255, :nullable => true
    end
    Referrer.all.each{|r|r.extract_site_url;r.save}
    Statistic.auto_migrate!
    Statistic.update_stats
  end

  down do
    modify_table :referrers do
      drop_column :site_url
      add_column :site_url, String, :length => 50, :nullable => true
    end
    drop_table :statistics
  end
end
