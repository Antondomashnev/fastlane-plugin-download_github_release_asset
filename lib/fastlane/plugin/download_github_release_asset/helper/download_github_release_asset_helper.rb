module Fastlane
  module Helper
    class DownloadGithubReleaseAssetHelper
      # class methods that you define here become available in your action
      # as `Helper::DownloadGithubReleaseAssetHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the download_github_release_asset plugin helper!")
      end
    end
  end
end
