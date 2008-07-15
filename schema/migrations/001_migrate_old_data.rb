migration(1, :migrate_old_data) do
  up do
    execute "insert into stamps select digest,timestamp from timecert_stamps"
  end

  down do
  end
end
