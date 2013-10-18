Puppet::Type.type(:db_migration).provide :db_migration do
  desc "db_migration is used to deploy database migrations using daticaldb's hammer command"

  #FIXME this should probably be dynamic, based on install path
  commands :hammer => "/usr/local/DaticalDB/repl/hammer"

  def exists?
    #exists is a bit of an odd fit here...
    return File.exists? @resource[:path]
  end

  def latest?
    return false unless File.exists? @resource[:path] 

    #hammer requires CWD be in the project FIXME project path parameter would be better
    Dir.chdir(@resource[:path])

#Database 'Source' contains no project information!
#Database 'Source' is up-to-date.
#Database 'Source' is at [changesetId=1, author=paul, filepath=Changelog/changelog.xml], 1 changeset behind the latest change [changesetId=2, author=paul, filepath=/datical/projects/Test/Changelog/changelog.xml].

    output = hammer 'status', @resource[:db_instance]

    if ( output =~ /is up-to-date./ )
      return true
    else
      return false #FIXME need a way to tell if hammer just failed.
    end
  end

  def update
    #hammer requires CWD be in the project FIXME project path parameter would be better
    Dir.chdir(@resource[:path])

    output = hammer 'deploy', @resource[:db_instance]

    output =~ /Report ready at file:(.*)/

    report_location = $1

    deploy_report = File.read(report_location)
  end
end
