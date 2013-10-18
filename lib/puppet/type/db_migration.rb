Puppet::Type.newtype(:db_migration) do
  @doc = "db_migration allows you to run a daticaldb hammer migration from a daticaldb project.
  "

  ensurable do
    desc "Whether to perform schema updates or not"

    newvalue(:latest) do
      provider.update
    end

    newvalue(:present) do
    end
  end

  autorequire(:package) do
    "DaticalDB"
  end

  newparam(:path) do
    desc "the path of the daticaldb project this will deploy"
    
    #FIXME, validate physical path?
  end

  newparam(:db_instance) do
    desc "the DB Instance path of the daticaldb project this will deploy"
  end

  newparam(:name) do
    isnamevar
    desc ""
  end
end
