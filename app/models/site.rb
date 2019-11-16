class Site < ApplicationRecord
    mount_uploader :screenshot, ScreenUploader
    mount_uploader :preview_screenshot, ScreenUploader

    after_commit :screenable

    def screenable
      generate_screen
      generate_preview_screen
    end
    def generate_screen
      screenshot_file = Tempfile.new(['screen','.png'])
      begin
        cmd = "node #{Rails.root.join('node-screen/node_screen.js')} --url #{url} --fullPage true --screen_path #{screenshot_file.path} "
        `#{cmd}`
        if $?.success?
          self.class.skip_callback(:commit, :after, :screenable)
          self.screenshot = screenshot_file
          self.save
          self.class.set_callback(:commit, :after, :screenable)
        else
          raise "result = #{$?}; command = #{cmd}"
        end
      ensure
         screenshot_file.close
         screenshot_file.unlink
      end
    end
    def generate_preview_screen
      screenshot_file = Tempfile.new(['screen2','.png'])
      begin
        cmd = "node #{Rails.root.join('node-screen/node_screen.js')} --url #{url} --screen_path #{screenshot_file.path}"
        `#{cmd}`
        if $?.success?
          self.class.skip_callback(:commit, :after, :screenable)
          self.preview_screenshot = screenshot_file
          self.save
          self.class.set_callback(:commit, :after, :screenable)
        else
          raise "result = #{$?}; command = #{cmd}"
        end
      ensure
         screenshot_file.close
         screenshot_file.unlink
      end
    end
end
