# Jumping through this hoop to ensure our overrides are loaded
# after the classes they are overriding
class IndexerCommon
  self.add_indexer_initialize_hook do |indexer|
    ASUtils.find_local_directories(File.join('indexer', 'lib')).each do |dir|
      Dir.glob(File.join(dir, "*.rb")).sort.each do |file|
        require file
      end
    end
  end
end
