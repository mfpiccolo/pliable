module MigrationHelper
  def support_create_extension?
    # Assume that 9.1 or later supports CREATE EXTENSION
    version_parts = select_value("SELECT version()").match(/PostgreSQL ([\d\.]*)/)[1].split('.')
    version_parts[0].to_i >= 9 && version_parts[1].to_i >= 1
  end

  # Install the extension named extension_name
  def install_extension(extension_name, function_name = nil)
    if support_create_extension?
      if select_value(%Q{select extname from pg_extension where extname = '#{extension_name}'}).nil?
        execute "CREATE EXTENSION #{extension_name}"
      end
    else
      # Speculating that the extension installs a function of the same name
      function_name ||= extension_name
      unless select_value("SELECT proname FROM pg_proc WHERE proname = '#{function_name}'")
         puts "*" * 60
         puts ""
         puts "You need to install the #{extension_name} extension"
         puts ""
         sharedir = `pg_config --sharedir 2>&1`.strip
         if $?.to_i > 0
           puts "First, you need to know SHAREDIR - maybe something like `pg_config --sharedir`?"
           puts ""
           sharedir = 'SHAREDIR'
         end
         puts "Try `psql -d #{connection.current_database} -f #{sharedir}/contrib/#{extension_name}.sql`"
         puts ""
         puts "*" * 60
         raise "Extension #{name} not installed."
      end
    end
  end
  def uninstall_extension(extension_name)
    if support_create_extension?
      execute "DROP EXTENSION #{extension_name}"
    else
      puts "Skipping uninstall of extension #{extension_name}"
    end
  end
end