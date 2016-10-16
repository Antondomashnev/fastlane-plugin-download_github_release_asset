module Fastlane
  module Actions
    class DownloadGithubReleaseAssetAction < Action
      def self.run(params)
        require 'open-uri'
        require 'fileutils'

        destination_path = File.expand_path(params[:destination_path].shellescape)
        prepare_destination_path(destination_path)

        UI.important("⏬ Downloading asset '#{params[:asset_url]}' to '#{destination_path}'...")
        download_asset(params[:asset_url], destination_path, params[:api_token])
      end

      def self.description
        "Downloads a GitHub release's asset"
      end

      def self.details
        "This action downloads a GitHub release's asset using the GitHub API and puts it in a destination path.\nIf the file has been previously downloaded, it will be overrided."
      end

      def self.authors
        ["Anton Domashnev"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :asset_url,
                                       env_name: "FL_GITHUB_RELEASE_ASSET_URL",
                                       description: "The URL to the desired asset in GitHub API",
                                       verify_block: proc do |value|
                                         UI.important("The URL doesn't start with http or https") unless value.start_with?("https")
                                       end,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :destination_path,
                                       env_name: "FL_GITHUB_RELEASE_ASSET_DOWNLOAD_DESTINATION_PATH",
                                       description: "The path to which save file",
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "FL_GITHUB_RELEASE_ASSET_API_TOKEN",
                                       description: "Personal API Token for GitHub - generate one at https://github.com/settings/tokens",
                                       is_string: true,
                                       optional: false)
        ]
      end

      def self.is_supported?(platform)
        true
      end

      private_class_method def self.download_asset(asset_url, destination_path, api_token)
        request_url = "#{asset_url}?access_token=#{api_token}"
        send_download_request(request_url, "fastlane-plugin_download_github_release_asset", "application/octet-stream", destination_path)
        compressed_file_size = File.size(destination_path).to_f / 2**20
        formatted_file_size = format('%.2f', compressed_file_size)
        UI.success("Download finished, total size: #{formatted_file_size} MB ✅")
      rescue => ex
        UI.user_error!("Error fetching release's asset: #{ex}")
      end

      private_class_method def self.send_download_request(request_url, user_agent, accept, destination_path)
        step = 0
        partial = 0
        progress = 0
        File.open(destination_path, "wb") do |saved_file|
          # the following "open" is provided by open-uri
          open(request_url, "User-Agent" => user_agent, "Accept" => accept, :content_length_proc => lambda do |t|
            if t && 0 < t
              step = t / 10
              partial = step
              formatted_file_size = format('%.2f', t.to_f / 2**20)
              UI.important("Total size: #{formatted_file_size} MB")
            end
          end,
          :progress_proc => lambda do |s|
            if s > partial
              partial += step
              return if step.zero?
              UI.message "#{progress}%"
              progress = (partial / step) * 10
            end
          end) do |read_file|
            saved_file.write(read_file.read)
          end
        end
      end

      private_class_method def self.prepare_destination_path(destination_path)
        dirname = File.dirname(destination_path)
        unless File.directory?(dirname)
          FileUtils.mkdir_p(dirname)
        end
      end
    end
  end
end
