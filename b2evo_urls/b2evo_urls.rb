
module Jekyll
    class Site
        def write_b2evo_symlinks
            dest = "#{self.dest}/index.php"
            Dir.mkdir dest unless File.exists? dest
            Dir.foreach(self.dest) do |d|
                if /20[0-9]{2}/.match d
                    File.symlink("../#{d}", "#{dest}/#{d}") unless File.exists? "#{dest}/#{d}"
                end
            end
        end
    end

    AOP.after(Site, :write) do |site_instance, args, proceed, abort|
        site_instance.write_b2evo_symlinks
        true
    end
end
